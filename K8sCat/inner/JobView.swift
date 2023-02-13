//
//  JobView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/26.
//

import SwiftUI

struct JobView: View {
    @State var pods: [Pod] = []
    let job: Job
    let viewModel: ViewModel
    var body: some View {
        Form {
            Section(header: "Name") {
                Text(job.name)
            }
            Section(header: "Status") {
                Text(job.status ? "Succeeded" : "Failed")
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
                pods = await viewModel.model.podsByJob(in: .namespace(viewModel.ns), job: job.k8sName)
            }
            Section(header: "Labels and Annotations") {
                NavigationLink {
                    List {
                        ForEach((job.labels ?? [:]).sorted(by: >), id: \.key) {
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
                        ForEach((job.annotations ?? [:]).sorted(by: >), id: \.key) {
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
                    Text(job.namespace)
                }
                
            }
        }
        .navigationTitle("Job")
    }
}

struct JobView_Previews: PreviewProvider {
    static var previews: some View {
        JobView(job: Job(id: "123", name: "123", k8sName: [:], labels: ["l1":"l1v"], annotations: ["l1":"l1v"], namespace: "default", status: false), viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
    }
}
