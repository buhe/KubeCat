//
//  CronJobView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/26.
//

import SwiftUI

struct CronJobView: View {
    let cronJob: CronJob
    let viewModel: ViewModel
    
    @State var showYaml = false
    var body: some View {
        Form {
            Section(header: "Name") {
                Text(cronJob.name)
            }
            Section(header: "Schedule") {
                Text(cronJob.schedule)
            }
            Section(header: "Pods") {
                List {
                    ForEach(viewModel.model.podsByCronJob(in: .namespace(viewModel.ns), cronJob: cronJob.k8sName)) {
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
                        ForEach((cronJob.labels ?? [:]).sorted(by: >), id: \.key) {
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
                        ForEach((cronJob.annotations ?? [:]).sorted(by: >), id: \.key) {
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
                    Text(cronJob.namespace)
                }
                
            }
        }.toolbar{
            Menu {
                Button {
                    // do something
                    let yaml = cronJob.encodeYaml(client: viewModel.model.client)
                    print("Yaml: \(yaml)")
                    showYaml = true
//                    deployment.decodeYaml(client: viewModel.model.client, yaml: yaml)
                } label: {
                    Text("View/Edit Yaml")
                    Image(systemName: "note.text")
                }
//                Button {
//                    // do something
//                } label: {
//                    Text("Delete Resource")
//                    Image(systemName: "trash")
//                }
            } label: {
                 Image(systemName: "ellipsis")
            }
        }.sheet(isPresented: $showYaml){
            YamlWebView(yamlble: cronJob, model: viewModel.model) {
                showYaml = false
            }
            Button{
                urlScheme(yamlble: cronJob, client: viewModel.model.client)
            }label: {
                Text("Load yaml via Yamler")
            }.padding()
        }
    }
}

//struct CronJobView_Previews: PreviewProvider {
//    static var previews: some View {
//        CronJobView(cronJob: CronJob(id: "123", name: "123", k8sName: "123", labels: ["l1":"l1v"], annotations: ["l1":"l1v"], namespace: "default", schedule: "10 / 5 * * *"), viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
//    }
//}
