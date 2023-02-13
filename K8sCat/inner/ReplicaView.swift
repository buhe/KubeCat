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
    
    @State var pods: [Pod] = []
    
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
                pods = await viewModel.model.podsByReplica(in: .namespace(viewModel.ns), replica: replica.k8sName)
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
