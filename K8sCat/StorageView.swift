//
//  StorageView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/29.
//

import SwiftUI
import SwiftUIX

struct StorageView: View {
    @State var search = ""
    @State var tabIndex = 0
    let viewModel: ViewModel
    @State var showCluster = false
    @Environment(\.managedObjectContext) private var viewContext

    @State var pv: [PersistentVolume] = []
    @State var pvc: [PersistentVolumeClaim] = []

    func loadData() async {
        switch tabIndex {
        case 0:
            await loadPv()
        case 1:
            await loadPvc()
        default: break
        }
    }

    func loadPv() async {
        self.pv = await viewModel.model.pv().filter{$0.name.contains(search.lowercased()) || search == ""}
    }

    func loadPvc() async {
        self.pvc = await viewModel.model.pvc().filter{$0.name.contains(search.lowercased()) || search == ""}
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
                StorageTabBar(tabIndex: $tabIndex).padding(.horizontal, 26)
                switch tabIndex {
                case 0:
                    List {
                        ForEach(pv) {
                            i in
                            NavigationLink {
                                PVView(pv: i, viewModel: viewModel)
                            } label: {
                                Image(systemName: "capsule.portrait")
                                Text(i.name)
                            }

                        }
                    }.listStyle(PlainListStyle())
                    .refreshable {
                        Task{
                            await loadPv()
                        }
                    }
                case 1:
                    List {
                        ForEach(pvc) {
                            i in
                            NavigationLink {
                                PVCView(pvc: i, viewModel: viewModel)
                            } label: {
                                Image(systemName: "shield")
                                Text(i.name)
                            }

                        }
                    }.listStyle(PlainListStyle())
                    .refreshable {
                        Task {
                            await loadPvc()
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
        .task {
            await loadData()
        }
    }
}

struct StorageView_Previews: PreviewProvider {
    static var previews: some View {
        StorageView(viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
    }
}
