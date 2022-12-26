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
            Section(header: "Containers") {
                List {
                    ForEach(pod.containers) {
                        c in VStack(alignment: .leading) {
                            Text(c.name)
                            Text("log").font(.caption)
                        }
                        
                    }
                }
            }
        }
    }
}

struct PodView_Previews: PreviewProvider {
    static var previews: some View {
        PodView(pod: Pod(id: "123", name: "123", expect: 8, pending: 7, fail: 6, containers: [Container(id: "abc", name: "abclong...."), Container(id: "ef", name: "ef")]))
    }
}
