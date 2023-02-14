//
//  NamespaceView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/20.
//

import SwiftUI
import SwiftUIX

struct NamespaceView: View {
    @State var pods: [Pod] = []
    @State var deploments: [Deployment] = []
    @State var jobs: [Job] = []
    @State var cronJobs: [CronJob] = []

    
    
    @State var search = ""
    @State var tabIndex = 0
    @Environment(\.managedObjectContext) private var viewContext
    // must add @ObservedObject
    @State var viewModel: ViewModel
    @State var showCluster = false
    
    func loadData() async {
        switch tabIndex {
        case 0:
            await loadPods()
        case 1:
            await loadDeplotment()
        default: break
        }
    }

    func loadPods() async {
        self.pods = await viewModel.model.pods().filter{$0.name.contains(search.lowercased()) || search == ""}
    }
    
    func loadDeplotment() async {
        self.deploments = await viewModel.model.deployment().filter{$0.name.contains(search.lowercased()) || search == ""}
    }
    
    func loadJob() async {
        self.jobs = await viewModel.model.job().filter{$0.name.contains(search.lowercased()) || search == ""}
    }
    
    var body: some View {
        VStack {
            NavigationStack {
                ZStack(){
                    HStack{
                        Spacer()
                        ClusterSelectView{
                            showCluster = true
                        }
                        .environment(\.managedObjectContext, viewContext)
                    }
                    HStack{
                        Spacer()
                        Picker("ns", selection: $viewModel.model.ns) {
                            ForEach(viewModel.namespaces, id: \.self) {
                                Text($0)
                            }
                        }
                        .onChange(of: viewModel.model.ns){
                            c in
                            print(c)
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
                                            Text("expect: \(i.expect), ").font(.caption)
                                            Text("error: \(i.status == PodStatus.Succeeded.rawValue ? 0 : i.error)").font(.caption).foregroundColor((i.status == PodStatus.Succeeded.rawValue ? 0 : i.error) > 0 ? .red : .none)
                                            Text("not ready: \(i.status == PodStatus.Succeeded.rawValue ? 0 :i.notReady)").font(.caption).foregroundColor((i.status == PodStatus.Succeeded.rawValue ? 0 : i.notReady) > 0 ? .yellow : .none)
                                        }
                                        
                                    }
                                }
                        
                            }
                        }.listStyle(PlainListStyle())
                        .refreshable {
                            Task {
                                await loadPods()
                            }
                        }
                    case 1:
                        List {
                            ForEach(deploments) {
                                i in
                                NavigationLink {
                                    DeploymentView(deployment: i, viewModel: viewModel)
                                } label: {
                                    Image(systemName: "ipad.landscape.badge.play")
                                    VStack(alignment: .leading) {
                                        Text(i.name)
//                                            .foregroundColor(i.status ? .green : .red)
                                        HStack{
                                            Text("pods -").font(.caption)
                                            Text("expect: \(i.expect), ").font(.caption)
                                            Text("unavailable: \(i.unavailable)").font(.caption).foregroundColor(i.unavailable > 0 ? .red : .none)
                                        }
                                        
                                    }
                                }
                        
                            }
                        }.listStyle(PlainListStyle())
                        .refreshable {
                            Task {
                                await loadDeplotment()
                            }
                        }
                    case 2:
                        List {
                            ForEach(jobs) {
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
                            
                        }
                    case 3:
                        List {
                            ForEach(cronJobs) {
//                            ForEach(viewModel.cronJob.filter{$0.name.contains(search.lowercased()) || search == ""}) {
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
                            
                        }
//                    case 4:
//                        List {
//                            ForEach(jobs) {
////                            ForEach(viewModel.statefull.filter{$0.name.contains(search.lowercased()) || search == ""}) {
//                                i in
//                                NavigationLink {
//                                    StatefulView(stateful: i, viewModel: viewModel)
//                                } label: {
//                                    Image(systemName: "macpro.gen2.fill")
//                                    Text(i.name)
//                                        .foregroundColor(i.status ? .green : .red)
//                                }
//
//                            }
//                        }.listStyle(PlainListStyle())
//                        .refreshable {
//                            viewModel.model.statefulls[viewModel.ns] = nil
//                        }
//                    case 5:
//                        List {
//                            ForEach(viewModel.service.filter{$0.name.contains(search.lowercased()) || search == ""}) {
//                                i in
//                                NavigationLink {
//                                    ServiceView(service: i, viewModel: viewModel)
//                                } label: {
//                                    Image(systemName: "paperplane")
//                                    VStack(alignment: .leading) {
//                                        Text(i.name)
//                                        VStack(alignment: .leading) {
//                                            Text("Cluster IPs").font(.caption)
//                                            ForEach(i.clusterIps ?? ["None"], id: \.self) {
//                                                ip in
//
//                                                Text(ip).font(.caption2)
//
//                                            }
//                                        }
//
//                                        VStack(alignment: .leading) {
//                                            Text("External IPs").font(.caption)
//                                            ForEach(i.externalIps ?? ["None"], id: \.self) {
//                                                ip in
//
//                                                Text(ip).font(.caption2)
//
//                                            }
//                                        }
//                                    }
//
//                                }
//
//                            }
//                        }.listStyle(PlainListStyle())
//                        .refreshable {
//                            viewModel.model.services[viewModel.ns] = nil
//                        }
//                    case 6:
//                        List {
//                            ForEach(viewModel.configMap.filter{$0.name.contains(search.lowercased()) || search == ""}) {
//                                i in
//                                NavigationLink {
//                                    ConfigMapView(configMap: i, viewModel: viewModel)
//                                } label: {
//                                    Image(systemName: "note.text")
//                                    VStack(alignment: .leading) {
//                                        Text(i.name)
//                                        CaptionText(text: "\(i.data?.count ?? 0) keys")
//                                    }
//                                }
//
//                            }
//                        }.listStyle(PlainListStyle())
//                        .refreshable {
//                            viewModel.model.configMaps[viewModel.ns] = nil
//                        }
//                    case 7:
//                        List {
//                            ForEach(viewModel.secret.filter{$0.name.contains(search.lowercased()) || search == ""}) {
//                                i in
//                                NavigationLink {
//                                    SecretView(secret: i, viewModel: viewModel)
//                                } label: {
//                                    Image(systemName: "lock.doc")
//                                    VStack(alignment: .leading) {
//                                        Text(i.name)
//                                        CaptionText(text: "\(i.data?.count ?? 0) keys")
//                                    }
//                                }
//
//                            }
//                        }.listStyle(PlainListStyle())
//                        .refreshable {
//                            viewModel.model.secrets[viewModel.ns] = nil
//                        }
//                    case 8:
//                        List {
//                            ForEach(viewModel.daemon.filter{$0.name.contains(search.lowercased()) || search == ""}) {
//                                i in
//                                NavigationLink {
//                                    DaemonView(daemon: i, viewModel: viewModel)
//                                } label: {
//                                    Image(systemName: "xserve")
//                                    Text(i.name)
//                                        .foregroundColor(i.status ? .green : .red)
//                                }
//
//                            }
//                        }.listStyle(PlainListStyle())
//                        .refreshable {
//                            viewModel.model.daemons[viewModel.ns] = nil
//                        }
//                    case 9:
//                        List {
//                            ForEach(viewModel.replica.filter{$0.name.contains(search.lowercased()) || search == ""}) {
//                                i in
//                                NavigationLink {
//                                    ReplicaView(replica: i, viewModel: viewModel)
//                                } label: {
//                                    Image(systemName: "square.3.layers.3d.down.left")
//                                    Text(i.name)
//                                        .foregroundColor(i.status ? .green : .red)
//                                }
//
//                            }
//                        }.listStyle(PlainListStyle())
//                        .refreshable {
//                            viewModel.model.replicas[viewModel.ns] = nil
//                        }
//                    case 10:
//                        List {
//                            ForEach(viewModel.hpas.filter{$0.name.contains(search.lowercased()) || search == ""}) {
//                                i in
//                                NavigationLink {
//                                    HpaView(hpa: i, viewModel: viewModel)
//                                } label: {
//                                    Image(systemName: "scale.3d")
//                                    Text(i.name)
//                                }
//
//                            }
//                        }.listStyle(PlainListStyle())
//                        .refreshable {
//                            viewModel.model.hpas[viewModel.ns] = nil
//                        }
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
        .task {
            await loadData()
        }
        
        
    }
}

struct NamespaceView_Previews: PreviewProvider {
    static var previews: some View {
        NamespaceView(viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
    }
}
