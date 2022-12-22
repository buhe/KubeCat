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
    @State var tabIndex = 0
    @ObservedObject var viewModel: ViewModel
    // must add @ObservedObject
    var body: some View {
        VStack {
            NavigationStack {
                Picker("ns", selection: $ns) {
                    ForEach(viewModel.namespaces, id: \.self) {
                        Text($0)
                     }
                }.onChange(of: ns) {
                    c in
                    try! viewModel.podsSelector(in: .namespace(c))
                }
                SearchBar(text: $search).padding(.horizontal)
                CustomTopTabBar(tabIndex: $tabIndex).padding(.horizontal, 12)

                List {
                    ForEach(viewModel.pods) {
                        i in
                        NavigationLink {
                            Text(i.name)
                        } label: {
                            Text(i.name)
                        }
                
                    }
                }.listStyle(PlainListStyle())
            }
        }
        
        
    }
}

//struct NamespaceView_Previews: PreviewProvider {
//    static var previews: some View {
//        NamespaceView()
//    }
//}
