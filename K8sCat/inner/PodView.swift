//
//  PodView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/26.
//

import SwiftUI

struct PodView: View {
    let pod: Pod
    let viewModel: ViewModel
    var body: some View {
        Form {
            Section(header: "Name") {
                Text(pod.name)
            }
            Section(header: "Status") {
                Text(pod.status)
            }
            Section(header: "Containers") {
                List {
                    ForEach(pod.containers) {
                        c in
                        NavigationLink {
                            ContainerView(pod: pod, container: c, viewModel: viewModel)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(c.name)
                                CaptionText(text: c.image)
                            }
                        }
                        
                        
                    }
                }
            }
            Section(header: "Labels and Annotations") {
                NavigationLink {
                    List {
                        ForEach((pod.labels ?? [:]).sorted(by: >), id: \.key) {
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
                        ForEach((pod.annotations ?? [:]).sorted(by: >), id: \.key) {
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
                HStack{
                    Text("Pod IP")
                    Spacer()
                    Text(pod.clusterIP)
                }
                HStack{
                    Text("Node IP")
                    Spacer()
                    Text(pod.nodeIP)
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

struct PodView_Previews: PreviewProvider {
    static var previews: some View {
        PodView(pod: Pod(id: "123", name: "123", k8sName: "123", status: "fail", expect: 8, pending: 7, containers: [Container(id: "abc", name: "abclong....", image: "hello"), Container(id: "ef", name: "ef", image: "kkk")],clusterIP: "10.0.0.3", nodeIP: "192.168.1.3", labels: ["l1":"l1v"],annotations: ["a1":"a1v"]), viewModel: ViewModel())
    }
}
