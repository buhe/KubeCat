//
//  ContentView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Text("ns").tabItem {
                Text("ns")
            }
            
            Text("global").tabItem {
                Text("global")
            }
            
            Text("settings").tabItem {
                Text("settings")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
