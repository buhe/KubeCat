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
                NodesTabBar(tabIndex: $tabIndex).padding(.horizontal, 12)
                switch tabIndex {
                case 0:
                    List {
                        ForEach(viewModel.nodes) {
                            i in
                            NavigationLink {
                                NodeView(node: i, viewModel: viewModel)
                            } label: {
                                Image(systemName: "display")
                                VStack(alignment: .leading) {
                                    Text(i.name)
                                    CaptionText(text: i.version)
                                }
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
