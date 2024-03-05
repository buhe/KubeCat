//
//  LogView.swift
//  K8sCat
//
//  Created by 顾艳华 on 3/4/24.
//

import SwiftUI
import SwiftkubeClient
import SwiftkubeModel
import SwiftUIX

struct LogView: View {
    var logTask: SwiftkubeClientTask<String>?
    @State var search = ""
    @State var logsLines: [String] = []
    
    init(logTask: SwiftkubeClientTask<String>?) {
        self.logTask = logTask
    }
    var body: some View {
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
        .onAppear {
            Task {
                if let logTask = logTask {
                    for try await line in logTask.start() {
//                        print(line)
                        DispatchQueue.main.async {
                            logsLines.append(line)
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    LogView()
//}
