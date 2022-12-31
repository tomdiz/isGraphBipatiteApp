# isGraphBipatiteApp

SwiftUI MVVM application using combine to see if a graph is bipartite.

## Application Structure

### isGraphBipatite/

### Helpers/
ReachabililtyHelper.swift - used for Crashlytics recording and sending message to server

### Models/
GraphData.swift - Graph data model and isBipartite testing code for the model type.
ModelData.swift - Standard model data class to load data from all models (only graph model). Loads data from JSON file for now.

### Resources/
JSON file of Graph data. Array of vertices for each node

### Views/
ContentView.swift - Main List view of Graphs from JSON file and test results.
GraphView.swift - Detail view of list view contents



## Installation for crash reporting

This project has BrackTrace and Crashlytics integrated so you can compare them. 

To install Backtrace you need to install using Pods and have an account from

https://bracktrace.io

You will need to add your subdomain and token to isGraphBipatiteApp.swift line 32


To install Crashlytics you need a GoogleService-Info.plist added to the project. You can get this file when you create a test account at Firebase website. 