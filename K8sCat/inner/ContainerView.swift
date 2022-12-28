//
//  ContainerView.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/26.
//

import SwiftUI
import SwiftkubeClient
import SwiftkubeModel

struct ContainerView: View {
    let pod: Pod
    let container: Container
    let viewModel: ViewModel
    
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
    
    func logs() -> SwiftkubeClientTask {
        try! viewModel.model.logs(in: .namespace(viewModel.ns), pod: pod, container: container, delegate: delegate)
    }
    
    var body: some View {
        Form {
            
        }.toolbar {
            Button {
                showShell = true
            } label: {
                Label("shell", systemImage: "terminal")
            }
            
            Button {
                showLogs = true
                logTask = logs()
            } label: {
                Label("log", systemImage: "doc.text.magnifyingglass")
            }
        }.sheet(isPresented: $showLogs, onDismiss: {
            logTask?.cancel()
        }) {
            List {
                ForEach(logsLines, id: \.self) {
                    l in
                    Text(l)
                }
            }
        }.sheet(isPresented: $showShell) {
            WebView(pod: pod, container: container).padding()
        }
    }
}

//struct ContainerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContainerView()
//    }
//}
