//
//  PVView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/29.
//

import SwiftUI

struct PVView: View {
    let pv: PersistentVolume
    let viewModel: ViewModel
    var body: some View {
        Form {
            Section(header: "Name") {
                Text(pv.name)
            }
            Section(header: "Status") {
                Text(pv.status)
            }
            Section(header: "Access Modes") {
                Text(pv.accessModes)
            }
            Section(header: "Storage Class") {
                Text(pv.storageClass)
            }
            Section(header: "Labels and Annotations") {
                NavigationLink {
                    List {
                        ForEach((pv.labels ?? [:]).sorted(by: >), id: \.key) {
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
                        ForEach((pv.annotations ?? [:]).sorted(by: >), id: \.key) {
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
            
        }
    }
}

struct PVView_Previews: PreviewProvider {
    static var previews: some View {
        PVView(pv: PersistentVolume(id: "123", name: "123", labels: ["l1":"l1v"], annotations: ["l1":"l1v"],accessModes: "r/w",status: "B",storageClass: "M"), viewModel: ViewModel())
    }
}
