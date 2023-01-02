//
//  ViewModel.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/21.
//

import Foundation
import SwiftkubeClient
import CoreData

class ViewModel: ObservableObject {
    
    @Published var model: Model
    @Published var ns: String = "default"
    init(viewContext: NSManagedObjectContext) {
        model = Model(viewContext: viewContext)
            
    }
    func pods(in ns: NamespaceSelector) -> [Pod] {
        switch ns {
        case .namespace(let name):
            if model.pods[name] == nil {
                do{
                    try model.pod(in: ns)
                }catch{
                    model.pods[name] = []
                }
            }
            if model.hasAndSelectDemo {
                return [Pod(id: "demo", name: "demo", k8sName: "demo", status: "Running", expect: 2, pending: 1, containers: [], clusterIP: "10.0.1.3", nodeIP: "1.2.3.4", labels: [:], annotations: [:], namespace: name)]
            }
            return model.pods[name]!.map {Pod(id: $0.name!, name: $0.name!, k8sName: $0.metadata?.labels!["app.kubernetes.io/name"] ?? "unknow", status: ($0.status?.phase)!, expect: $0.spec?.containers.count ?? 0, pending: $0.status?.containerStatuses?.filter{$0.ready == false}.count ?? 0, containers: ($0.spec?.containers.map{Container(
                id: $0.name, name: $0.name, image: $0.image!
                ,path: $0.terminationMessagePath!, policy: $0.terminationMessagePolicy!, pullPolicy: $0.imagePullPolicy!
                )})!
                                              , clusterIP: $0.status?.podIP ?? "unknow Pod IP", nodeIP: $0.status?.hostIP ?? "unknow Node IP"
                                              , labels: $0.metadata?.labels
                                              , annotations: $0.metadata?.annotations
                                              , namespace: ($0.metadata?.namespace)!
            )}
        default: return []
        }
        
    }
    
    func hpas(in ns: NamespaceSelector) -> [Hpa] {
        switch ns {
        case .namespace(let name):
            if model.hpas[name] == nil {
                do{
                    try model.hpa(in: ns)
                }catch{
                    model.hpas[name] = []
                }
            }
            if model.hasAndSelectDemo {
                return [Hpa(id: "demo", name: "demo", namespace: "demo1")]
            }
            return model.hpas[name]!.map {Hpa(id: $0.name!, name: $0.name!
                                              , namespace: ($0.metadata?.namespace)!
            )}
        default: return []
        }
        
    }
    
    var pv: [PersistentVolume] {

        if model.pvs == nil {
            do{
                try model.pv()
            }catch{
                model.pvs = []
            }
            
        }
        if model.hasAndSelectDemo {
            return [PersistentVolume(id: "demo", name: "demo", labels: [:], annotations: [:], accessModes: "r/w", status: "Bounded", storageClass: "auto")]
        }
        return model.pvs!.map {PersistentVolume(id: $0.name!, name: $0.name!
                                                        , labels: $0.metadata?.labels
                                                        , annotations: $0.metadata?.annotations,
                                                accessModes: ($0.spec?.accessModes?.first)!,
                                                status: ($0.status?.phase)!,
                                                storageClass: ($0.spec?.storageClassName)!
                                                        
        )}

    }
    var pvc: [PersistentVolumeClaim] {
        if model.pvcs == nil {
            do{
                try model.pvc()
            } catch{
                model.pvcs = []
            }
            
        }
        if model.hasAndSelectDemo {
            return [PersistentVolumeClaim(id: "demo", name: "demo")]
        }
        return model.pvcs!.map {PersistentVolumeClaim(id: $0.name!, name: $0.name!
                                                        
                                                        
        )}
        
    }
    var nodes: [Node] {
        if model.nodes == nil {
            do{
                try model.node()
            }catch{
                model.nodes = []
            }
            
        }
        if model.hasAndSelectDemo {
            return [Node(id: "demo1", name: "demo1", hostName: "1.2.3.4", arch: "x86", os: "Linux", labels: [:], annotations: [:], etcd: true, worker: false, controlPlane: true, version: "1.2.3"), Node(id: "demo2", name: "demo2", hostName: "5.6.7.8", arch: "x86", os: "Linux", labels: [:], annotations: [:], etcd: true, worker: true, controlPlane: true, version: "1.2.3")]
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
        if model.hasAndSelectDemo {
            return ["demo1", "demo2"]
        } else {
            return model.namespaces.map { $0.name! }
        }
    }
    func deployment(in ns: NamespaceSelector) -> [Deployment] {
        switch ns {
        case .namespace(let name):
            if model.deployments[name] == nil {
                do{
                    try model.deployment(in: ns)
                }catch{
                    model.deployments[name] = []
                }
                
            }
            if model.hasAndSelectDemo {
                return [Deployment(id: "demo1", name: "demo1", k8sName: "demo1", expect: 2, pending: 0, labels: [:], annotations: [:], namespace: "demo1", status: true), Deployment(id: "demo2", name: "demo2", k8sName: "demo2", expect: 2, pending: 1, labels: [:], annotations: [:], namespace: "demo1", status: false)]
            }
            return model.deployments[name]!.map {Deployment(id: $0.name!, name: $0.name!, k8sName: $0.metadata?.labels!["app.kubernetes.io/name"] ?? "unknow", expect: Int($0.spec?.replicas ?? 0), pending: Int($0.status?.unavailableReplicas ?? 0)
                                                            , labels: $0.metadata?.labels
                                                            , annotations: $0.metadata?.annotations
                                                            , namespace: ($0.metadata?.namespace)!
                                                            , status: $0.status?.replicas == $0.status?.readyReplicas
            )}
        default: return []
        }
    }
    
    func job(in ns: NamespaceSelector) -> [Job] {
        switch ns {
        case .namespace(let name):
            if model.jobs[name] == nil {
                do{
                    try model.job(in: ns)
                }catch{
                    model.jobs[name] = []
                }
                
            }
            if model.hasAndSelectDemo {
                return [Job(id: "demo", name: "demo", k8sName: "demo", labels: [:], annotations: [:], namespace: "demo", status: true)]
            }
            return model.jobs[name]!.map {Job(id: $0.name!, name: $0.name!,
                                              k8sName: $0.metadata!.labels!["job-name"] ?? "unknow"
                                              , labels: $0.metadata?.labels
                                              , annotations: $0.metadata?.annotations
                                              , namespace: ($0.metadata?.namespace)!
                                              , status: $0.status?.succeeded != nil
            )}
        default: return []
        }
    }
    
    func cronJob(in ns: NamespaceSelector) -> [CronJob] {
        switch ns {
        case .namespace(let name):
            if model.cronJobs[name] == nil {
                do{
                    try model.cronJob(in: ns)
                }catch{
                    model.cronJobs[name] = []
                }
                
            }
            if model.hasAndSelectDemo {
                return [CronJob(id: "demo", name: "demo", k8sName: "demo", labels: [:], annotations: [:], namespace: "demo", schedule: "10/5 * * * *")]
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
                do{
                    try model.statefull(in: ns)
                }catch{
                    model.statefulls[name] = []
                }
                
            }
            if model.hasAndSelectDemo {
                return [Stateful(id: "demo", name: "demo", k8sName: "demo", labels: [:], annotations: [:], namespace: "demo", status: false)]
            }
            return model.statefulls[name]!.map {Stateful(id: $0.name!, name: $0.name!, k8sName: ($0.metadata?.labels!["app.kubernetes.io/name"]!)!
                                                         , labels: $0.metadata?.labels
                                                         , annotations: $0.metadata?.annotations
                                                         , namespace: ($0.metadata?.namespace)!
                                                         , status: $0.status?.readyReplicas == $0.status?.replicas
            )}
        default: return []
        }
    }
    
    func service(in ns: NamespaceSelector) -> [Service] {
        switch ns {
        case .namespace(let name):
            if model.services[name] == nil {
                do{
                    try model.service(in: ns)
                }catch{
                    model.services[name] = []
                }
                
            }
            if model.hasAndSelectDemo {
                return [Service(id: "demo", name: "demo", k8sName: "demo", type: "Node", clusterIps: ["10.1.2.3"], externalIps: ["1.2.3.4"], labels: [:], annotations: [:], namespace: "demo")]
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
                do{
                    try model.configMap(in: ns)
                }catch{
                    model.configMaps[name] = []
                }
                
            }
            if model.hasAndSelectDemo {
                return [ConfigMap(id: "demo", name: "demo", labels: [:], annotations: [:], namespace: "demo", data: ["demo": "abc=123"])]
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
                do{
                    try model.secret(in: ns)
                }catch{
                    model.secrets[name] = []
                }
                
            }
            if model.hasAndSelectDemo {
                return [Secret(id: "demo", name: "demo", labels: [:], annotations: [:], namespace: "demo", data: ["demo": "qwertyuiop"])]
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
                do{
                    try model.daemon(in: ns)
                }catch{
                    model.daemons[name] = []
                }
                
            }
            if model.hasAndSelectDemo {
                return [Daemon(id: "demo", name: "demo", k8sName: "demo", labels: [:], annotations: [:], namespace: "demo", status: true)]
            }
            return model.daemons[name]!.map {Daemon(id: $0.name!, name: $0.name!, k8sName: $0.metadata?.labels!["app.kubernetes.io/name"] ?? "unknow"
                                                    , labels: $0.metadata?.labels
                                                    , annotations: $0.metadata?.annotations
                                                    , namespace: ($0.metadata?.namespace)!
                                                    , status: $0.status!.numberMisscheduled <= 0
            )}
        default: return []
        }
    }
    
    func replica(in ns: NamespaceSelector) -> [Replica] {
        switch ns {
        case .namespace(let name):
            if model.replicas[name] == nil {
                do{
                    try model.replica(in: ns)
                }catch{
                    model.replicas[name] = []
                }
                
            }
            if model.hasAndSelectDemo {
                return [Replica(id: "demo", name: "demo", k8sName: "demo", labels: [:], annotations: [:], namespace: "demo", status: true)]
            }
            return model.replicas[name]!.map {Replica(id: $0.name!, name: $0.name!, k8sName: $0.metadata?.labels!["app.kubernetes.io/name"] ?? "unknow"
                                                      , labels: $0.metadata?.labels
                                                      , annotations: $0.metadata?.annotations
                                                      , namespace: ($0.metadata?.namespace)!
                                                      , status: $0.status?.replicas == $0.status?.readyReplicas
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


