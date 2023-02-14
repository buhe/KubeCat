//
//  ClusterSelectView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2023/2/14.
//

import SwiftUI

struct ClusterSelectView: View {
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var cluters: FetchedResults<ClusterEntry>
    @Environment(\.managedObjectContext) private var viewContext
    
    let action: () -> Void
    var body: some View {
        Button{action()}label: {
            Image(systemName: cluters.filter{$0.selected}.first?.icon! ?? "0.circle")
        }.padding(.trailing)
    }
}

struct ClusterSelectView_Previews: PreviewProvider {
    static var previews: some View {
        ClusterSelectView{}
    }
}
