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
        }
    }
}

struct CronJobView_Previews: PreviewProvider {
    static var previews: some View {
        CronJobView(cronJob: CronJob(id: "123", name: "123", k8sName: "123", labels: ["l1":"l1v"], annotations: ["l1":"l1v"], namespace: "default", schedule: "10 / 5 * * *"), viewModel: ViewModel())
    }
}
