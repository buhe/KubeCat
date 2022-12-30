//
//  SettingView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/20.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        Form{
            Section(header: "Clsters") {
                Button{
                    
                } label: {

                        Text("Cluster Management")

                }
            }
            Section(){
                Button{
                    
                } label: {

                        Text("Submit Issue")

                }
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

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
