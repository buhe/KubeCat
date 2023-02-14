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
    var viewModel: ViewModel
    @State var showCluster = false
    
    @State var nodes: [Node] = []
    
    @Environment(\.managedObjectContext) private var viewContext
    func loadNode() async {
        self.nodes = await viewModel.model.nodes().filter{$0.name.contains(search.lowercased()) || search == ""}
    }
    var body: some View {
        VStack {
            NavigationStack {
                HStack{
                    SearchBar(text: $search).padding(.horizontal)
                    ClusterSelectView{
                        showCluster = true
                    }
                    .environment(\.managedObjectContext, viewContext)
                }
                NodesTabBar(tabIndex: $tabIndex).padding(.horizontal, 26)
                switch tabIndex {
                case 0:
                    List {
                        ForEach(nodes) {
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
                    .refreshable {
                        
                    }
                default:
                    EmptyView()
                }
            }
        }.sheet(isPresented: $showCluster){
            ClusterView(viewModel: viewModel){
                showCluster = false
            }
                .environment(\.managedObjectContext, viewContext)
        }
        .task {
            await loadNode()
        }
    }
}

struct GlobalView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalView(viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
    }
}
