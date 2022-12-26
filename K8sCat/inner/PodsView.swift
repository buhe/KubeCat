//
//  PodsView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/26.
//

import SwiftUI

struct PodsView: View {
    let pods: [Pod]
    
    var body: some View {
        List {
            ForEach(pods) {
                i in
                NavigationLink {
                    Text(i.name)
                } label: {
                    Text(i.name)
                }
        
            }
        }.listStyle(PlainListStyle())
    }
}

struct PodsView_Previews: PreviewProvider {
    static var previews: some View {
        PodsView(pods: [Pod(id: "123", name: "123")])
    }
}
