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
            Section(header: "Status") {
                
            }
//           
//            Section(header: "Labels and Annotations") {
//                NavigationLink {
//                    List {
//                        ForEach((hpa.labels ?? [:]).sorted(by: >), id: \.key) {
//                            key, value in
//                            VStack(alignment: .leading) {
//                                Text(key)
//                                
//                                CaptionText(text: value)
//                            }
//                        }
//                    }
//                    
//                } label: {
//                    Text("Labels")
//                }
//                NavigationLink {
//                    List {
//                        ForEach((hpa.annotations ?? [:]).sorted(by: >), id: \.key) {
//                            key, value in
//                            VStack(alignment: .leading) {
//                                Text(key)
//                                CaptionText(text: value)
//                            }
//                        }
//                    }
//                } label: {
//                    Text("Annotations")
//                }
//            }
          
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
