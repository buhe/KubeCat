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
    @State var showCluster = false
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack {
            NavigationStack {
                HStack{
                    SearchBar(text: $search).padding(.horizontal)
                    Button{ showCluster = true }label: {
                        Image(systemName: "plus")
                    }.padding(.trailing)
                }
                NodesTabBar(tabIndex: $tabIndex).padding(.horizontal, 26)
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
        }.sheet(isPresented: $showCluster){
            ClusterView()
                .environment(\.managedObjectContext, viewContext)
        }
    }
}

struct GlobalView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalView(viewModel: ViewModel())
    }
}
