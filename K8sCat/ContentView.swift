//
//  ContentView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/17.
//

import SwiftUI

struct ContentView: View {
    let model = Model()
    var body: some View {
        TabView {
            NamespaceView().tabItem {
                Label("Namespaces", systemImage: "aqi.medium")
            }
            
            GlobalView().tabItem {
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
        ContentView()
    }
}
