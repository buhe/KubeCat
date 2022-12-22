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
    var namespaces: [core.v1.Namespace] = []
    var pods: [core.v1.Pod] = []
    fileprivate func workaroundChinaSpecialBug() {
        let url = URL(string: "https://www.baidu.com")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let _ = data else { return }
//            print(String(data: data, encoding: .utf8)!)
        }
        
        task.resume()
    }
    
    init() {
        client = KubernetesClient(config: try! Default().config()!)
        workaroundChinaSpecialBug()
        
        try? namespace()
        try? pod(in: .default)
        
    }
    
    mutating func namespace() throws {
        let namespaces = try client.namespaces.list().wait().items
//        print("ns is \(namespaces)")
        self.namespaces = namespaces
    }
    
    mutating func pod(in ns: NamespaceSelector) throws {
        let pods = try client.pods.list(in: ns).wait().items
        self.pods = pods
    }
}
