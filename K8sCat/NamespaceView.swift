//
//  NamespaceView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/20.
//

import SwiftUI
import SwiftUIX

struct NamespaceView: View {
    @State var ns = "default"
    @State var search = ""
    var body: some View {
        VStack {
            NavigationStack {
                Picker("ns", selection: $ns) {
                    ForEach(["default", "monitor"], id: \.self) {
                        Text($0)
                     }
                }.onChange(of: ns) {
                    c in print("select ns \(c)")
                }
                SearchBar(text: $search)
                List {
                    ForEach(["pod 1", "pod 2", "pod 3", "pod 4", "pod 5"], id: \.self) {
                        i in
                        NavigationLink {
                            Text(i)
                        } label: {
                            Text(i)
                        }
                
                    }
                }.listStyle(PlainListStyle())
            }
        }
        
        
    }
}

struct NamespaceView_Previews: PreviewProvider {
    static var previews: some View {
        NamespaceView()
    }
}
