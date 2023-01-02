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
    let first: Bool
    let close: () -> Void
    var body: some View {
        NavigationStack {
            List {
                ForEach(ClusterType.allCases, id: \.self) {
                    c in
                    switch c {
                    case .KubeConfig:
                        NavigationLink {
                            NewClusterView(first: first, type: c){
                                presentationMode.wrappedValue.dismiss()
                                close()
                            }
                                .environment(\.managedObjectContext, viewContext)
                        } label: {
                            Image("config")
                            Text(c.rawValue)
                                
                           
                        }
                    case .Aliyun:
                        NavigationLink {
                            NewClusterView(first: first, type: c){
                                presentationMode.wrappedValue.dismiss()
                                close()
                            }
                                .environment(\.managedObjectContext, viewContext)
                        } label: {
                            Image("aliyun")
                            Text(c.rawValue)
                                
                           
                        }
                    case .AWS:
                        NavigationLink {
                            NewClusterView(first: first, type: c){
                                presentationMode.wrappedValue.dismiss()
                                close()
                            }
                                .environment(\.managedObjectContext, viewContext)
                        } label: {
                            Image("aws")
                            Text(c.rawValue)
                                
                           
                        }
                    default: EmptyView()
                    }
                    
                }
            }
        }
    }
}

struct ClusterTypeView_Previews: PreviewProvider {
    static var previews: some View {
        ClusterTypeView(first: true){}
    }
}
