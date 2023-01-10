//
//  ServiceView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/26.
//

import SwiftUI

struct ServiceView: View {
    let service: Service
    let viewModel: ViewModel
    var body: some View {
        Form {
            Section(header: "Name") {
                Text(service.name)
            }
            Section(header: "Pods") {
                List {
                    ForEach(viewModel.model.podsByService(in: .namespace(viewModel.ns), service: service.k8sName)) {
                        i in
                        NavigationLink {
                            PodView(pod: i, viewModel: viewModel)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(i.name)
                                HStack{
                                    CaptionText(text: "expect: \(i.expect), ")
                                    CaptionText(text: "warning: \(i.warning)").foregroundColor(i.warning > 0 ? .red : .none)
                                }
                                
                            }
                        }
                    }
                }
            }
            Section(header: "Labels and Annotations") {
                NavigationLink {
                    List {
                        ForEach((service.labels ?? [:]).sorted(by: >), id: \.key) {
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
                        ForEach((service.annotations ?? [:]).sorted(by: >), id: \.key) {
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
                List {
                    
                    VStack(alignment: .leading) {
                        Text("Cluster IPs")
                        ForEach(service.clusterIps ?? ["None"], id: \.self) {
                            ip in
                            
                            CaptionText(text: ip)
                            
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("External IPs")
                        ForEach(service.externalIps ?? ["None"], id: \.self) {
                            ip in
                            
                            CaptionText(text: ip)
                            
                        }
                    }
                }
            }
            Section(header: "Misc") {
                HStack{
                    Text("Namespace")
                    Spacer()
                    Text(service.namespace)
                }
                
            }
        }
    }
}

struct ServiceView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceView(service: Service(id: "123", name: "123", k8sName: "123", type: "clusterIP", clusterIps: ["10.0.0.3"], externalIps: nil, labels: ["l1":"l1v"],annotations: ["a1":"a1v"],namespace: "default"), viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
    }
}
