//
//  DaemonView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/26.
//

import SwiftUI

struct DaemonView: View {
    let daemon: Daemon
    let viewModel: ViewModel
    var body: some View {
        Form {
            Section(header: "Name") {
                Text(daemon.name)
            }
            Section(header: "Status") {
                
            }
            Section(header: "Pods") {
                List {
                    ForEach(viewModel.model.podsByDaemon(in: .namespace(viewModel.ns), daemon: daemon.k8sName)) {
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
                        ForEach((daemon.labels ?? [:]).sorted(by: >), id: \.key) {
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
                        ForEach((daemon.annotations ?? [:]).sorted(by: >), id: \.key) {
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
                    Text(daemon.namespace)
                }
                
            }
        }
    }
}

struct DaemonView_Previews: PreviewProvider {
    static var previews: some View {
        DaemonView(daemon: Daemon(id: "123", name: "123", k8sName: "123", labels: ["l1":"l1v"],annotations: ["a1":"a1v"],namespace: "default"), viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
    }
}
