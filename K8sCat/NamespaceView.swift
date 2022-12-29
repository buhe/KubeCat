//
//  NamespaceView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/20.
//

import SwiftUI
import SwiftUIX

struct NamespaceView: View {
    @State var ns = "default"
    @State var search = ""
    @State var tabIndex = 0
    
    @ObservedObject var viewModel: ViewModel
    // must add @ObservedObject
    var body: some View {
        VStack {
            NavigationStack {
                Picker("ns", selection: $ns) {
                    ForEach(viewModel.namespaces, id: \.self) {
                        Text($0)
                     }
                }.onChange(of: ns) {
                    c in
                    viewModel.ns = c
                    switch tabIndex {
                    case 0:
                        try! viewModel.model.pod(in: .namespace(c))
                    case 1:
                        try! viewModel.model.deployment(in: .namespace(c))
                    case 2:
                        try! viewModel.model.job(in: .namespace(c))
                    case 3:
                        try! viewModel.model.cronJob(in: .namespace(c))
                    case 4:
                        try! viewModel.model.statefull(in: .namespace(c))
                    case 5:
                        try! viewModel.model.service(in: .namespace(c))
                    case 6:
                        try! viewModel.model.configMap(in: .namespace(c))
                    case 7:
                        try! viewModel.model.secret(in: .namespace(c))
                    case 8:
                        try! viewModel.model.daemon(in: .namespace(c))
                    case 9:
                        try! viewModel.model.replica(in: .namespace(c))
//                    case 10:
//                        try! viewModel.model.replication(in: .namespace(c))
                    default: break
                    }
                    
                }
                SearchBar(text: $search).padding(.horizontal)
                NamespacesTabBar(tabIndex: $tabIndex).padding(.horizontal, 12)
                Group {
                    switch tabIndex {
                    case 0:
                        List {
                            ForEach(viewModel.pods(in: .namespace(ns))) {
                                i in
                                NavigationLink {
                                    PodView(pod: i, viewModel: viewModel)
                                } label: {
                                    VStack(alignment: .leading) {
                                        switch i.status {
                                        case "Running", "Succeeded": Text(i.name).foregroundColor(.green)
                                        default: Text(i.name).foregroundColor(.red)
                                        }
                                        HStack{
                                            Text("expect: \(i.expect), ").font(.caption)
                                            Text("pendding: \(i.pending)").font(.caption).foregroundColor(i.pending > 0 ? .red : .none)
                                        }
                                        
                                    }
                                }
                        
                            }
                        }.listStyle(PlainListStyle())
                    case 1:
                        List {
                            ForEach(viewModel.deployment(in: .namespace(ns))) {
                                i in
                                NavigationLink {
                                    DeploymentView(deployment: i, viewModel: viewModel)
                                } label: {
                                    Image(systemName: "ipad.landscape.badge.play")
                                    VStack(alignment: .leading) {
                                        Text(i.name)
                                        HStack{
                                            Text("expect: \(i.expect), ").font(.caption)
                                            Text("pendding: \(i.pending)").font(.caption).foregroundColor(i.pending > 0 ? .red : .none)
                                        }
                                        
                                    }
                                }
                        
                            }
                        }.listStyle(PlainListStyle())
                    case 2:
                        List {
                            ForEach(viewModel.job(in: .namespace(ns))) {
                                i in
                                NavigationLink {
                                    Text(i.name)
                                } label: {
                                    Text(i.name)
                                }
                        
                            }
                        }.listStyle(PlainListStyle())
                    case 3:
                        List {
                            ForEach(viewModel.cronJob(in: .namespace(ns))) {
                                i in
                                NavigationLink {
                                    Text(i.name)
                                } label: {
                                    Text(i.name)
                                }
                        
                            }
                        }.listStyle(PlainListStyle())
                    case 4:
                        List {
                            ForEach(viewModel.statefull(in: .namespace(ns))) {
                                i in
                                NavigationLink {
                                    StatefulView(stateful: i, viewModel: viewModel)
                                } label: {
                                    Image(systemName: "macpro.gen2.fill")
                                    Text(i.name)
                                }
                        
                            }
                        }.listStyle(PlainListStyle())
                    case 5:
                        List {
                            ForEach(viewModel.service(in: .namespace(ns))) {
                                i in
                                NavigationLink {
                                    ServiceView(service: i, viewModel: viewModel)
                                } label: {
                                    VStack(alignment: .leading) {
                                        Text(i.name)
                                        VStack(alignment: .leading) {
                                            Text("Cluster IPs").font(.caption)
                                            ForEach(i.clusterIps ?? ["None"], id: \.self) {
                                                ip in
                                                
                                                Text(ip).font(.caption2)
                                                
                                            }
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text("External IPs").font(.caption)
                                            ForEach(i.externalIps ?? ["None"], id: \.self) {
                                                ip in
                                                
                                                Text(ip).font(.caption2)
                                                
                                            }
                                        }
                                    }
                                   
                                }
                        
                            }
                        }.listStyle(PlainListStyle())
                    case 6:
                        List {
                            ForEach(viewModel.configMap(in: .namespace(ns))) {
                                i in
                                NavigationLink {
                                    Text(i.name)
                                } label: {
                                    Text(i.name)
                                }
                        
                            }
                        }.listStyle(PlainListStyle())
                    case 7:
                        List {
                            ForEach(viewModel.secret(in: .namespace(ns))) {
                                i in
                                NavigationLink {
                                    Text(i.name)
                                } label: {
                                    Text(i.name)
                                }
                        
                            }
                        }.listStyle(PlainListStyle())
                    case 8:
                        List {
                            ForEach(viewModel.daemon(in: .namespace(ns))) {
                                i in
                                NavigationLink {
                                    DaemonView(daemon: i, viewModel: viewModel)
                                } label: {
                                    Image(systemName: "xserve")
                                    Text(i.name)
                                }
                        
                            }
                        }.listStyle(PlainListStyle())
                    case 9:
                        List {
                            ForEach(viewModel.replica(in: .namespace(ns))) {
                                i in
                                NavigationLink {
                                    ReplicaView(replica: i, viewModel: viewModel)
                                } label: {
                                    Text(i.name)
                                }
                        
                            }
                        }.listStyle(PlainListStyle())
//                    case 10:
//                        List {
//                            ForEach(viewModel.replication(in: .namespace(ns))) {
//                                i in
//                                NavigationLink {
//                                    Text(i.name)
//                                } label: {
//                                    Text(i.name)
//                                }
//
//                            }
//                        }.listStyle(PlainListStyle())
                    default:
                        EmptyView()
                    }
                }
                
            }
        }
        
        
    }
}

struct NamespaceView_Previews: PreviewProvider {
    static var previews: some View {
        NamespaceView(viewModel: ViewModel())
    }
}
