//
//  GlobalView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/20.
//

import SwiftUI
import SwiftUIX

struct GlobalView: View {
    @State var search = ""
    @State var tabIndex = 0
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            NavigationStack {
                SearchBar(text: $search).padding(.horizontal)
                GlobalTabBar(tabIndex: $tabIndex).padding(.horizontal, 12)
                switch tabIndex {
                case 0:
                    List {
                        ForEach(viewModel.nodes) {
                            i in
                            NavigationLink {
                                NodeView(node: i)
                            } label: {
                                Text(i.name)
                            }
                    
                        }
                    }.listStyle(PlainListStyle())
                case 1:
                    List {
                        ForEach(viewModel.nodes) {
                            i in
                            NavigationLink {
//                                DeploymentView(deployment: i, viewModel: viewModel)
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

struct GlobalView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalView(viewModel: ViewModel())
    }
}
