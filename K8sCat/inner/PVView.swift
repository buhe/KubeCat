//
//  PVView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/29.
//

import SwiftUI

struct PVView: View {
    let pv: PersistentVolume
    let viewModel: ViewModel
    
    @State var showYaml = false
    var body: some View {
        Form {
            Section(header: "Name") {
                Text(pv.name)
            }
            Section(header: "Status") {
                Text(pv.status)
            }
            Section(header: "Access Modes") {
                Text(pv.accessModes)
            }
            Section(header: "Storage Class") {
                Text(pv.storageClass)
            }
            Section(header: "Labels and Annotations") {
                NavigationLink {
                    List {
                        ForEach((pv.labels ?? [:]).sorted(by: >), id: \.key) {
                            key, value in
                            VStack(alignment: .leading) {
                                Text(key)
                                
                                CaptionText(text: value)
                            }
                        }
                    }
                    
                } label: {
                    Text("Labels")
                }
                NavigationLink {
                    List {
                        ForEach((pv.annotations ?? [:]).sorted(by: >), id: \.key) {
                            key, value in
                            VStack(alignment: .leading) {
                                Text(key)
                                CaptionText(text: value)
                            }
                        }
                    }
                } label: {
                    Text("Annotations")
                }
            }
            
        }.toolbar{
            Menu {
                Button {
                    // do something
                    let yaml = pv.encodeYaml(client: viewModel.model.client)
                    print("Yaml: \(yaml)")
                    showYaml = true
//                    deployment.decodeYaml(client: viewModel.model.client, yaml: yaml)
                } label: {
                    Text("View/Edit Yaml")
                    Image(systemName: "note.text")
                }
//                Button {
//                    // do something
//                } label: {
//                    Text("Delete Resource")
//                    Image(systemName: "trash")
//                }
            } label: {
                 Image(systemName: "ellipsis")
            }
        }.sheet(isPresented: $showYaml){
            #if os(iOS)
            YamlWebView(yamlble: pv, model: viewModel.model) {
                showYaml = false
            }
            #endif
            Button {
                Task {
                    await urlScheme(yamlble: pv, client: viewModel.model.client)
                }
            }label: {
                Text("Load yaml via Yamler")
            }.padding()
        }
        .navigationTitle("Persistent Volume")
    }
}

//struct PVView_Previews: PreviewProvider {
//    static var previews: some View {
//        PVView(pv: PersistentVolume(id: "123", name: "123", labels: ["l1":"l1v"], annotations: ["l1":"l1v"],accessModes: "r/w",status: "B",storageClass: "M"), viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
//    }
//}
