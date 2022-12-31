//
//  isGraphBipatiteApp.swift
//  isGraphBipatite
//
//  Created by Thomas DiZoglio on 12/27/22.
//

import SwiftUI
import FirebaseCore
import FirebaseCrashlytics
import Backtrace

enum CustomError: Error {
    case runtimeError
}

func throwingFunc() throws {
    throw CustomError.runtimeError
}

class AppDelegate: NSObject, UIApplicationDelegate {

    // Backtrace
    let fileUrl = createAndWriteFile("sample.txt")

    func application(_ application: UIApplication,

                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        // https://github.com/backtrace-labs/backtrace-cocoa
        // https://docs.saucelabs.com/error-reporting/platform-integrations/ios/setup/
        let backtraceCredentials = BacktraceCredentials(endpoint: URL(string: "https://virgilsoftware.sp.backtrace.io:6098")!, token: "")

        let backtraceDatabaseSettings = BacktraceDatabaseSettings()
        backtraceDatabaseSettings.maxRecordCount = 10
        let backtraceConfiguration = BacktraceClientConfiguration(credentials: backtraceCredentials,
                                                             dbSettings: backtraceDatabaseSettings,
                                                             reportsPerMin: 10,
                                                             allowsAttachingDebugger: true,
                                                             detectOOM: true)
        BacktraceClient.shared = try? BacktraceClient(configuration: backtraceConfiguration)
        BacktraceClient.shared?.attributes = ["foo": "bar", "testing": true]
        BacktraceClient.shared?.attachments.append(fileUrl)
        BacktraceClient.shared?.delegate = self

        do {
            try throwingFunc()
        } catch {
            BacktraceClient.shared?.send(attachmentPaths: []) { (result) in
                print("AppDelegate:Result:\(result)")
            }
        }

        //BacktraceClient.shared?.loggingDestinations = [BacktraceBaseDestination(level: .debug)]
        BacktraceClient.shared?.loggingDestinations = [BacktraceFancyConsoleDestination(level: .debug)]

        // Enable error free metrics https://docs.saucelabs.com/error-reporting/web-console/overview/#stability-metrics-widgets
        BacktraceClient.shared?.metrics.enable(settings: BacktraceMetricsSettings())

        // Enable breadcrumbs https://docs.saucelabs.com/error-reporting/web-console/debug/#breadcrumbs-section
        BacktraceClient.shared?.enableBreadcrumbs()

        // Add breadcrumb
        let attributes = ["My Attribute":"My Attribute Value"]
        _ = BacktraceClient.shared?.addBreadcrumb("My Breadcrumb",
                                              attributes: attributes,
                                              type: .user,
                                              level: .error)

        return true
  }
    
    static func createAndWriteFile(_ fileName: String) -> URL {
        let dirName = "directory"
        let libraryDirectoryUrl = try! FileManager.default.url(
            for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let directoryUrl = libraryDirectoryUrl.appendingPathComponent(dirName)
        try? FileManager().createDirectory(
                    at: directoryUrl,
                    withIntermediateDirectories: false,
                    attributes: nil
                )
        let fileUrl = directoryUrl.appendingPathComponent(fileName)
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        let myData = formatter.string(from: Date())
        try! myData.write(to: fileUrl, atomically: true, encoding: .utf8)
        return fileUrl
    }
}
 
extension AppDelegate: BacktraceClientDelegate {
    func willSend(_ report: BacktraceReport) -> BacktraceReport {
        print("AppDelegate: willSend")
        return report
    }
    
    func willSendRequest(_ request: URLRequest) -> URLRequest {
        print("AppDelegate: willSendRequest")
        return request
    }
    
    func serverDidRespond(_ result: BacktraceResult) {
        print("AppDelegate:serverDidRespond: \(result)")
    }
    
    func connectionDidFail(_ error: Error) {
        print("AppDelegate: connectionDidFail: \(error)")
    }
    
    func didReachLimit(_ result: BacktraceResult) {
        print("AppDelegate: didReachLimit: \(result)")
    }
}


@main
struct isGraphBipatiteApp: App {

    // Crashlytics
    private var crashlyticsReference = Crashlytics.crashlytics()
    let reachabilityHelper = ReachabililtyHelper()

    // register app delegate for Backtrace setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject private var modelData = ModelData()

    func setUserInfo() {
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString("The request failed.", comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString(
              "The response returned a 404.",
              comment: ""
            ),
            NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(
              "Does this page exist?",
              comment: ""
            ),
            "ProductID": "123456",
            "UserID": "Jane Smith",
        ]
        let error = NSError(domain: NSURLErrorDomain, code: -1001, userInfo: userInfo)
        //Crashlytics.crashlytics().record(error: error)
    }

    func setCustomValues() {
        crashlyticsReference.setCustomValue(42, forKey: "MeaningOfLife")
        crashlyticsReference.setCustomValue("Test value", forKey: "last_UI_action")
        // Reachability is not compatible with watchOS
        #if !os(watchOS)
        let customKeysObject = [
            "locale": reachabilityHelper.getLocale(),
            "network_connection": reachabilityHelper.getNetworkStatus(),
        ] as [String: Any]
        crashlyticsReference.setCustomKeysAndValues(customKeysObject)
        reachabilityHelper.updateAndTrackNetworkStatus()
        #endif
        Crashlytics.crashlytics().setUserID("123456789")
    }
    
    init() {
        FirebaseApp.configure()
        Crashlytics.crashlytics().log("App loaded")
        setCustomValues()
        setUserInfo()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ModelData())
        }
    }
}
