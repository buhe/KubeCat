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
    var pods: [Pod] {
        
            if model.pods[ns] == nil {
                do{
                    try model.pod(in: .namespace(ns))
                }catch{
                    model.pods[ns] = []
                }
            }
            if model.hasAndSelectDemo {
                return [
//                    Pod(id: "demo", name: "demo", k8sName: "demo", status: "Running", expect: 2, warning: 1, containers: [Container(id: "demo", name: "demo", image: "docker.io/hello", path: "/foo/bar", policy: "Restart", pullPolicy: "Restart")], clusterIP: "10.0.1.3", nodeIP: "1.2.3.4", labels: [:], annotations: [:], namespace: ns, raw: nil),
//                        Pod(id: "demo2", name: "demo2", k8sName: "demo", status: "Failed", expect: 2, warning: 1, containers: [Container(id: "demo", name: "demo", image: "docker.io/hello", path: "/foo/bar", policy: "Restart", pullPolicy: "Restart")], clusterIP: "10.0.1.3", nodeIP: "1.2.3.4", labels: [:], annotations: [:], namespace: ns, raw: nil),
//                        Pod(id: "demo3", name: "demo3", k8sName: "demo", status: "Pending", expect: 2, warning: 1, containers: [Container(id: "demo", name: "demo", image: "docker.io/hello", path: "/foo/bar", policy: "Restart", pullPolicy: "Restart")], clusterIP: "10.0.1.3", nodeIP: "1.2.3.4", labels: [:], annotations: [:], namespace: ns, raw: nil)
                ]
            }
        return model.pods[ns]!.map {
            let consainersStatus = $0.status?.containerStatuses ?? []
            return Pod(id: $0.name!, name: $0.name!, k8sName: $0.metadata?.labels?["app.kubernetes.io/name"] ?? "unknow", status: ($0.status?.phase)!, expect: $0.spec?.containers.count ?? 0, warning: $0.status?.containerStatuses == nil ? $0.spec?.containers.count ?? 0 : $0.status?.containerStatuses?.filter{$0.ready == false}.count ?? 0, containers: $0.spec?.containers.enumerated().map{
                Container(
                id: $1.name, name: $1.name, image: $1.image!
                ,path: $1.terminationMessagePath ?? "unknow", policy: $1.terminationMessagePolicy ?? "unknow", pullPolicy: $1.imagePullPolicy ?? "unknow"
                , status: consainersStatus[$0].state?.running != nil ? .Running : (consainersStatus[$0].state?.waiting != nil ? .Waiting : .Terminated)
                )
                
            } ?? []
                                              , clusterIP: $0.status?.podIP ?? "unknow Pod IP", nodeIP: $0.status?.hostIP ?? "unknow Node IP"
                                              , labels: $0.metadata?.labels
                                              , annotations: $0.metadata?.annotations
                                              , namespace: $0.metadata?.namespace ?? "unknow"
                       , controllerType: PodControllerType(rawValue: ($0.metadata?.ownerReferences?.first!.kind)!)!
                       , controllerName: ($0.metadata?.ownerReferences?.first!.name)!
                                            , raw: $0
            )}
        
        
    }
    
    var hpas: [Hpa] {
            if model.hpas[ns] == nil {
                do{
                    try model.hpa(in: .namespace(ns))
                }catch{
                    model.hpas[ns] = []
                }
            }
            if model.hasAndSelectDemo {
                return [Hpa(id: "demo", name: "demo", namespace: "demo1", raw: nil)]
            }
            return model.hpas[ns]!.map {Hpa(id: $0.name!, name: $0.name!
                                              , namespace: $0.metadata?.namespace ?? "unknow"
                                            , raw: $0
            )}

        
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
            return [PersistentVolume(id: "demo", name: "demo", labels: [:], annotations: [:], accessModes: "r/w", status: "Bounded", storageClass: "auto", raw: nil)]
        }
        return model.pvs!.map {PersistentVolume(id: $0.name!, name: $0.name!
                                                        , labels: $0.metadata?.labels
                                                        , annotations: $0.metadata?.annotations,
                                                accessModes: $0.spec?.accessModes?.first ?? "unknow",
                                                status: $0.status?.phase ?? "unknow",
                                                storageClass: $0.spec?.storageClassName ?? "unknow"
                                                , raw: $0
                                                        
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
            return [Node(id: "demo1", name: "demo1", hostName: "1.2.3.4", arch: "x86", os: "Linux", labels: [:], annotations: [:], etcd: true, worker: false, controlPlane: true,agent: true, version: "1.2.3"), Node(id: "demo2", name: "demo2", hostName: "5.6.7.8", arch: "x86", os: "Linux", labels: [:], annotations: [:], etcd: true, worker: true, controlPlane: true, agent: false, version: "1.2.3")]
        }
        return model.nodes!.map { Node(id: $0.name!, name: $0.name!, hostName: $0.metadata?.labels!["kubernetes.io/hostname"] ?? "unknow", arch: $0.metadata?.labels!["kubernetes.io/arch"] ?? "unknow", os: ($0.metadata?.labels!["kubernetes.io/os"]!)!
                               , labels: $0.metadata?.labels
                               , annotations: $0.metadata?.annotations,
                               etcd: ($0.metadata?.labels!["node-role.kubernetes.io/etcd"] ?? "false") == "true",
                               worker: ($0.metadata?.labels!["node-role.kubernetes.io/worker"] ?? "false") == "true",
                               controlPlane: ($0.metadata?.labels!["node-role.kubernetes.io/controlplane"] ?? "false") == "true",
                                       agent: ($0.metadata?.labels!["kubernetes.io/role"] ?? "unkown") == "agent",
                               version: $0.status?.nodeInfo?.kubeletVersion ?? "unknow"
        ) }
    }
    var namespaces: [String] {
        if model.hasAndSelectDemo {
            return ["demo1", "demo2"]
        } else {
            return model.namespaces.map { $0.name! }
        }
    }
    var deployment: [Deployment] {
            if model.deployments[ns] == nil {
                do{
                    try model.deployment(in: .namespace(ns))
                }catch{
                    model.deployments[ns] = []
                }
                
            }
            if model.hasAndSelectDemo {
                return [Deployment(id: "demo1", name: "demo1", k8sName: [:], expect: 2, pending: 0, labels: [:], annotations: [:], namespace: "demo1", status: true, raw: nil), Deployment(id: "demo2", name: "demo2", k8sName: [:], expect: 2, pending: 1, labels: [:], annotations: [:], namespace: "demo1", status: false, raw: nil)]
            }
        return model.deployments[ns]!.map {Deployment(id: $0.name!, name: $0.name!, k8sName: ($0.spec?.selector.matchLabels)!, expect: Int($0.spec?.replicas ?? 0), pending: Int($0.status?.unavailableReplicas ?? 0)
                                                            , labels: $0.metadata?.labels
                                                            , annotations: $0.metadata?.annotations
                                                            , namespace: $0.metadata?.namespace ?? "unknow"
                                                            , status: $0.status?.replicas == $0.status?.readyReplicas
                                                          , raw: $0
            )}
    }
    
    var job: [Job] {
    
            if model.jobs[ns] == nil {
                do{
                    try model.job(in: .namespace(ns))
                }catch{
                    model.jobs[ns] = []
                }
                
            }
            if model.hasAndSelectDemo {
                return [Job(id: "demo", name: "demo", k8sName: [:], labels: [:], annotations: [:], namespace: "demo", status: true)]
            }
            return model.jobs[ns]!.map {Job(id: $0.name!, name: $0.name!,
                                            k8sName: ($0.spec?.selector?.matchLabels)!
                                              , labels: $0.metadata?.labels
                                              , annotations: $0.metadata?.annotations
                                              , namespace: $0.metadata?.namespace ?? "unknow"
                                              , status: $0.status?.succeeded != nil
            )}
       
    }
    
    var cronJob: [CronJob] {
        
            if model.cronJobs[ns] == nil {
                do{
                    try model.cronJob(in: .namespace(ns))
                }catch{
                    model.cronJobs[ns] = []
                }
                
            }
            if model.hasAndSelectDemo {
                return [CronJob(id: "demo", name: "demo", k8sName: [:], labels: [:], annotations: [:], namespace: "demo", schedule: "10/5 * * * *", raw: nil)]
            }
            return model.cronJobs[ns]!.map {CronJob(id: $0.name!, name: $0.name!,
                                                    k8sName:  [:]
                                                      , labels: $0.metadata?.labels
                                                      , annotations: $0.metadata?.annotations
                                                      , namespace: $0.metadata?.namespace ?? "unknow"
                                                      , schedule: $0.spec?.schedule ?? "unknow"
                                                    , raw: $0
            )}
    
    }
    
    var statefull: [Stateful] {

            if model.statefulls[ns] == nil {
                do{
                    try model.statefull(in: .namespace(ns))
                }catch{
                    model.statefulls[ns] = []
                }
                
            }
            if model.hasAndSelectDemo {
                return [Stateful(id: "demo", name: "demo", k8sName: [:], labels: [:], annotations: [:], namespace: "demo", status: false, raw: nil)]
            }
        return model.statefulls[ns]!.map {Stateful(id: $0.name!, name: $0.name!, k8sName:  ($0.spec?.selector.matchLabels)!
                                                         , labels: $0.metadata?.labels
                                                         , annotations: $0.metadata?.annotations
                                                         , namespace: $0.metadata?.namespace ?? "unknow"
                                                         , status: $0.status?.readyReplicas == $0.status?.replicas, raw: $0
            )}
        
    }
    
    var service: [Service] {

            if model.services[ns] == nil {
                do{
                    try model.service(in: .namespace(ns))
                }catch{
                    model.services[ns] = []
                }
                
            }
            if model.hasAndSelectDemo {
                return [Service(id: "demo", name: "demo", k8sName: [:], type: "Node", clusterIps: ["10.1.2.3"], externalIps: ["1.2.3.4"], labels: [:], annotations: [:], namespace: "demo")]
            }
        return model.services[ns]!.map {Service(id: $0.name!, name: $0.name!, k8sName:  $0.spec?.selector ?? [:], type: ($0.spec?.type!)!, clusterIps: $0.spec?.clusterIPs, externalIps: $0.spec?.externalIPs
                                                      , labels: $0.metadata?.labels
                                                      , annotations: $0.metadata?.annotations
                                                      , namespace: $0.metadata?.namespace ?? "unknow"
            )}
    }
    
    var configMap: [ConfigMap] {
            if model.configMaps[ns] == nil {
                do{
                    try model.configMap(in: .namespace(ns))
                }catch{
                    model.configMaps[ns] = []
                }
                
            }
            if model.hasAndSelectDemo {
                return [ConfigMap(id: "demo", name: "demo", labels: [:], annotations: [:], namespace: "demo", data: ["demo": "abc=123"])]
            }
            return model.configMaps[ns]!.map {ConfigMap(id: $0.name!, name: $0.name!
                                                          , labels: $0.metadata?.labels
                                                          , annotations: $0.metadata?.annotations
                                                          , namespace: $0.metadata?.namespace ?? "unknow"
                                                          , data: $0.data
            )}
       
    }
    
    var secret: [Secret] {
            if model.secrets[ns] == nil {
                do{
                    try model.secret(in: .namespace(ns))
                }catch{
                    model.secrets[ns] = []
                }
                
            }
            if model.hasAndSelectDemo {
                return [Secret(id: "demo", name: "demo", labels: [:], annotations: [:], namespace: "demo", data: ["demo": "qwertyuiop"])]
            }
            return model.secrets[ns]!.map {Secret(id: $0.name!, name: $0.name!
                                                    , labels: $0.metadata?.labels
                                                    , annotations: $0.metadata?.annotations
                                                    , namespace: $0.metadata?.namespace ?? "unknow"
                                                    , data: $0.data
            )}
    }
    
    var daemon: [Daemon] {
            if model.daemons[ns] == nil {
                do{
                    try model.daemon(in: .namespace(ns))
                }catch{
                    model.daemons[ns] = []
                }
                
            }
            if model.hasAndSelectDemo {
                return [Daemon(id: "demo", name: "demo", k8sName: [:], labels: [:], annotations: [:], namespace: "demo", status: true, raw: nil)]
            }
        return model.daemons[ns]!.map {Daemon(id: $0.name!, name: $0.name!, k8sName:  ($0.spec?.selector.matchLabels)!
                                                    , labels: $0.metadata?.labels
                                                    , annotations: $0.metadata?.annotations
                                                    , namespace: $0.metadata?.namespace ?? "unknow"
                                                  , status: !($0.status?.numberMisscheduled ?? 0 > 0)
                                                  , raw: $0
            )}
    }
    
    var replica: [Replica] {
        
            if model.replicas[ns] == nil {
                do{
                    try model.replica(in: .namespace(ns))
                }catch{
                    model.replicas[ns] = []
                }
                
            }
            if model.hasAndSelectDemo {
                return [Replica(id: "demo", name: "demo", k8sName: [:], labels: [:], annotations: [:], namespace: "demo", status: true)]
            }
        return model.replicas[ns]!.map {Replica(id: $0.name!, name: $0.name!, k8sName:  ($0.spec?.selector.matchLabels)!
                                                      , labels: $0.metadata?.labels
                                                      , annotations: $0.metadata?.annotations
                                                      , namespace: $0.metadata?.namespace ?? "unknow"
                                                      , status: $0.status?.replicas == $0.status?.readyReplicas
            )}
    }
    
}


