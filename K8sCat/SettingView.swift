//
//  SettingView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/20.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        NavigationStack {
            Form{
                Section(header: "Clsters") {
                    NavigationLink {
                        ClusterView()
                    } label: {
                        Text("Cluster Management")
                    }
                }
                Section(){
                    Button{
                        if let url = URL(string: "https://github.com/buhe/KubeCat/issues") {
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
        SettingView()
    }
}
