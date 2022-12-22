//
//  ViewModel.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/21.
//

import Foundation
import SwiftkubeClient

class ViewModel: ObservableObject {
    @Published var model = Model()
    
    func pods(in ns: NamespaceSelector) -> [Pod] {
        switch ns {
        case .namespace(let name):
            if model.pods[name] == nil {
                try! model.pod(in: ns)
            }
            return model.pods[name]!.map {Pod(id: $0.name!, name: $0.name!)}
        default: return []
        }
        
    }
    
    var namespaces: [String] {
        model.namespaces.map { $0.name! }
    }
    func deployment(in ns: NamespaceSelector) -> [Deployment] {
        switch ns {
        case .namespace(let name):
            if model.deployments[name] == nil {
                try! model.deployment(in: ns)
            }
            return model.deployments[name]!.map {Deployment(id: $0.name!, name: $0.name!)}
        default: return []
        }
        
    }
    
    func podsSelector(in ns: NamespaceSelector) throws {
        try model.pod(in: ns)
    }
}

struct Pod: Identifiable {
    var id: String
    var name: String
}

struct Deployment: Identifiable {
    var id: String
    var name: String
}
