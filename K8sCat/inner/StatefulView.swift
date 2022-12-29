//
//  StatefulView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/26.
//

import SwiftUI

struct StatefulView: View {
    let stateful: Stateful
    let viewModel: ViewModel
    var body: some View {
        Form {
            Section(header: "Name") {
                Text(stateful.name)
            }
            Section(header: "Status") {
                
            }
            Section(header: "Pods") {
                List {
                    ForEach(viewModel.model.podsByStateful(in: .namespace(viewModel.ns), stateful: stateful.k8sName)) {
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
                        ForEach((stateful.labels ?? [:]).sorted(by: >), id: \.key) {
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
                        ForEach((stateful.annotations ?? [:]).sorted(by: >), id: \.key) {
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
                    Text(stateful.namespace)
                }
                
            }
        }
    }
}

struct StatefulView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulView(stateful: Stateful(id: "123", name: "123", k8sName: "123", labels: ["l1":"l1v"],annotations: ["a1":"a1v"],namespace: "default"), viewModel: ViewModel())
    }
}
