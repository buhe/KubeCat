//
//  ContainerView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/26.
//

import SwiftUI

struct ContainerView: View {
    var body: some View {
        Form {
            
        }.toolbar {
            Button {
                
            } label: {
                Label("shell", systemImage: "terminal")
            }
            
            Button {
                
            } label: {
                Label("log", systemImage: "doc.text.magnifyingglass")
            }
        }
    }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
}
