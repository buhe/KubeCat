//
//  Model+Pod.swift
//  K8sCat
//
//  Created by 顾艳华 on 2023/1/11.
//

import Foundation
import SwiftkubeModel
import SwiftkubeClient

extension Model {
    
    mutating func podsByJob(in ns: NamespaceSelector, job: [String: String]) async -> [Pod] {
        checkAWSToken()
        if let client = client, !job.isEmpty {
            let pods = try? await client.pods.list(in: ns,options: [.labelSelector(.eq(job))]).get().items
            return (pods ?? []).map {
               let consainersStatus = $0.status?.containerStatuses ?? []
               return Pod(id: $0.name ?? "", name: $0.name ?? "",k8sName: "", status: $0.status?.phase ?? "unknow", expect: $0.spec?.containers.count ?? 0, error: $0.status?.containerStatuses == nil ? $0.spec?.containers.count ?? 0 : $0.status?.containerStatuses?.filter{$0.started == false}.count ?? 0,notReady: $0.status?.containerStatuses == nil ? ($0.spec?.containers.count ?? 0) : $0.status?.containerStatuses?.filter{$0.ready == false}.count ?? 0, containers: $0.spec?.containers.enumerated().map{
                   Container(
                   id: $1.name, name: $1.name, image: $1.image ?? ""
                   ,path: $1.terminationMessagePath ?? "unknow", policy: $1.terminationMessagePolicy ?? "unknow", pullPolicy: $1.imagePullPolicy ?? "unknow"
                   , status: consainersStatus[$0].state?.running != nil ? .Running : (consainersStatus[$0].state?.waiting != nil ? .Waiting : .Terminated)
                   , ready: consainersStatus[$0].ready
                   , error: consainersStatus[$0].state?.terminated != nil && consainersStatus[$0].state?.terminated?.exitCode != 0
                   )
                   
               } ?? [], clusterIP: $0.status?.podIP ?? "unknow", nodeIP: $0.status?.hostIP ?? "unknow", labels: $0.metadata?.labels
                                                                                                                         , annotations: $0.metadata?.annotations, namespace: $0.metadata?.namespace ?? "unknow"
                                                                                                           , controllerType: .Job   , controllerName: ($0.metadata?.ownerReferences?.first?.name) ?? ""
           ,raw: $0
           )}
        } else {
            return []
        }
        
    }
    
    
    mutating func podsByDeployment(in ns: NamespaceSelector, deployment: [String: String]) async -> [Pod] {
        checkAWSToken()
        if let client = client, !deployment.isEmpty {
            let pods = try? await client.pods.list(in: ns,options: [.labelSelector(.eq(deployment))]).get().items
            return (pods ?? []).map {
                let consainersStatus = $0.status?.containerStatuses ?? []
                return Pod(id: $0.name ?? "", name: $0.name ?? "",k8sName: "", status: ($0.status?.phase) ?? "", expect: $0.spec?.containers.count ?? 0, error: $0.status?.containerStatuses == nil ? $0.spec?.containers.count ?? 0 : $0.status?.containerStatuses?.filter{$0.started == false}.count ?? 0,notReady: $0.status?.containerStatuses == nil ? ($0.spec?.containers.count ?? 0) : $0.status?.containerStatuses?.filter{$0.ready == false}.count ?? 0, containers: $0.spec?.containers.enumerated().map{
                Container(
                id: $1.name, name: $1.name, image: $1.image ?? ""
                ,path: $1.terminationMessagePath ?? "unknow", policy: $1.terminationMessagePolicy ?? "unknow", pullPolicy: $1.imagePullPolicy ?? "unknow"
                , status: consainersStatus[$0].state?.running != nil ? .Running : (consainersStatus[$0].state?.waiting != nil ? .Waiting : .Terminated)
                , ready: consainersStatus[$0].ready
                , error: consainersStatus[$0].state?.terminated != nil && consainersStatus[$0].state?.terminated?.exitCode != 0
                )
                
            } ?? [], clusterIP: $0.status?.podIP ?? "unknow", nodeIP: $0.status?.hostIP ?? "unknow", labels: $0.metadata?.labels
                                                                                                                   , annotations: $0.metadata?.annotations, namespace: $0.metadata?.namespace ?? "unknow", controllerType: .ReplicaSet   , controllerName: ($0.metadata?.ownerReferences?.first?.name) ?? "", raw: $0)}
        } else {
            return []
        }
        
    }
    
    mutating func podsByReplica(in ns: NamespaceSelector, replica: [String: String]) async -> [Pod] {
        checkAWSToken()
        if let client = client, !replica.isEmpty {
            return ((try? await client.pods.list(in: ns,options: [.labelSelector(.eq(replica))]).get().items) ?? []).map {
                let consainersStatus = $0.status?.containerStatuses ?? []
                return Pod(id: $0.name ?? "", name: $0.name ?? "", k8sName: "",status: ($0.status?.phase) ?? "", expect: $0.spec?.containers.count ?? 0, error: $0.status?.containerStatuses == nil ? $0.spec?.containers.count ?? 0 : $0.status?.containerStatuses?.filter{$0.started == false}.count ?? 0, notReady: $0.status?.containerStatuses == nil ? ($0.spec?.containers.count ?? 0) : $0.status?.containerStatuses?.filter{$0.ready == false}.count ?? 0,containers: $0.spec?.containers.enumerated().map{
                Container(
                id: $1.name, name: $1.name, image: $1.image ?? ""
                ,path: $1.terminationMessagePath ?? "unknow", policy: $1.terminationMessagePolicy ?? "unknow", pullPolicy: $1.imagePullPolicy ?? "unknow"
                , status: consainersStatus[$0].state?.running != nil ? .Running : (consainersStatus[$0].state?.waiting != nil ? .Waiting : .Terminated)
                , ready: consainersStatus[$0].ready
                , error: consainersStatus[$0].state?.terminated != nil && consainersStatus[$0].state?.terminated?.exitCode != 0
                )
                
            } ?? [], clusterIP: $0.status?.podIP ?? "unknow", nodeIP: $0.status?.hostIP ?? "unknow", labels: $0.metadata?.labels
                                                                                                                , annotations: $0.metadata?.annotations, namespace: $0.metadata?.namespace ?? "unknow", controllerType: .ReplicaSet   , controllerName: ($0.metadata?.ownerReferences?.first?.name) ?? "", raw: $0)}
        } else {
            return []
        }
        
    }
    
    mutating func podsByDaemon(in ns: NamespaceSelector, daemon: [String: String]) async -> [Pod] {
        checkAWSToken()
        if let client = client, !daemon.isEmpty {
            return ((try? await client.pods.list(in: ns,options: [.labelSelector(.eq(daemon))]).get().items) ?? []).map {
                let consainersStatus = $0.status?.containerStatuses ?? []
                return Pod(id: $0.name ?? "", name: $0.name ?? "", k8sName: "",status: ($0.status?.phase) ?? "", expect: $0.spec?.containers.count ?? 0, error: $0.status?.containerStatuses == nil ? $0.spec?.containers.count ?? 0 : $0.status?.containerStatuses?.filter{$0.started == false}.count ?? 0,notReady: $0.status?.containerStatuses == nil ? ($0.spec?.containers.count ?? 0) : $0.status?.containerStatuses?.filter{$0.ready == false}.count ?? 0, containers:$0.spec?.containers.enumerated().map{
                Container(
                id: $1.name, name: $1.name, image: $1.image ?? ""
                ,path: $1.terminationMessagePath ?? "unknow", policy: $1.terminationMessagePolicy ?? "unknow", pullPolicy: $1.imagePullPolicy ?? "unknow"
                , status: consainersStatus[$0].state?.running != nil ? .Running : (consainersStatus[$0].state?.waiting != nil ? .Waiting : .Terminated)
                , ready: consainersStatus[$0].ready
                , error: consainersStatus[$0].state?.terminated != nil && consainersStatus[$0].state?.terminated?.exitCode != 0
                )
                
            } ?? [], clusterIP: $0.status?.podIP ?? "unknow", nodeIP: $0.status?.hostIP ?? "unknow", labels: $0.metadata?.labels
                                                                                                               , annotations: $0.metadata?.annotations, namespace: $0.metadata?.namespace ?? "unknow", controllerType: .DaemonSet   , controllerName: ($0.metadata?.ownerReferences?.first?.name) ?? "" ,raw: $0)}
        } else {
            return []
        }
        
    }
    
    mutating func podsByService(in ns: NamespaceSelector, service: [String: String]) async -> [Pod] {
        checkAWSToken()
        if let client = client, !service.isEmpty {
            return ((try? await client.pods.list(in: ns,options: [.labelSelector(.eq(service))]).get().items) ?? []).map {
                let consainersStatus = $0.status?.containerStatuses ?? []
                return Pod(id: $0.name ?? "", name: $0.name ?? "", k8sName: "",status: ($0.status?.phase) ?? "", expect: $0.spec?.containers.count ?? 0, error: $0.status?.containerStatuses == nil ? $0.spec?.containers.count ?? 0 : $0.status?.containerStatuses?.filter{$0.started == false}.count ?? 0, notReady: $0.status?.containerStatuses == nil ? ($0.spec?.containers.count ?? 0) : $0.status?.containerStatuses?.filter{$0.ready == false}.count ?? 0,containers: $0.spec?.containers.enumerated().map{
                    Container(
                    id: $1.name, name: $1.name, image: $1.image ?? ""
                    ,path: $1.terminationMessagePath ?? "unknow", policy: $1.terminationMessagePolicy ?? "unknow", pullPolicy: $1.imagePullPolicy ?? "unknow"
                    , status: consainersStatus[$0].state?.running != nil ? .Running : (consainersStatus[$0].state?.waiting != nil ? .Waiting : .Terminated)
                    , ready: consainersStatus[$0].ready
                    , error: consainersStatus[$0].state?.terminated != nil && consainersStatus[$0].state?.terminated?.exitCode != 0
                    )
                  
                    
                } ?? [], clusterIP: $0.status?.podIP ?? "unknow", nodeIP: $0.status?.hostIP ?? "unknow", labels: $0.metadata?.labels
                                                                                                                , annotations: $0.metadata?.annotations, namespace: $0.metadata?.namespace ?? "unknow", controllerType: .ReplicaSet   , controllerName: ($0.metadata?.ownerReferences?.first?.name) ?? "", raw: $0)}
        } else {
            return []
        }
       
    }
    
    mutating func podsByStateful(in ns: NamespaceSelector, stateful: [String: String]) async -> [Pod] {
        checkAWSToken()
        if let client = client, !stateful.isEmpty {
            return ((try? await client.pods.list(in: ns,options: [.labelSelector(.eq(stateful))]).get().items) ?? []).map {
                let consainersStatus = $0.status?.containerStatuses ?? []
                return Pod(id: $0.name ?? "", name: $0.name ?? "", k8sName: "",status: ($0.status?.phase) ?? "", expect: $0.spec?.containers.count ?? 0, error: $0.status?.containerStatuses == nil ? $0.spec?.containers.count ?? 0 : $0.status?.containerStatuses?.filter{$0.started == false}.count ?? 0,notReady: $0.status?.containerStatuses == nil ? ($0.spec?.containers.count ?? 0) : $0.status?.containerStatuses?.filter{$0.ready == false}.count ?? 0, containers:$0.spec?.containers.enumerated().map{
                Container(
                id: $1.name, name: $1.name, image: $1.image ?? ""
                ,path: $1.terminationMessagePath ?? "unknow", policy: $1.terminationMessagePolicy ?? "unknow", pullPolicy: $1.imagePullPolicy ?? "unknow"
                , status: consainersStatus[$0].state?.running != nil ? .Running : (consainersStatus[$0].state?.waiting != nil ? .Waiting : .Terminated)
                
                    , ready: consainersStatus[$0].ready
                , error: consainersStatus[$0].state?.terminated != nil && consainersStatus[$0].state?.terminated?.exitCode != 0
                )
                
            } ?? [], clusterIP: $0.status?.podIP ?? "unknow", nodeIP: $0.status?.hostIP ?? "unknow", labels: $0.metadata?.labels
                                                                                                                 , annotations: $0.metadata?.annotations, namespace: $0.metadata?.namespace ?? "unknow", controllerType: .StatefulSet   , controllerName: ($0.metadata?.ownerReferences?.first?.name) ?? "", raw: $0)}
        } else {
            return []
        }
        
    }
    
    mutating func replicaByDeployment(in ns: NamespaceSelector, deployment: [String: String]) async -> [Replica] {
        checkAWSToken()
        if let client = client, !deployment.isEmpty {
            let replicas = try? await client.appsV1.replicaSets.list(in: ns,options: [.labelSelector(.eq(deployment))]).get().items
            return (replicas ?? []).map {
                Replica(id: $0.name ?? "", name: $0.name ?? "", k8sName:  ($0.spec?.selector.matchLabels) ?? [:]
                                                              , labels: $0.metadata?.labels
                                                              , annotations: $0.metadata?.annotations
                                                              , namespace: $0.metadata?.namespace ?? "unknow"
                                                              , status: $0.status?.replicas == $0.status?.readyReplicas
                    )
            }
        } else {
            return []
        }
        
    }
}
