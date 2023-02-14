//
//  HpaView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2023/1/2.
//

import SwiftUI

struct HpaView: View {
    let hpa: Hpa
    let viewModel: ViewModel
    
    @State var showYaml = false
    var body: some View {
        Form {
            Section(header: "Name") {
                Text(hpa.name)
            }
            Section(header: "Reference") {
                NavigationLink {
//                    switch hpa.referenceType {
//                    case .Deployment:
//                        DeploymentView(deployment: viewModel.model.deploymentByName(ns: viewModel.ns, name: hpa.reference), viewModel: viewModel)
//                    default:
//                        EmptyView()
//                    }
                } label: {
                    
                    switch hpa.referenceType {
                    case .Deployment:
                        Image(systemName: "ipad.landscape.badge.play")
                    default:
                        EmptyView()
                    }
                    Text(hpa.reference)
                }
            }
            Section(header: "Misc") {
                HStack{
                    Text("Namespace")
                    Spacer()
                    Text(hpa.namespace)
                }
                
            }
        }.toolbar{
            Menu {
                Button {
                    // do something
//                    let yaml = hpa.encodeYaml(client: viewModel.model.client)
//                    print("Yaml: \(yaml)")
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
            YamlWebView(yamlble: hpa, model: viewModel.model) {
                showYaml = false
            }
            #endif
            Button{
                urlScheme(yamlble: hpa, client: viewModel.model.client)
            }label: {
                Text("Load yaml via Yamler")
            }.padding()
        }
        .navigationTitle("‎Horizontal Pod Autoscaler")
    }
}

struct HpaView_Previews: PreviewProvider {
    static var previews: some View {
        HpaView(hpa:  Hpa(id: "123", name: "123", namespace: "default",reference: "123", referenceType: .Deployment, raw: nil), viewModel: ViewModel(viewContext: PersistenceController.shared.container.viewContext))
    }
}

enum HPAReference: String {
    case Deployment
    case UnKnow
}
