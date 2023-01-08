//
//  ConfigView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/31.
//

import SwiftUI

struct AWSView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let first: Bool
    let close: () -> Void
    @State var name = ""
    @State var icon = "a.circle"
    @State var accessKeyID = ""
    @State var secretAccessKey = ""
    @State var region = ""
    @State var clusterName = ""
    

    @State var showErrorMessage = false
    @State var errorMessage = ""
    
    @State private var showingExporter = false
    
    var columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 5)
    var body: some View {
        NavigationStack {
        Form {
            
                Section(header: "Name"){
                    TextField(text: $name)
                }
                Section(header: "Icon"){
                    Picker("Icon", selection: $icon){
                        ForEach(["a.circle", "b.circle", "c.circle", "e.circle", "f.circle", "g.circle", "h.circle", "i.circle", "j.circle", "k.circle", "l.circle", "m.circle", "n.circle", "o.circle", "p.circle", "q.circle", "r.circle", "s.circle", "t.circle", "u.circle", "v.circle", "w.circle", "x.circle", "y.circle"], id: \.self) {
                            Image(systemName: $0)
                        }
                        
                    }
                    
                }
                Section(header: "Access Key ID"){
                    TextField(text: $accessKeyID)
                }
                Section(header: "Secret Access key"){
                    TextField(text: $secretAccessKey)
                }

                Section(header: "Region"){
                    Picker("Region", selection: $region){
                        ForEach([AWSResign(id: "us-east-1", render: "US East (N. Virginia)", value: "us-east-1")
                                ,AWSResign(id: "us-east-2", render: "US East (Ohio)", value: "us-east-2")
                                ,AWSResign(id: "us-west-1", render: "US West (N. California)", value: "us-west-1")
                                ]) {
                            Text($0.render)
                        }
                        
                    }
                }
                Section(header: "Cluster Name"){
                    TextField(text: $clusterName)
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
        
    }
    
    private func addItem() {
        if name.isEmpty {
            showErrorMessage = true
            errorMessage = "Input cluster name, please."
            return
        }
        if accessKeyID.isEmpty {
            showErrorMessage = true
            errorMessage = "Input AWS access key ID, please."
            return
        }
        if secretAccessKey.isEmpty {
            showErrorMessage = true
            errorMessage = "Input AWS secret access key, please."
            return
        }
        if region.isEmpty {
            showErrorMessage = true
            errorMessage = "Input AWS region, please."
            return
        }
        if clusterName.isEmpty {
            showErrorMessage = true
            errorMessage = "Input AWS EKS cluster name, please."
            return
        }
//        if content.isEmpty {
//            showErrorMessage = true
//            errorMessage = "Import kube config, please."
//            return
//        }
        withAnimation {
            let newItem = ClusterEntry(context: viewContext)
            newItem.name = self.name
            newItem.type = ClusterType.AWS.rawValue
            newItem.icon = icon
            newItem.accessKeyID = accessKeyID
            newItem.secretAccessKey = secretAccessKey
            newItem.region = region
            newItem.clusterName = clusterName
            
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

//struct ConfigView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfigView(first: true){}
//    }
//}
