//
//  PodView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/26.
//

import SwiftUI

struct PodView: View {
    @State var daemon: Daemon = Daemon(id: "demo", name: "demo", k8sName: [:], labels: [:], annotations: [:], namespace: "demo", status: true, raw: nil)
    @State var replica: Replica = Replica(id: "demo", name: "demo", k8sName: [:], labels: [:], annotations: [:], namespace: "demo", status: true)
    @State var stateful = Stateful(id: "demo", name: "demo", k8sName: [:], labels: [:], annotations: [:], namespace: "demo", status: false, raw: nil)
    @State var job = Job(id: "demo", name: "demo", k8sName: [:], labels: [:], annotations: [:], namespace: "demo", status: true)
    
    let pod: Pod
    let viewModel: ViewModel
    var body: some View {
        Form {
            Section(header: "Name") {
                Text(pod.name)
            }
            Section(header: "Status") {
                Text(pod.status)
            }
            Section(header: "Containers") {
                List {
                    ForEach(pod.containers) {
                        c in
                        NavigationLink {
                            ContainerView(pod: pod, container: c, viewModel: viewModel)
                        } label: {
                            Image(systemName: "tray.full")
                            VStack(alignment: .leading) {
                                Text(c.name)
                                    .foregroundColor(c.ready ? .green : (c.error ? .red : .yellow))
                                CaptionText(text: c.image)
                            }
                        }
                        
                        
                    }
                }
            }
            Section(header: "Contoller") {
                NavigationLink {
                    switch pod.controllerType {
                    case .DaemonSet:
                        DaemonView(daemon: daemon, viewModel: viewModel)
                            .task {
                                daemon = await viewModel.model.daemonByName(ns: viewModel.ns, name: pod.controllerName)
                            }
                    case .ReplicaSet:
                        ReplicaView(replica: replica, viewModel: viewModel)
                            .task {
                                replica = await viewModel.model.replicaByName(ns: viewModel.ns, name: pod.controllerName)
                            }
                    case .StatefulSet:
                        StatefulView(stateful: stateful, viewModel: viewModel)
                            .task {
                                stateful = await viewModel.model.statefulByName(ns: viewModel.ns, name: pod.controllerName)
                            }
                    case .Job:
                        JobView(job: job, viewModel: viewModel)
                            .task {
                                job = await viewModel.model.jobByName(ns: viewModel.ns, name: pod.controllerName)
                            }
                    default: EmptyView()
                    }
                } label: {
                    switch pod.controllerType {
                    case .DaemonSet:
                        Image(systemName: "xserve")
                    case .ReplicaSet:
                        Image(systemName: "square.3.layers.3d.down.left")
                    case .StatefulSet:
                        Image(systemName: "macpro.gen2.fill")
                    case .Job:
                        Image(systemName: "figure.run")
                    default: EmptyView()
                    }
                    Text(pod.controllerName)
                }
            }
            Section(header: "Labels and Annotations") {
                NavigationLink {
                    List {
                        ForEach((pod.labels ?? [:]).sorted(by: >), id: \.key) {
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
                        ForEach((pod.annotations ?? [:]).sorted(by: >), id: \.key) {
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
            Section(header: "Ip") {
                HStack{
                    Text("Pod IP")
                    Spacer()
                    Text(pod.clusterIP)
                }
                HStack{
                    Text("Node IP")
                    Spacer()
                    Text(pod.nodeIP)
                }
            }
            Section(header: "Misc") {
                HStack{
                    Text("Namespace")
                    Spacer()
                    Text(pod.namespace)
                }
                
            }
        }
        .navigationTitle("Pod")
        .onAppear {
            viewModel.model.checkAWSToken()
        }
    }
}

//struct PodView_Previews: PreviewProvider {
//    static var previews: some View {
//        PodView(pod: Pod(id: "123", name: "123", k8sName: "123", status: "fail", expect: 8, warning: 7, containers: [Container(id: "abc", name: "abclong....", image: "hello",path: "/",policy: "r",pullPolicy: "r"), Container(id: "ef", name: "ef", image: "kkk", path: "/", policy: "r", pullPolicy: "r")],clusterIP: "10.0.0.3", nodeIP: "192.168.1.3", labels: ["l1":"l1v"],annotations: ["a1":"a1v"],namespace: "default", raw: nil), viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
//    }
//}

enum PodStatus: String {
    case Pending
    case Running
    case Succeeded
    case Failed
    case Unknown
}

enum PodControllerType: String {
    case ReplicaSet
    case Job
    case StatefulSet
    case DaemonSet
    case UnKonw
}
