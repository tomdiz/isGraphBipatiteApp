//
//  GraphView.swift
//  isGraphBipatite
//
//  Created by Thomas DiZoglio on 12/27/22.
//

import SwiftUI

struct GraphView: View {
    var graph: GraphData

    var body: some View {
        VStack(alignment: .leading) {
            Text("Graph " + graph.id.description)
                .font(.headline)
            Text(graph.graph.description)
            Text("isBipartite: " + String(graph.isBipartite(graph.graph)))
        }
        .padding()
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(graph: ModelData().graphs[0])
            .environmentObject(ModelData())
    }
}
