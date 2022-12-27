//
//  DaemonView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/26.
//

import SwiftUI

struct DaemonView: View {
    let daemon: Daemon
    let viewModel: ViewModel
    var body: some View {
        Form {
            Section(header: "Name") {
                Text(daemon.name)
            }
            Section(header: "Status") {
                
            }
            Section(header: "Pods") {
                List {
                    ForEach(viewModel.model.podsByDaemon(in: .namespace(viewModel.ns), daemon: daemon.k8sName)) {
                        i in
                        NavigationLink {
                            PodView(pod: i)
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

struct DaemonView_Previews: PreviewProvider {
    static var previews: some View {
        DaemonView(daemon: Daemon(id: "123", name: "123", k8sName: "123"), viewModel: ViewModel())
    }
}
