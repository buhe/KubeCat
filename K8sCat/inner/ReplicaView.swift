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
                
            }
            Section(header: "Pods") {
                List {
                    ForEach(viewModel.model.podsByReplica(in: .namespace(viewModel.ns), replica: replica.k8sName)) {
                        i in
                        NavigationLink {
                            PodView(pod: i, viewModel: viewModel)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(i.name).foregroundColor(.green)
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
    }
}

struct ReplicaView_Previews: PreviewProvider {
    static var previews: some View {
        ReplicaView(replica: Replica(id: "abc", name: "abc", k8sName: "abc", labels: ["l1":"l1v"],annotations: ["a1":"a1v"],namespace: "default"), viewModel: ViewModel())
    }
}
