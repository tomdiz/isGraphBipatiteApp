//
//  ContentView.swift
//  isGraphBipatite
//
//  Created by Thomas DiZoglio on 12/27/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData

    var allGraphs: [GraphData] {
        modelData.graphs
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(allGraphs) { graph in
                    NavigationLink {
                        GraphView(graph: graph)
                    } label: {
                        GraphView(graph: graph)
                    }
                }
            }
        }
        .navigationTitle("Graphs")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
