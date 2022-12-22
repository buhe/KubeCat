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
    
    var pods: [Pod] {
        model.pods.map {Pod(id: $0.name!, name: $0.name!)}
    }
    
    var namespaces: [String] {
        model.namespaces.map { $0.name! }
    }
    
    var deployment: [Deployment] {
        model.deployments.map {Deployment(id: $0.name!, name: $0.name!)}
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
