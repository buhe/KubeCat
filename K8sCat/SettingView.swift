//
//  SettingView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/20.
//

import SwiftUI

struct SettingView: View {
    let viewModel: ViewModel
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        NavigationStack {
            Form{
//                Section(header: "Clsters") {
//                    NavigationLink {
//                        ClusterView(viewModel: viewModel)
//                            .environment(\.managedObjectContext, viewContext)
//                    } label: {
//                        Text("Cluster Management")
//                    }
//                }
                Section(){
                    Button{
                        let b64 = """
apiVersion: v1
kind: PersistentVolume
metadata:
  name: default
spec:
  storageClassName: manual
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  nfs:
    server: 10.244.1.4
    path: "/"
"""
                        let utf8str = b64.data(using: .utf8)
                        let base64Encoded = utf8str!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
                        if let url = URL(string: "yamler://" + base64Encoded) {
//                        if let url = URL(string: "https://github.com/buhe/KubeCat/issues") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        
                        Text("Feedback")
                        
                    }.buttonStyle(PlainButtonStyle())
                    HStack{
                        Text("Version")
                        Spacer()
                        Text("1")
                    }
                    HStack{
                        Text("License")
                        Spacer()
                        Text("GPLv3")
                    }
                }
                
                
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
    }
}
