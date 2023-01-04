//
//  StatefulView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/26.
//

import SwiftUI

struct StatefulView: View {
    let stateful: Stateful
    let viewModel: ViewModel
    
    @State var showYaml = false
    var body: some View {
        Form {
            Section(header: "Name") {
                Text(stateful.name)
            }
            Section(header: "Status") {
                Text(stateful.status ? "Ready" : "Pending")
            }
            Section(header: "Pods") {
                List {
                    ForEach(viewModel.model.podsByStateful(in: .namespace(viewModel.ns), stateful: stateful.k8sName)) {
                        i in
                        NavigationLink {
                            PodView(pod: i, viewModel: viewModel)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(i.name)
                                HStack{
                                    CaptionText(text: "expect: \(i.expect), ")
                                    CaptionText(text: "pendding: \(i.pending)").foregroundColor(i.pending > 0 ? .red : .none)
                                }
                                
                            }
                        }
                    }
                }
            }
            Section(header: "Labels and Annotations") {
                NavigationLink {
                    List {
                        ForEach((stateful.labels ?? [:]).sorted(by: >), id: \.key) {
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
                        ForEach((stateful.annotations ?? [:]).sorted(by: >), id: \.key) {
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

            Section(header: "Misc") {
                HStack{
                    Text("Namespace")
                    Spacer()
                    Text(stateful.namespace)
                }
                
            }
        }.toolbar{
            Menu {
                Button {
                    // do something
                    let yaml = stateful.encodeYaml(client: viewModel.model.client)
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
            YamlWebView(yamlble: stateful, model: viewModel.model) {
                showYaml = false
            }
            #endif
            Button{
                urlScheme(yamlble: stateful, client: viewModel.model.client)
            }label: {
                Text("Load yaml via Yamler")
            }.padding()
        }
    }
}

struct StatefulView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulView(stateful: Stateful(id: "123", name: "123", k8sName: "123", labels: ["l1":"l1v"],annotations: ["a1":"a1v"],namespace: "default", status: true, raw: nil), viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
    }
}
