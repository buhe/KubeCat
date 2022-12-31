//
//  ContentView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/17.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        TabView {
            NamespaceView(viewModel: viewModel)
                .environment(\.managedObjectContext, viewContext)
                .tabItem {
                Label("Payloads", systemImage: "aqi.medium")
            }
            
            StorageView(viewModel: viewModel)
                .environment(\.managedObjectContext, viewContext)
                .tabItem {
                Label("Storage", systemImage: "opticaldiscdrive")
            }
            
            GlobalView(viewModel: viewModel)
                .environment(\.managedObjectContext, viewContext)
                .tabItem {
                Label("Nodes", systemImage: "display.2")
            }
            
            SettingView()
                .environment(\.managedObjectContext, viewContext)
                .tabItem {
                Label("Setting", systemImage: "gear")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}
