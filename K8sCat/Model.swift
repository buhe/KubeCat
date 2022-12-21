//
//  Model.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/21.
//

import Foundation
import SwiftkubeClient
import SwiftkubeModel

struct Model {
    let client: KubernetesClient
    var namespaces: core.v1.Namespace.List?
    
    init() {
        client = KubernetesClient(config: try! Default().config()!)
        
        try! namespace()
        defer {
            try? client.syncShutdown()
        }
    }
    
    mutating func namespace() throws {
        let namespaces = try client.namespaces.list().wait()
        print("ns is \(namespaces)")
        self.namespaces = namespaces
    }
}
