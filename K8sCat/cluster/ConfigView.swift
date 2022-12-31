//
//  ConfigView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/31.
//

import SwiftUI

struct ConfigView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let first: Bool
    let close: () -> Void
    @State var name: String?
    @State var icon: String?
    @State var importMsg: String = "Import Kube Config"
    @State var content: String?
    
    @State private var showingExporter = false
    var body: some View {
        Form {
            Section(header: "Name"){
                TextField(text: $name)
            }
            Section(header: "Icon"){
                TextField(text: $icon)
            }
            Section(header: "Kube Config"){
                Text(importMsg).onTapGesture {
                    showingExporter = true
                }
            }
            Button{
                // save to core data
                addItem()
                close()
            } label: {
                Text("Save")
            }
            
        }
        .fileImporter(isPresented: $showingExporter, allowedContentTypes: [.yaml]) { result in
            switch result {
            case .success(let url):
                let _ = url.startAccessingSecurityScopedResource()
                if let content = try? String(contentsOf: url) {
                    self.content = content
                    importMsg = "Imported"
                    print("Import content is \(content)")
                }
                url.stopAccessingSecurityScopedResource()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = ClusterEntry(context: viewContext)
            newItem.name = self.name
            newItem.type = ClusterType.Config.rawValue
            newItem.icon = "triangle"
            newItem.config = self.content
            if first {
                newItem.selected = true
            }

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

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView(first: true){}
    }
}
