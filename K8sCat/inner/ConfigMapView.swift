//
//  ConfigMapView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/26.
//

import SwiftUI

struct ConfigMapView: View {
    let configMap: ConfigMap
    let viewModel: ViewModel
    
    var body: some View {
        Form {
            Section(header: "Name") {
                Text(configMap.name)
            }
            Section(header: "Data") {
                
                    List {
                        ForEach((configMap.data ?? [:]).sorted(by: >), id: \.key) {
                            key, value in
                            NavigationLink {
                                Form{
                                    Section(header: "Name"){
                                        Text(key)
                                    }
                                    Section(header: "Data"){
                                        Text(value)
                                    }
                                    
                                    
                                }
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(key)
                                }
                            }
                        }
                    }
                    
                
                  
            }
            Section(header: "Labels and Annotations") {
                NavigationLink {
                    List {
                        ForEach((configMap.labels ?? [:]).sorted(by: >), id: \.key) {
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
                        ForEach((configMap.annotations ?? [:]).sorted(by: >), id: \.key) {
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
                    Text(configMap.namespace)
                }
                
            }
        }
    }
}

struct ConfigMapView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigMapView(configMap: ConfigMap(id: "abc", name: "abc", labels: ["l1":"l1v"], annotations: ["l1":"l1v"], namespace: "default", data: ["l1":"l1v"]), viewModel: ViewModel())
    }
}
