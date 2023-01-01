//
//  ClusterView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/30.
//

import SwiftUI

struct ClusterView: View {
    let viewModel: ViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var cluters: FetchedResults<ClusterEntry>
    
    @State var showClusterType = false
    @State var selectedItem: String?
    var body: some View {
        HStack {
            Spacer()
            Button{
                showClusterType = true
            }label:{
                Image(systemName: "plus")
            }.padding(.trailing)
            EditButton()
        }
        .sheet(isPresented: $showClusterType){
            ClusterTypeView(first: cluters.isEmpty){
                showClusterType = false
            }
                .environment(\.managedObjectContext, viewContext)
        }
        .padding()
        List(selection: $selectedItem)  {
            ForEach(cluters.map{Cluster(id: $0.name!, name: $0.name!, icon:
                                            $0.icon ?? "triangle", kubeConfig: $0.config, selected: $0.selected )}) {
                i in
                HStack {
                    Image(systemName: i.selected ? "circle.fill" : "circle")
                    Text(i.name)
                }
            }.onDelete{
                sets in
                deleteItems(offsets: sets)
            }.onChange(of: selectedItem ?? ""){
                c in
                selectItem(id: c)
            }
//            .onMove{
//                s1,s2 in
//
//            }
        }
        .listStyle(PlainListStyle())
        Text(selectedItem ?? "unselected")
        
    }
    
       
    
        private func deleteItems(offsets: IndexSet) {
            withAnimation {
                offsets.map { cluters[$0] }.forEach(viewContext.delete)
    
                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    
    private func selectItem(id: String) {
        withAnimation {
            for cluster in cluters {
                if cluster.name == id {
                    cluster.selected = true
                    if !cluster.demo {
                        viewModel.model.hasAndSelectDemo = false
                    }
                    
                } else {
                    cluster.selected = false
                }
            }

            do {
                try viewContext.save()
                try viewModel.model.select(viewContext: viewContext)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct Cluster: Identifiable, Hashable {
    var id: String
    let name: String
    let icon: String
    let kubeConfig: String?
    let selected: Bool
    
}

struct ClusterView_Previews: PreviewProvider {
    static var previews: some View {
        ClusterView(viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
    }
}
