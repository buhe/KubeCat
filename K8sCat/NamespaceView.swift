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
                    switch tabIndex {
                    case 0:
                        try! viewModel.podsSelector(in: .namespace(c))
                    case 1:
                        try! viewModel.model.deployment(in: .namespace(c))
                    default: break
                    }
                    
                }
                SearchBar(text: $search).padding(.horizontal)
                CustomTopTabBar(tabIndex: $tabIndex).padding(.horizontal, 12)
                Group {
                    switch tabIndex {
                    case 0:
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
                    case 1:
                        List {
                            ForEach(viewModel.deployment) {
                                i in
                                NavigationLink {
                                    Text(i.name)
                                } label: {
                                    Text(i.name)
                                }
                        
                            }
                        }.listStyle(PlainListStyle())
                    default:
                        EmptyView()
                    }
                }
                
            }
        }
        
        
    }
}

//struct NamespaceView_Previews: PreviewProvider {
//    static var previews: some View {
//        NamespaceView()
//    }
//}
