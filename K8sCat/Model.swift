//
//  Model.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/21.
//

import Foundation
import SwiftkubeClient

struct Model {
    init() {
        let client = KubernetesClient(config: try! Default().config()!)
        let namespaces = try! client.namespaces.list().wait()
        print("ns is \(namespaces)")
    }
}
