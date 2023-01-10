//
//  GraphData.swift
//  isGraphBipatite
//
//  Created by Thomas DiZoglio on 12/27/22.
//

import Foundation

/*
 Depth First Search Algorithm using two-colorability to figure out if it is a bipartite graph.
 
 Use two colors to color the graph and see if there are any adjacent nodes having the same color.
 
 Initialize a color[] array for each node. Here are three states for colors[] array:
 0: No colored yet.
 1: Red
 2: Green
 
 For each node,

     1. If color not set yet, color it. Then use the other color to color all its adjacent nodes (DFS).
     2. If it has been colored, check if the current color is the same as the color that is going to be used to color it.

 This is an O(N) - Try to color all nodes with alternating colors. If we came back to an already-colored node with a different color, then we return false. It could visit all nodes at least once making it O(N). Accessing each node in O(1)
 
 Basic DFS using Stack algorithm below:
 
 The depth-first search or DFS algorithm traverses or explores data structures, such as trees and graphs. The algorithm starts at the root node (in the case of a graph, you can use any random node as the root node) and examines each branch as far as possible before backtracking. When a dead-end occurs in any iteration, the Depth First Search (DFS) method traverses a network in a depthward motion and uses a stack data structure to remember to acquire the next vertex to start a search.
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
