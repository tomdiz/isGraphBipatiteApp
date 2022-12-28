//
//  GraphData.swift
//  isGraphBipatite
//
//  Created by Thomas DiZoglio on 12/27/22.
//

import Foundation

/*
 Use two colors to color the graph and see if there are any adjacent nodes having the same color.
 
 Initialize a color[] array for each node. Here are three states for colors[] array:
 0: No colored yet.
 1: Red
 2: Green
 
 For each node,

     1. If color not set yet, color it. Then use the other color to color all its adjacent nodes (DFS).
     2. If it has been colored, check if the current color is the same as the color that is going to be used to color it.

 */

struct GraphData: Codable, Hashable, Identifiable {
    var id: Int
    var graph: [[Int]]
    
    enum NodeColor {
        static let noColor = 0
        static let red = 1
        static let green = 2
    }

    func isBipartite(_ graph: [[Int]]) -> Bool {
        
        let V = graph.count;

        if V <= 1 {
            return true    // there are no edges
        }

        var colors: Array<Int> = Array(repeating: NodeColor.noColor, count: V)

        for i in  0...V-1 {
            
            if colors[i] == NodeColor.noColor && !color(graph: graph, colors: &colors, nodeColor: NodeColor.green, node: i) {
                return false
            }
        }
        
        return true
    }
    
    func color(graph: [[Int]], colors: inout [Int], nodeColor: Int, node: Int) -> Bool {
        if colors[node] != NodeColor.noColor {
            return colors[node] == nodeColor;
        }
        colors[node] = nodeColor;
        var newColor: Int
        if nodeColor == NodeColor.green  {
            newColor = NodeColor.red
        }
        else {
            newColor = NodeColor.green
        }
        let neighbors = graph[node]
        for neighbor in neighbors {
            if !color(graph: graph, colors: &colors, nodeColor: newColor, node: neighbor) {
                return false;
            }
        }
        return true;
    }
}
