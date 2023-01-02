//
//  HpaView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2023/1/2.
//

import SwiftUI

struct HpaView: View {
    let hpa: Hpa
    var body: some View {
        Form {
            Section(header: "Name") {
                Text(hpa.name)
            }
            Section(header: "Misc") {
                HStack{
                    Text("Namespace")
                    Spacer()
                    Text(hpa.namespace)
                }
                
            }
        }
    }
}

struct HpaView_Previews: PreviewProvider {
    static var previews: some View {
        HpaView(hpa:  Hpa(id: "123", name: "123", namespace: "default"))
    }
}
