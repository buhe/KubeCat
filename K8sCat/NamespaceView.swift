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
                            
                            
                            Image(systemName: cluters.filter{$0.selected}.first?.icon ?? "0.circle")
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
                            Task {
                                switch tabIndex {
                                case 0:
                                    await viewModel.pods()
                                case 1:
                                    await viewModel.deployment()
                                case 2:
                                    await viewModel.job()
                                case 3:
                                    await viewModel.cronJob()
                                case 4:
                                    await viewModel.statefull()
                                case 5:
                                    await viewModel.service()
                                case 6:
                                    await viewModel.configMap()
                                case 7:
                                    await viewModel.secret()
                                case 8:
                                    await viewModel.daemon()
                                case 9:
                                    await viewModel.replica()
                                case 10:
                                    await viewModel.hpas()
                                default: break
                                }
                            }
                        }
//                        .onAppear {
//                            Task {
//                                await viewModel.namespace()
//                            }
//                        }
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
                                            Text("containers -").font(.caption)
                                            Text("expect: \(i.expect), ").font(.caption)
                                            Text("error: \(i.status == PodStatus.Succeeded.rawValue ? 0 : i.error)").font(.caption).foregroundColor((i.status == PodStatus.Succeeded.rawValue ? 0 : i.error) > 0 ? .red : .none)
                                            Text("not ready: \(i.status == PodStatus.Succeeded.rawValue ? 0 :i.notReady)").font(.caption).foregroundColor((i.status == PodStatus.Succeeded.rawValue ? 0 : i.notReady) > 0 ? .yellow : .none)
                                        }
                                        
                                    }
                                }
                        
                            }
                        }.listStyle(PlainListStyle())
                            .onAppear {
                                Task {
                                    await viewModel.pods()
                                }
                            }
                        .refreshable {
                            viewModel.model.pods[viewModel.ns] = nil
                            Task {
                                await viewModel.pods()
                            }
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
                            .onAppear{
                                Task {
                                    await viewModel.deployment()
                                }
                            }
                        .refreshable {
                            viewModel.model.deployments[viewModel.ns] = nil
                            Task {
                                await viewModel.deployment()
                            }
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
                            .onAppear{
                                Task {
                                    await viewModel.job()
                                }
                            }
                        .refreshable {
                            viewModel.model.jobs[viewModel.ns] = nil
                            Task {
                                await viewModel.job()
                            }
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
                            .onAppear{
                                Task {
                                    await viewModel.cronJob()
                                }
                            }
                        .refreshable {
                            viewModel.model.cronJobs[viewModel.ns] = nil
                            Task {
                                await viewModel.cronJob()
                            }
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
                            .onAppear{
                                Task {
                                    await viewModel.statefull()
                                }
                            }
                        .refreshable {
                            viewModel.model.statefulls[viewModel.ns] = nil
                            Task {
                                await viewModel.statefull()
                            }
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
                            .onAppear{
                                Task {
                                    await viewModel.service()
                                }
                            }
                        .refreshable {
                            viewModel.model.services[viewModel.ns] = nil
                            Task {
                                await viewModel.service()
                            }
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
                            .onAppear{
                                Task {
                                    await viewModel.configMap()
                                }
                            }
                        .refreshable {
                            viewModel.model.configMaps[viewModel.ns] = nil
                            Task {
                                await viewModel.configMap()
                            }
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
                            .onAppear{
                                Task {
                                    await viewModel.secret()
                                }
                            }
                        .refreshable {
                            viewModel.model.secrets[viewModel.ns] = nil
                            Task {
                                await viewModel.secret()
                            }
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
                            .onAppear{
                                Task {
                                    await viewModel.daemon()
                                }
                            }
                        .refreshable {
                            viewModel.model.daemons[viewModel.ns] = nil
                            Task {
                                await viewModel.daemon()
                            }
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
                            .onAppear{
                                Task {
                                    await viewModel.replica()
                                }
                            }
                        .refreshable {
                            viewModel.model.replicas[viewModel.ns] = nil
                            Task {
                                await viewModel.replica()
                            }
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
                            .onAppear{
                                Task {
                                    await viewModel.hpas()
                                }
                            }
                        .refreshable {
                            viewModel.model.hpas[viewModel.ns] = nil
                            Task {
                                await viewModel.hpas()
                            }
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
