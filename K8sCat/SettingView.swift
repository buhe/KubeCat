//
//  SettingView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/20.
//

import SwiftUI
import StoreKit

struct SettingView: View {
    let viewModel: ViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        NavigationStack {
            Form{
                Section(){
                    Button{
                        #if os(iOS)
                        if let url = URL(string: "https://github.com/buhe/KubeCat/issues") {
                            UIApplication.shared.open(url)
                        }
                        #endif
                    } label: {
                        
                        Text("Feedback")
                        
                    }.buttonStyle(PlainButtonStyle())
                    Button{
                        requestReview()
                    } label: {
                        
                        Text("Rate")
                        
                    }.buttonStyle(PlainButtonStyle())
                    HStack{
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.releaseVersionNumber ?? "")
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
        SettingView(viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
    }
}
