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
    @State var name = ""
    @State var icon = "a.circle"
    @State var importMsg: String = "Import Kube Config"
    @State var content = ""
    @State var showErrorMessage = false
    @State var errorMessage = ""
    
    @State private var showingExporter = false
    
    var body: some View {
        NavigationStack {
        Form {
            
                Section(header: "Name"){
                    TextField(text: $name)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                }
                Section(header: "Icon"){
                    Picker("icon", selection: $icon){
                        ForEach(["a.circle", "b.circle", "c.circle", "e.circle", "f.circle", "g.circle", "h.circle", "i.circle", "j.circle", "k.circle", "l.circle", "m.circle", "n.circle", "o.circle", "p.circle", "q.circle", "r.circle", "s.circle", "t.circle", "u.circle", "v.circle", "w.circle", "x.circle", "y.circle"], id: \.self) {
                            Image(systemName: $0)
                        }
                        
                    }
                    
                }
                Section(header: "Kube Config"){
                    Text(importMsg).onTapGesture {
                        showingExporter = true
                    }
                }
                Button{
                    // save to core data
                    addItem()
                    
                } label: {
                    Text("Save")
                }
            }
            
        }
        .alert(errorMessage, isPresented: $showErrorMessage){
            Button("OK", role: .cancel) {
                showErrorMessage = false
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
        if name.isEmpty {
            showErrorMessage = true
            errorMessage = "Input cluster name, please."
            return
        }
        if content.isEmpty {
            showErrorMessage = true
            errorMessage = "Import kube config, please."
            return
        }
        withAnimation {
            let newItem = ClusterEntry(context: viewContext)
            newItem.name = self.name
            newItem.type = ClusterType.KubeConfig.rawValue
            newItem.icon = icon
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
        close()
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView(first: true){}
    }
}
