//
//  DeploymentView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/26.
//

import SwiftUI
// deployment has child
struct DeploymentView: View {
    let deployment: Deployment
    let viewModel: ViewModel
    var body: some View {
        Form {
            Section(header: "Name") {
                Text(deployment.name)
            }
            Section(header: "Status") {
                
            }
            Section(header: "Pods") {
                List {
                    ForEach(viewModel.model.podsByDeployment(in: .namespace(viewModel.ns), deployment: deployment.k8sName)) {
                        i in
                        NavigationLink {
                            PodView(pod: i)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(i.name).foregroundColor(.green)
                                HStack{
                                    Text("expect: \(i.expect), ")
                                    Text("pendding: \(i.pending)").foregroundColor(i.pending > 0 ? .red : .black)
                                }
                                
                            }
                        }
                    }
                }
            }
            Section(header: "Labels and Annotations") {
                
            }
            Section(header: "Ip") {
                HStack{
                    Text("Node IP")
                    Spacer()
                    Text("192.168.3.4")
                }
            }
            Section(header: "Misc") {
                HStack{
                    Text("Namespace")
                    Spacer()
                    Text("monitoring")
                }
                
            }
        }
    }
}

struct DeploymentView_Previews: PreviewProvider {
    static var previews: some View {
        DeploymentView(deployment:  Deployment(id: "123", name: "123", k8sName: "123", expect: 1, pending: 0), viewModel: ViewModel())
    }
}
