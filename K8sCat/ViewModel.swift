//
//  ViewModel.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/21.
//

import Foundation
import SwiftkubeClient

class ViewModel: ObservableObject {
    @Published var model = Model()
    @Published var ns: String = "default"
    func pods(in ns: NamespaceSelector) -> [Pod] {
        switch ns {
        case .namespace(let name):
            if model.pods[name] == nil {
                try! model.pod(in: ns)
            }
            return model.pods[name]!.map {Pod(id: $0.name!, name: $0.name!, k8sName: $0.metadata?.labels!["app.kubernetes.io/name"] ?? "unknow", status: ($0.status?.phase)!, expect: $0.spec?.containers.count ?? 0, pending: $0.status?.containerStatuses?.filter{$0.ready == false}.count ?? 0, containers: ($0.spec?.containers.map{Container(
                id: $0.name, name: $0.name, image: $0.image!
                ,path: $0.terminationMessagePath!, policy: $0.terminationMessagePolicy!, pullPolicy: $0.imagePullPolicy!
                )})!
                                              , clusterIP: ($0.status?.podIP)!, nodeIP: ($0.status?.hostIP)!
                                              , labels: $0.metadata?.labels
                                              , annotations: $0.metadata?.annotations
                                              , namespace: ($0.metadata?.namespace)!
            )}
        default: return []
        }
        
    }
    var pv: [PersistentVolume] {

            if model.pvs == nil {
                try! model.pv()
            }
            return model.pvs!.map {PersistentVolume(id: $0.name!, name: $0.name!
                                                            , labels: $0.metadata?.labels
                                                            , annotations: $0.metadata?.annotations
                                                            
            )}

    }
    var pvc: [PersistentVolumeClaim] {

            if model.pvcs == nil {
                try! model.pvc()
            }
            return model.pvcs!.map {PersistentVolumeClaim(id: $0.name!, name: $0.name!
                                                            , labels: $0.metadata?.labels
                                                            , annotations: $0.metadata?.annotations
                                                            
            )}
        
    }
    var nodes: [Node] {
        if model.nodes == nil {
            try! model.node()
        }
        return model.nodes!.map { Node(id: $0.name!, name: $0.name!, hostName: ($0.metadata?.labels!["kubernetes.io/hostname"]!)!, arch: ($0.metadata?.labels!["kubernetes.io/arch"]!)!, os: ($0.metadata?.labels!["kubernetes.io/os"]!)!
                               , labels: $0.metadata?.labels
                               , annotations: $0.metadata?.annotations,
                               etcd: ($0.metadata?.labels!["node-role.kubernetes.io/etcd"] ?? "false") == "true",
                               worker: ($0.metadata?.labels!["node-role.kubernetes.io/worker"] ?? "false") == "true",
                               controlPlane: ($0.metadata?.labels!["node-role.kubernetes.io/controlplane"] ?? "false") == "true",
                               version: ($0.status?.nodeInfo!.kubeletVersion)!
        ) }
    }
    var namespaces: [String] {
        model.namespaces.map { $0.name! }
    }
    func deployment(in ns: NamespaceSelector) -> [Deployment] {
        switch ns {
        case .namespace(let name):
            if model.deployments[name] == nil {
                try! model.deployment(in: ns)
            }
            return model.deployments[name]!.map {Deployment(id: $0.name!, name: $0.name!, k8sName: $0.metadata?.labels!["app.kubernetes.io/name"] ?? "unknow", expect: Int($0.spec?.replicas ?? 0), pending: Int($0.status?.unavailableReplicas ?? 0)
                                                            , labels: $0.metadata?.labels
                                                            , annotations: $0.metadata?.annotations
                                                            , namespace: ($0.metadata?.namespace)!
            )}
        default: return []
        }
    }
    
    func job(in ns: NamespaceSelector) -> [Job] {
        switch ns {
        case .namespace(let name):
            if model.jobs[name] == nil {
                try! model.job(in: ns)
            }
            return model.jobs[name]!.map {Job(id: $0.name!, name: $0.name!,
                                              k8sName: $0.metadata!.labels!["job-name"] ?? "unknow"
                                              , labels: $0.metadata?.labels
                                              , annotations: $0.metadata?.annotations
                                              , namespace: ($0.metadata?.namespace)!
            )}
        default: return []
        }
    }
    
    func cronJob(in ns: NamespaceSelector) -> [CronJob] {
        switch ns {
        case .namespace(let name):
            if model.cronJobs[name] == nil {
                try! model.cronJob(in: ns)
            }
            return model.cronJobs[name]!.map {CronJob(id: $0.name!, name: $0.name!,
                                                      k8sName: $0.metadata?.labels?["job-name"] ?? "unknow"
                                                      , labels: $0.metadata?.labels
                                                      , annotations: $0.metadata?.annotations
                                                      , namespace: ($0.metadata?.namespace)!
                                                      , schedule: $0.spec!.schedule
            )}
        default: return []
        }
    }
    
    func statefull(in ns: NamespaceSelector) -> [Stateful] {
        switch ns {
        case .namespace(let name):
            if model.statefulls[name] == nil {
                try! model.statefull(in: ns)
            }
            return model.statefulls[name]!.map {Stateful(id: $0.name!, name: $0.name!, k8sName: ($0.metadata?.labels!["app.kubernetes.io/name"]!)!
                                                         , labels: $0.metadata?.labels
                                                         , annotations: $0.metadata?.annotations
                                                         , namespace: ($0.metadata?.namespace)!
            )}
        default: return []
        }
    }
    
    func service(in ns: NamespaceSelector) -> [Service] {
        switch ns {
        case .namespace(let name):
            if model.services[name] == nil {
                try! model.service(in: ns)
            }
            return model.services[name]!.map {Service(id: $0.name!, name: $0.name!, k8sName: $0.metadata?.labels!["app.kubernetes.io/name"] ?? "unknow", type: ($0.spec?.type!)!, clusterIps: $0.spec?.clusterIPs, externalIps: $0.spec?.externalIPs
                                                      , labels: $0.metadata?.labels
                                                      , annotations: $0.metadata?.annotations
                                                      , namespace: ($0.metadata?.namespace)!
            )}
        default: return []
        }
    }
    
    func configMap(in ns: NamespaceSelector) -> [ConfigMap] {
        switch ns {
        case .namespace(let name):
            if model.configMaps[name] == nil {
                try! model.configMap(in: ns)
            }
            return model.configMaps[name]!.map {ConfigMap(id: $0.name!, name: $0.name!
                                                          , labels: $0.metadata?.labels
                                                          , annotations: $0.metadata?.annotations
                                                          , namespace: ($0.metadata?.namespace)!
                                                          , data: $0.data
            )}
        default: return []
        }
    }
    
    func secret(in ns: NamespaceSelector) -> [Secret] {
        switch ns {
        case .namespace(let name):
            if model.secrets[name] == nil {
                try! model.secret(in: ns)
            }
            return model.secrets[name]!.map {Secret(id: $0.name!, name: $0.name!
                                                    , labels: $0.metadata?.labels
                                                    , annotations: $0.metadata?.annotations
                                                    , namespace: ($0.metadata?.namespace)!
                                                    , data: $0.data
            )}
        default: return []
        }
    }
    
    func daemon(in ns: NamespaceSelector) -> [Daemon] {
        switch ns {
        case .namespace(let name):
            if model.daemons[name] == nil {
                try! model.daemon(in: ns)
            }
            return model.daemons[name]!.map {Daemon(id: $0.name!, name: $0.name!, k8sName: ($0.metadata?.labels!["app.kubernetes.io/name"]!)!
                                                    , labels: $0.metadata?.labels
                                                    , annotations: $0.metadata?.annotations
                                                    , namespace: ($0.metadata?.namespace)!
            )}
        default: return []
        }
    }
    
    func replica(in ns: NamespaceSelector) -> [Replica] {
        switch ns {
        case .namespace(let name):
            if model.replicas[name] == nil {
                try! model.replica(in: ns)
            }
            return model.replicas[name]!.map {Replica(id: $0.name!, name: $0.name!, k8sName: $0.metadata?.labels!["app.kubernetes.io/name"] ?? "unknow"
                                                      , labels: $0.metadata?.labels
                                                      , annotations: $0.metadata?.annotations
                                                      , namespace: ($0.metadata?.namespace)!
            )}
        default: return []
        }
    }
    
//    func replication(in ns: NamespaceSelector) -> [Replication] {
//        switch ns {
//        case .namespace(let name):
//            if model.replications[name] == nil {
//                try! model.replication(in: ns)
//            }
//            return model.replications[name]!.map {Replication(id: $0.name!, name: $0.name!)}
//        default: return []
//        }
//    }
    
    func podsSelector(in ns: NamespaceSelector) throws {
        try model.pod(in: ns)
    }
}

struct Pod: Identifiable {
    var id: String
    var name: String
    let k8sName: String
    let status: String
    let expect: Int
    let pending: Int
    let containers: [Container]
    let clusterIP: String
    let nodeIP: String
    let labels: [String: String]?
    let annotations: [String: String]?
    let namespace: String
}

struct Container: Identifiable {
    var id: String
    var name: String
    let image: String
    
    let path: String
    let policy: String
    
    let pullPolicy: String
}

struct Deployment: Identifiable {
    var id: String
    var name: String
    let k8sName: String
//    let status: String
    let expect: Int
    let pending: Int
    let labels: [String: String]?
    let annotations: [String: String]?
    let namespace: String
}

struct PersistentVolume: Identifiable {
    var id: String
    var name: String
    let labels: [String: String]?
    let annotations: [String: String]?
    
}

struct PersistentVolumeClaim: Identifiable {
    var id: String
    var name: String
    let labels: [String: String]?
    let annotations: [String: String]?
}

struct Job: Identifiable {
    var id: String
    var name: String
    let k8sName: String
    let labels: [String: String]?
    let annotations: [String: String]?
    let namespace: String
}

struct CronJob: Identifiable {
    var id: String
    var name: String
    let k8sName: String
    let labels: [String: String]?
    let annotations: [String: String]?
    let namespace: String
    let schedule: String
}

struct Stateful: Identifiable {
    var id: String
    var name: String
    let k8sName: String
    let labels: [String: String]?
    let annotations: [String: String]?
    let namespace: String
}

struct Service: Identifiable {
    var id: String
    var name: String
    let k8sName: String
    let type: String
    let clusterIps: [String]?
    let externalIps: [String]?
    let labels: [String: String]?
    let annotations: [String: String]?
    let namespace: String
//    let ports: Int
}

struct ConfigMap: Identifiable {
    var id: String
    var name: String
    let labels: [String: String]?
    let annotations: [String: String]?
    let namespace: String
    let data: [String: String]?
}

struct Secret: Identifiable {
    var id: String
    var name: String
    let labels: [String: String]?
    let annotations: [String: String]?
    let namespace: String
    let data: [String: String]?
}

struct Daemon: Identifiable {
    var id: String
    var name: String
    let k8sName: String
    let labels: [String: String]?
    let annotations: [String: String]?
    let namespace: String
}

struct Replica: Identifiable {
    var id: String
    var name: String
    var k8sName: String
    let labels: [String: String]?
    let annotations: [String: String]?
    let namespace: String
}

//struct Replication: Identifiable {
//    var id: String
//    var name: String
//}
struct Node: Identifiable {
    var id: String
    var name: String
    var hostName: String
    var arch: String
    var os: String
    
    let labels: [String: String]?
    let annotations: [String: String]?
    
    let etcd: Bool
    let worker: Bool
    let controlPlane: Bool
    var version: String
//    var age: String
}
