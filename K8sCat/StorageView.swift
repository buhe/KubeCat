//
//  StorageView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/29.
//

import SwiftUI
import SwiftUIX

struct StorageView: View {
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var cluters: FetchedResults<ClusterEntry>
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
                    Button{showCluster = true}label: {
                        Image(systemName: cluters.filter{$0.selected}.first?.icon ?? "0.circle")
                    }.padding(.trailing)
                }
                StorageTabBar(tabIndex: $tabIndex).padding(.horizontal, 26)
                switch tabIndex {
                case 0:
                    List {
                        ForEach(viewModel.pv.filter{$0.name.contains(search.lowercased()) || search == ""}) {
                            i in
                            NavigationLink {
                                PVView(pv: i, viewModel: viewModel)
                            } label: {
                                Image(systemName: "capsule.portrait")
                                Text(i.name)
                            }
                    
                        }
                    }.listStyle(PlainListStyle())
                        .onAppear {
                            Task {
                                await viewModel.pv()
                            }
                        }
                    .refreshable {
                        viewModel.model.pvs = nil
                        Task {
                            await viewModel.pv()
                        }
                    }
                    
                case 1:
                    List {
                        ForEach(viewModel.pvc.filter{$0.name.contains(search.lowercased()) || search == ""}) {
                            i in
                            NavigationLink {
                                PVCView(pvc: i, viewModel: viewModel)
                            } label: {
                                Image(systemName: "shield")
                                Text(i.name)
                            }
                    
                        }
                    }.listStyle(PlainListStyle())
                        .onAppear {
                            Task {
                                await viewModel.pvc()
                            }
                        }
                    .refreshable {
                        viewModel.model.pvcs = nil
                        Task {
                            await viewModel.pvc()
                        }
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
    }
}

struct StorageView_Previews: PreviewProvider {
    static var previews: some View {
        StorageView(viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
    }
}
