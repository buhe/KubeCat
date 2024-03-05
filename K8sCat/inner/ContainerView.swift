//
//  ContainerView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/26.
//

import SwiftUI
import SwiftkubeClient
import SwiftkubeModel
import SwiftUIX

struct ContainerView: View {
    let pod: Pod
    let container: Container
    let viewModel: ViewModel
    
    @State var showLogs = false
    @State var showShell = false
    
    
    func logs() -> SwiftkubeClientTask<String>? {
        viewModel.model.logs(in: .namespace(viewModel.ns), pod: pod, container: container)
    }
    
    var body: some View {
        Form {
            Section(header: "Name") {
                Text(container.name)
            }
            Section(header: "Status") {
                Text(container.status.rawValue)
            }
            Section(header: "Error") {
                Text(container.error ? "True" : "False")
                    .foregroundColor(container.error ? .red : .none)
            }
            Section(header: "Ready") {
                Text(container.ready ? "True" : "False")
                    .foregroundColor(container.ready ? .none : .yellow)
            }
            Section(header: "Image") {
                Text(container.image).font(.caption)
            }
            Section(header: "Termination Message") {
                HStack{
                    Text("Path")
                    Spacer()
                    Text(container.path)
                }
                HStack{
                    Text("Policy")
                    Spacer()
                    Text(container.policy)
                }
            }
            
            Section(header: "Misc") {
                HStack{
                    Text("Pull Policy")
                    Spacer()
                    Text(container.pullPolicy)
                }
                
            }
        }
        .toolbar {
//            Button {
//                showShell = true
//            } label: {
//                Label("shell", systemImage: "terminal")
//            }
            
            Button {
                viewModel.logTask = logs()
                showLogs = true
                
            } label: {
                Label("log", systemImage: "doc.text.magnifyingglass")
            }
        }.sheet(isPresented: $showLogs, onDismiss: {
            viewModel.logTask?.cancel()
        }) {
            LogView(logTask: viewModel.logTask)
        }
        .sheet(isPresented: $showShell) {
//            WebView(pod: pod, container: container).padding()
        }
        .navigationTitle("Container")
    }
}

//struct ContainerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContainerView()
//    }
//}

enum ContainerStatus: String {
    case Running
    case Waiting
    case Terminated
}
