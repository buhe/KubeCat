//
//  ViewModel.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/21.
//

import Foundation


class ViewModel: ObservableObject {
    @Published var model = Model()
    
    var pods: [Pod] {
        (model.pods?.items.map {Pod(id: $0.name!, name: $0.name!)}) ?? []
    }
}

struct Pod: Identifiable {
    var id: String
    var name: String
}
