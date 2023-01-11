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
            return Daemon(id: daemon.name!, name: daemon.name!, k8sName:  (daemon.spec?.selector.matchLabels)!
                          , labels: daemon.metadata?.labels
                          , annotations: daemon.metadata?.annotations
                          , namespace: daemon.metadata?.namespace ?? "unknow"
                        , status: !(daemon.status?.numberMisscheduled ?? 0 > 0)
                        , raw: daemon
)
        } else {
            return Daemon(id: "demo", name: "demo", k8sName: [:], labels: [:], annotations: [:], namespace: "demo", status: true, raw: nil)
        }
    }
    
    func replicaByName(ns: String, name: String) -> Replica {
        if let client = client {
            let replica = try! client.appsV1.replicaSets.get(in: .namespace(ns), name: name).wait()
            return Replica(id: replica.name!, name: replica.name!, k8sName:  (replica.spec?.selector.matchLabels)!
                           , labels: replica.metadata?.labels
                           , annotations: replica.metadata?.annotations
                           , namespace: replica.metadata?.namespace ?? "unknow"
                           , status: replica.status?.replicas == replica.status?.readyReplicas
)
        } else {
            return Replica(id: "demo", name: "demo", k8sName: [:], labels: [:], annotations: [:], namespace: "demo", status: true)
        }
    }
}
