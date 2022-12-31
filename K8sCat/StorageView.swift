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
    @ObservedObject var viewModel: ViewModel
    @State var showCluster = false
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        VStack {
            NavigationStack {
                HStack{
                    SearchBar(text: $search).padding(.horizontal)
                    Button{showCluster = true}label: {
                        Image(systemName: "plus")
                    }.padding(.trailing)
                }
                StorageTabBar(tabIndex: $tabIndex).padding(.horizontal, 26)
                switch tabIndex {
                case 0:
                    List {
                        ForEach(viewModel.pv) {
                            i in
                            NavigationLink {
                                PVView(pv: i, viewModel: viewModel)
                            } label: {
                                Image(systemName: "capsule.portrait")
                                Text(i.name)
                            }
                    
                        }
                    }.listStyle(PlainListStyle())
                case 1:
                    List {
                        ForEach(viewModel.pvc) {
                            i in
                            NavigationLink {
//                                DeploymentView(deployment: i, viewModel: viewModel)
                            } label: {
                                Image(systemName: "shield")
                                Text(i.name)
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

struct StorageView_Previews: PreviewProvider {
    static var previews: some View {
        StorageView(viewModel: ViewModel())
    }
}
