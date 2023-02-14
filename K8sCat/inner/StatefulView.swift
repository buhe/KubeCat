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
    
    @State var pods: [Pod] = []
    
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
                    ForEach(pods) {
                        i in
                        NavigationLink {
                            PodView(pod: i, viewModel: viewModel)
                        } label: {
                            Image(systemName: "tray.2")
                            VStack(alignment: .leading) {
                                Text(i.name)
                                HStack{
                                    Text("containers -").font(.caption)
                                    CaptionText(text: "expect: \(i.expect), ")
                                    Text("error: \(i.status == PodStatus.Succeeded.rawValue ? 0 : i.error)").font(.caption).foregroundColor((i.status == PodStatus.Succeeded.rawValue ? 0 : i.error) > 0 ? .red : .none)
                                    Text("not ready: \(i.status == PodStatus.Succeeded.rawValue ? 0 :i.notReady)").font(.caption).foregroundColor((i.status == PodStatus.Succeeded.rawValue ? 0 : i.notReady) > 0 ? .yellow : .none)
                                }
                                
                            }
                        }
                    }
                }
            }
            .task {
                pods = await viewModel.model.podsByStateful(in: .namespace(viewModel.model.ns), stateful: stateful.k8sName)
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
//                    let yaml = stateful.encodeYaml(client: viewModel.model.client)
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
        .navigationTitle("Stateful Set")
    }
}

struct StatefulView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulView(stateful: Stateful(id: "123", name: "123", k8sName: [:], labels: ["l1":"l1v"],annotations: ["a1":"a1v"],namespace: "default", status: true, raw: nil), viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
    }
}
