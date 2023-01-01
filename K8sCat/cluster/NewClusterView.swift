//
//  NewClusterView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/31.
//

import SwiftUI

struct NewClusterView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let first: Bool
    let type: ClusterType
    let close: () -> Void
    var body: some View {
        switch type {
        case .KubeConfig:
            ConfigView(first: first){
                close()
            }
                .environment(\.managedObjectContext, viewContext)
        default: EmptyView()
        }
    }
}

struct NewClusterView_Previews: PreviewProvider {
    static var previews: some View {
        NewClusterView(first: true, type: .Demo){}
    }
}
