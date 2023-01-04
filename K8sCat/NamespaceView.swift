//
//  NamespaceView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/20.
//

import SwiftUI
import SwiftUIX

struct NamespaceView: View {
    
    @State var search = ""
    @State var tabIndex = 0
    @Environment(\.managedObjectContext) private var viewContext
    // must add @ObservedObject
    @ObservedObject var viewModel: ViewModel
    @State var showCluster = false
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var cluters: FetchedResults<ClusterEntry>
   
    var body: some View {
        VStack {
            NavigationStack {
                ZStack(){
                    HStack{
                        Spacer()
                        Button{showCluster = true}label: {
                            
                            
                            Image(systemName: cluters.filter{$0.selected}.first!.icon!)
                        }.padding(.trailing)
                    }
                    HStack{
                        Spacer()
                        Picker("ns", selection: $viewModel.ns) {
                            ForEach(viewModel.namespaces, id: \.self) {
                                Text($0)
                            }
                        }.onChange(of: viewModel.ns) {
                            c in
                            
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
                            case 10:
                                try! viewModel.model.hpa(in: .namespace(c))
                            default: break
                            }
                            
                        }
                        Spacer()
                        
                    }
                    
                }
                SearchBar(text: $search)
                    .padding(.horizontal)
                NamespacesTabBar(tabIndex: $tabIndex).padding(.horizontal, 26)
                Group {
                    switch tabIndex {
                    case 0:
                        List {
                            ForEach(viewModel.pods.filter{$0.name.contains(search.lowercased()) || search == ""}) {
                                i in
                                NavigationLink {
                                    PodView(pod: i, viewModel: viewModel)
                                } label: {
                                    Image(systemName: "tray.2")
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
                        .refreshable {
                            viewModel.model.pods[viewModel.ns] = nil
                        }
                    case 1:
                        List {
                            ForEach(viewModel.deployment.filter{$0.name.contains(search.lowercased()) || search == ""}) {
                                i in
                                NavigationLink {
                                    DeploymentView(deployment: i, viewModel: viewModel)
                                } label: {
                                    Image(systemName: "ipad.landscape.badge.play")
                                    VStack(alignment: .leading) {
                                        Text(i.name)
                                            .foregroundColor(i.status ? .green : .red)
                                        HStack{
                                            Text("expect: \(i.expect), ").font(.caption)
                                            Text("pendding: \(i.pending)").font(.caption).foregroundColor(i.pending > 0 ? .red : .none)
                                        }
                                        
                                    }
                                }
                        
                            }
                        }.listStyle(PlainListStyle())
                        .refreshable {
                            viewModel.model.deployments[viewModel.ns] = nil
                        }
                    case 2:
                        List {
                            ForEach(viewModel.job.filter{$0.name.contains(search.lowercased()) || search == ""}) {
                                i in
                                NavigationLink {
                                    JobView(job: i, viewModel: viewModel)
                                } label: {
                                    Image(systemName: "figure.run")
                                    Text(i.name)
                                        .foregroundColor(i.status ? .green : .red)
                                }
                        
                            }
                        }.listStyle(PlainListStyle())
                        .refreshable {
                            viewModel.model.jobs[viewModel.ns] = nil
                        }
                    case 3:
                        List {
                            ForEach(viewModel.cronJob.filter{$0.name.contains(search.lowercased()) || search == ""}) {
                                i in
                                NavigationLink {
                                    CronJobView(cronJob: i, viewModel: viewModel)
                                } label: {
                                    Image(systemName: "timer")
                                    VStack(alignment: .leading) {
                                        Text(i.name)
                                        CaptionText(text: i.schedule)
                                    }
                                    
                                }
                        
                            }
                        }.listStyle(PlainListStyle())
                        .refreshable {
                            viewModel.model.cronJobs[viewModel.ns] = nil
                        }
                    case 4:
                        List {
                            ForEach(viewModel.statefull.filter{$0.name.contains(search.lowercased()) || search == ""}) {
                                i in
                                NavigationLink {
                                    StatefulView(stateful: i, viewModel: viewModel)
                                } label: {
                                    Image(systemName: "macpro.gen2.fill")
                                    Text(i.name)
                                        .foregroundColor(i.status ? .green : .red)
                                }
                        
                            }
                        }.listStyle(PlainListStyle())
                        .refreshable {
                            viewModel.model.statefulls[viewModel.ns] = nil
                        }
                    case 5:
                        List {
                            ForEach(viewModel.service.filter{$0.name.contains(search.lowercased()) || search == ""}) {
                                i in
                                NavigationLink {
                                    ServiceView(service: i, viewModel: viewModel)
                                } label: {
                                    Image(systemName: "paperplane")
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
                        .refreshable {
                            viewModel.model.services[viewModel.ns] = nil
                        }
                    case 6:
                        List {
                            ForEach(viewModel.configMap.filter{$0.name.contains(search.lowercased()) || search == ""}) {
                                i in
                                NavigationLink {
                                    ConfigMapView(configMap: i, viewModel: viewModel)
                                } label: {
                                    Image(systemName: "note.text")
                                    VStack(alignment: .leading) {
                                        Text(i.name)
                                        CaptionText(text: "\(i.data?.count ?? 0) keys")
                                    }
                                }
                        
                            }
                        }.listStyle(PlainListStyle())
                        .refreshable {
                            viewModel.model.configMaps[viewModel.ns] = nil
                        }
                    case 7:
                        List {
                            ForEach(viewModel.secret.filter{$0.name.contains(search.lowercased()) || search == ""}) {
                                i in
                                NavigationLink {
                                    SecretView(secret: i, viewModel: viewModel)
                                } label: {
                                    Image(systemName: "lock.doc")
                                    VStack(alignment: .leading) {
                                        Text(i.name)
                                        CaptionText(text: "\(i.data?.count ?? 0) keys")
                                    }
                                }
                        
                            }
                        }.listStyle(PlainListStyle())
                        .refreshable {
                            viewModel.model.secrets[viewModel.ns] = nil
                        }
                    case 8:
                        List {
                            ForEach(viewModel.daemon.filter{$0.name.contains(search.lowercased()) || search == ""}) {
                                i in
                                NavigationLink {
                                    DaemonView(daemon: i, viewModel: viewModel)
                                } label: {
                                    Image(systemName: "xserve")
                                    Text(i.name)
                                        .foregroundColor(i.status ? .green : .red)
                                }
                        
                            }
                        }.listStyle(PlainListStyle())
                        .refreshable {
                            viewModel.model.daemons[viewModel.ns] = nil
                        }
                    case 9:
                        List {
                            ForEach(viewModel.replica.filter{$0.name.contains(search.lowercased()) || search == ""}) {
                                i in
                                NavigationLink {
                                    ReplicaView(replica: i, viewModel: viewModel)
                                } label: {
                                    Image(systemName: "square.3.layers.3d.down.left")
                                    Text(i.name)
                                        .foregroundColor(i.status ? .green : .red)
                                }
                        
                            }
                        }.listStyle(PlainListStyle())
                        .refreshable {
                            viewModel.model.replicas[viewModel.ns] = nil
                        }
                    case 10:
                        List {
                            ForEach(viewModel.hpas.filter{$0.name.contains(search.lowercased()) || search == ""}) {
                                i in
                                NavigationLink {
                                    HpaView(hpa: i, viewModel: viewModel)
                                } label: {
                                    Image(systemName: "scale.3d")
                                    Text(i.name)
                                }

                            }
                        }.listStyle(PlainListStyle())
                        .refreshable {
                            viewModel.model.hpas[viewModel.ns] = nil
                        }
                    default:
                        EmptyView()
                    }
                }
                
            }
        }.sheet(isPresented: $showCluster){
            ClusterView(viewModel: viewModel){
                showCluster = false
            }
                .environment(\.managedObjectContext, viewContext)
        }
        
        
    }
}

struct NamespaceView_Previews: PreviewProvider {
    static var previews: some View {
        NamespaceView(viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
    }
}
