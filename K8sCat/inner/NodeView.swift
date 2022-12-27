//
//  NodeView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/27.
//

import SwiftUI

struct NodeView: View {
    let node: Node
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        NodeView(node: Node(id: "123", name: "123", hostName: "10.0.0.4", arch: "x86", os: "linux"))
    }
}
