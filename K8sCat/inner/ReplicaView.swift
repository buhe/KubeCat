//
//  ReplicaView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/26.
//

import SwiftUI

struct ReplicaView: View {
    let replica: Replica
    let viewModel: ViewModel
    
    var body: some View {
        Form {
            Section(header: "Name") {
                Text(replica.name)
            }
            Section(header: "Status") {
                Text(replica.status ? "Ready" : "Pending")
            }
            Section(header: "Pods") {
                List {
                    ForEach(viewModel.model.podsByReplica(in: .namespace(viewModel.ns), replica: replica.k8sName, name: replica.name)) {
                        i in
                        NavigationLink {
                            PodView(pod: i, viewModel: viewModel)
                        } label: {
                            Image(systemName: "tray.2")
                            VStack(alignment: .leading) {
                                Text(i.name).foregroundColor(i.status == PodStatus.Failed.rawValue ? .red : (i.status == PodStatus.Running.rawValue || i.status == PodStatus.Succeeded.rawValue ? .green : .yellow))
                                HStack{
                                    Text("containers -").font(.caption)
                                    CaptionText(text: "expect: \(i.expect), ")
                                    Text("warning: \(i.status == PodStatus.Succeeded.rawValue ? 0 : i.warning)").font(.caption).foregroundColor((i.status == PodStatus.Succeeded.rawValue ? 0 : i.warning) > 0 ? .red : .none)
                                }
                                
                            }
                        }
                    }
                }
            }
            Section(header: "Labels and Annotations") {
                NavigationLink {
                    List {
                        ForEach((replica.labels ?? [:]).sorted(by: >), id: \.key) {
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
                        ForEach((replica.annotations ?? [:]).sorted(by: >), id: \.key) {
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
                    Text(replica.namespace)
                }
                
            }
        }
        .navigationTitle("Replica Set")
    }
}

struct ReplicaView_Previews: PreviewProvider {
    static var previews: some View {
        ReplicaView(replica: Replica(id: "abc", name: "abc", k8sName: [:], labels: ["l1":"l1v"],annotations: ["a1":"a1v"],namespace: "default", status: true), viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
    }
}
