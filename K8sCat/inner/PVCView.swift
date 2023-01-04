//
//  PVCView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/29.
//

import SwiftUI

struct PVCView: View {
    let pvc: PersistentVolumeClaim
    let viewModel: ViewModel
    
//    @State var showYaml = false
    var body: some View {
        Form {
            Section(header: "Name") {
                Text(pvc.name)
            }
            
            
        }
//            .toolbar{
//            Menu {
//                Button {
//                    // do something
//                    let yaml = pvc.encodeYaml(client: viewModel.model.client)
//                    print("Yaml: \(yaml)")
//                    showYaml = true
////                    deployment.decodeYaml(client: viewModel.model.client, yaml: yaml)
//                } label: {
//                    Text("View/Edit Yaml")
//                    Image(systemName: "note.text")
//                }
//                Button {
//                    // do something
//                } label: {
//                    Text("Delete Resource")
//                    Image(systemName: "trash")
//                }
//            } label: {
//                 Image(systemName: "ellipsis")
//            }
//        }.sheet(isPresented: $showYaml){
//            YamlWebView(yamlble: pvc, model: viewModel.model) {
//                showYaml = false
//            }
//            Button{
//                urlScheme(yamlble: pvc, client: viewModel.model.client)
//            }label: {
//                Text("Load yaml via Yamler")
//            }.padding()
//        }
    }
}

//struct PVCView_Previews: PreviewProvider {
//    static var previews: some View {
//        PVCView()
//    }
//}
