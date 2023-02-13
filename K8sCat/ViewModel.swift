//
//  ViewModel.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/21.
//

import Foundation
import SwiftkubeClient
import CoreData

class ViewModel: ObservableObject {
    
    @Published var model: Model
    
    init(viewContext: NSManagedObjectContext) {
        model = Model(viewContext: viewContext)
            
    }
    
    var namespaces: [String] {
        if model.hasAndSelectDemo {
            return ["demo1", "demo2"]
        } else {
            return model.namespaces.map { $0.name! }
        }
    }
    
    
}


