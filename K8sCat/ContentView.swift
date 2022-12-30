//
//  ContentView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/17.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        TabView {
            NamespaceView(viewModel: viewModel).tabItem {
                Label("Payloads", systemImage: "aqi.medium")
            }
            
            StorageView(viewModel: viewModel).tabItem {
                Label("Storage", systemImage: "opticaldiscdrive")
            }
            
            GlobalView(viewModel: viewModel).tabItem {
                Label("Nodes", systemImage: "display.2")
            }
            
            SettingView().tabItem {
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
