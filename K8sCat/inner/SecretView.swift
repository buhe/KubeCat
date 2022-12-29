//
//  SecretView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/26.
//

import SwiftUI

struct SecretView: View {
    let secret: Secret
    let viewModel: ViewModel
    var body: some View {
        Form {
            Section(header: "Name") {
                Text(secret.name)
            }
            Section(header: "Data") {
                
                    List {
                        ForEach((secret.data ?? [:]).sorted(by: >), id: \.key) {
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
                        ForEach((secret.labels ?? [:]).sorted(by: >), id: \.key) {
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
                        ForEach((secret.annotations ?? [:]).sorted(by: >), id: \.key) {
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
                    Text(secret.namespace)
                }
                
            }
        }
    }
}

struct SecretView_Previews: PreviewProvider {
    static var previews: some View {
        SecretView(secret: Secret(id: "abc", name: "abc", labels: ["l1":"l1v"], annotations: ["l1":"l1v"], namespace: "default", data: ["l1":"l1v"]), viewModel: ViewModel())
    }
}
