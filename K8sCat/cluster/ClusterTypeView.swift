//
//  ClusterTypeView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/31.
//

import SwiftUI

struct ClusterTypeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    let close: () -> Void
    var body: some View {
        NavigationStack {
            List {
                ForEach(ClusterType.allCases, id: \.self) {
                    c in
                    NavigationLink {
                        NewClusterView(type: c){
                            presentationMode.wrappedValue.dismiss()
                            close()
                        }
                            .environment(\.managedObjectContext, viewContext)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(c.rawValue)
                            
                        }
                    }
                }
            }
        }
    }
}

struct ClusterTypeView_Previews: PreviewProvider {
    static var previews: some View {
        ClusterTypeView{}
    }
}
