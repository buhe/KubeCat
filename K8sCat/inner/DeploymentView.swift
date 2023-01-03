//
//  DeploymentView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/26.
//

import SwiftUI
// deployment has child
struct DeploymentView: View {
    let deployment: Deployment
    let viewModel: ViewModel
    
    @State var showYaml = false
    var body: some View {
        Form {
            Section(header: "Name") {
                Text(deployment.name)
            }
            Section(header: "Status") {
                Text(deployment.status ? "Ready" : "Pending")
            }
            Section(header: "Pods") {
                List {
                    ForEach(viewModel.model.podsByDeployment(in: .namespace(viewModel.ns), deployment: deployment.k8sName)) {
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
                        ForEach((deployment.labels ?? [:]).sorted(by: >), id: \.key) {
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
                        ForEach((deployment.annotations ?? [:]).sorted(by: >), id: \.key) {
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
                    Text(deployment.namespace)
                }
                
            }
        }.toolbar{
            Menu {
                Button {
                    // do something
                    let yaml = deployment.encodeYaml(client: viewModel.model.client)
                    print("Yaml: \(yaml)")
                    showYaml = true
//                    deployment.decodeYaml(client: viewModel.model.client, yaml: yaml)
                } label: {
                    Text("View/Edit Yaml")
                    Image(systemName: "note.text")
                }
                Button {
                    // do something
                } label: {
                    Text("Delete Resource")
                    Image(systemName: "trash")
                }
            } label: {
                 Image(systemName: "ellipsis")
            }
        }.sheet(isPresented: $showYaml){
            YamlWebView(yamlble: deployment, model: viewModel.model) {
                showYaml = false
            }
            Button{
                urlScheme(yamlble: deployment, client: viewModel.model.client)
            }label: {
                Text("Load yaml via Yamler")
            }.padding()
        }
    }
}

struct DeploymentView_Previews: PreviewProvider {
    static var previews: some View {
        DeploymentView(deployment:  Deployment(id: "123", name: "123", k8sName: "123", expect: 1, pending: 0, labels: ["l1":"l1v"],annotations: ["a1":"a1v"],namespace: "default", status: false, raw: nil), viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
    }
}
