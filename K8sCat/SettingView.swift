//
//  SettingView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/20.
//

import SwiftUI

struct SettingView: View {
    let viewModel: ViewModel
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        NavigationStack {
            Form{
                Section(){
                    Button{
                        if let url = URL(string: "https://github.com/buhe/KubeCat/issues") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        
                        Text("Feedback")
                        
                    }.buttonStyle(PlainButtonStyle())
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
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
    }
}
