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
                Label("Namespaces", systemImage: "aqi.medium")
            }
            
            GlobalView(viewModel: viewModel).tabItem {
                Label("Global", systemImage: "globe")
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
