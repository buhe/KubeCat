//
//  PodView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/26.
//

import SwiftUI

struct PodView: View {
    let pod: Pod
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
                            ContainerView()
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

struct PodView_Previews: PreviewProvider {
    static var previews: some View {
        PodView(pod: Pod(id: "123", name: "123", k8sName: "123", status: "fail", expect: 8, pending: 7, containers: [Container(id: "abc", name: "abclong....", image: "hello"), Container(id: "ef", name: "ef", image: "kkk")]))
    }
}
