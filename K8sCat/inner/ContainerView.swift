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
    @State var search = ""
    
    @State var logTask: SwiftkubeClientTask?
    
    @State var showLogs = false
    @State var showShell = false
    @State var logsLines: [String] = []
    
    var delegate: LogWatcherDelegate {
        LogWatcherCallback(onNext: {
            line in
            logsLines.append(line)
        })
    }
    
    func logs() -> SwiftkubeClientTask? {
        try! viewModel.model.logs(in: .namespace(viewModel.ns), pod: pod, container: container, delegate: delegate)
    }
    
    var body: some View {
        Form {
            Section(header: "Name") {
                Text(container.name)
            }
            Section(header: "Status") {
                Text(container.name)
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
                showLogs = true
                logTask = logs()
            } label: {
                Label("log", systemImage: "doc.text.magnifyingglass")
            }
        }.sheet(isPresented: $showLogs, onDismiss: {
            logTask?.cancel()
        }) {
            SearchBar(text: $search)
                .padding()
            List {
                ForEach(logsLines, id: \.self) {
                    l in
                    if l.contains(search) {
                        Text(l)
                            .foregroundColor(.systemYellow)
                    } else {
                        Text(l)
                    }
                    
                }
            }
        }.sheet(isPresented: $showShell) {
//            WebView(pod: pod, container: container).padding()
        }
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
