//
//  NodeView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/27.
//

import SwiftUI

struct NodeView: View {
    let node: Node
    let viewModel: ViewModel
    var body: some View {
        Form {
            Section(header: "Name") {
                Text(node.name)
            }
//            Section(header: "Status") {
//                Text(node.status)
//            }
            Section(header: "Role") {
                HStack{
                    Text("Etcd")
                    Spacer()
                    Text(String(node.etcd))
                }
                HStack{
                    Text("Control Plane")
                    Spacer()
                    Text(String(node.controlPlane))
                }
                HStack{
                    Text("Worker")
                    Spacer()
                    Text(String(node.worker))
                }
                HStack{
                    Text("Agent")
                    Spacer()
                    Text(String(node.agent))
                }
            }
//            Section(header: "Pods") {
//                List {
//                    ForEach(viewModel.model.podsByDeployment(in: .namespace(viewModel.ns), deployment: deployment.k8sName)) {
//                        i in
//                        NavigationLink {
//                            PodView(pod: i, viewModel: viewModel)
//                        } label: {
//                            VStack(alignment: .leading) {
//                                Text(i.name).foregroundColor(.green)
//                                HStack{
//                                    CaptionText(text: "expect: \(i.expect), ")
//                                    CaptionText(text: "pendding: \(i.pending)").foregroundColor(i.pending > 0 ? .red : .none)
//                                }
//
//                            }
//                        }
//                    }
//                }
//            }
            Section(header: "Labels and Annotations") {
                NavigationLink {
                    List {
                        ForEach((node.labels ?? [:]).sorted(by: >), id: \.key) {
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
                        ForEach((node.annotations ?? [:]).sorted(by: >), id: \.key) {
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
                    Text("Host Name")
                    Spacer()
                    Text(node.hostName)
                }
                HStack{
                    Text("Kube Version")
                    Spacer()
                    Text(node.version)
                }
                HStack{
                    Text("Arch")
                    Spacer()
                    Text(node.arch)
                }
                HStack{
                    Text("OS")
                    Spacer()
                    Text(node.os)
                }
            }
        }
        .navigationTitle("Node")
    }
}

//struct NodeView_Previews: PreviewProvider {
//    static var previews: some View {
//        NodeView(node: Node(id: "123", name: "123", hostName: "10.0.0.4", arch: "x86", os: "linux", labels: ["l1":"l1v"],annotations: ["a1":"a1v"], etcd: true,worker: true,controlPlane: true, version: "1.1"),viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
//    }
//}
