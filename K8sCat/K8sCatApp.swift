//
//  K8sCatApp.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/17.
//

import SwiftUI

@main
struct K8sCatApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel())
        }
    }
}
