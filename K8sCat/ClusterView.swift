//
//  ClusterView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/30.
//

import SwiftUI

struct ClusterView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var cluters: FetchedResults<ClusterEntry>
    var body: some View {
        HStack {
            Spacer()
            Button{
                addItem()
            }label:{
                Image(systemName: "plus")
            }
            EditButton()
        }
        .padding()
        List {
            ForEach(cluters.map{Cluster(id: $0.name!, name: $0.name!, icon: "", kubeConfig: $0.config)}) {
                i in
                HStack {
                    Text(i.name)
                }
            }.onDelete{
                sets in
                deleteItems(offsets: sets)
            }
        }
        .listStyle(PlainListStyle())
        
    }
    
        private func addItem() {
            withAnimation {
                let newItem = ClusterEntry(context: viewContext)
                newItem.name = "demo"
                newItem.type = ClusterType.Demo.rawValue
    
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
}

struct Cluster: Identifiable {
    var id: String
    let name: String
    let icon: String
    let kubeConfig: String?
    
}

struct ClusterView_Previews: PreviewProvider {
    static var previews: some View {
        ClusterView()
    }
}
