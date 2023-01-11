//
//  Model+Name.swift
//  K8sCat
//
//  Created by 顾艳华 on 2023/1/11.
//

import Foundation
import SwiftkubeModel

extension Model {
    func daemonByName(ns: String, name: String) -> Daemon {
        if let client = client {
            let daemon = try! client.appsV1.daemonSets.get(in: .namespace(ns), name: name).wait()
            return Daemon(id: daemon.name!, name: daemon.name!, k8sName: daemon.metadata?.labels!["app.kubernetes.io/name"] ?? "unknow"
                          , labels: daemon.metadata?.labels
                          , annotations: daemon.metadata?.annotations
                          , namespace: daemon.metadata?.namespace ?? "unknow"
                        , status: !(daemon.status?.numberMisscheduled ?? 0 > 0)
                        , raw: daemon
)
        } else {
            return Daemon(id: "demo", name: "demo", k8sName: "demo", labels: [:], annotations: [:], namespace: "demo", status: true, raw: nil)
        }
    }
}
