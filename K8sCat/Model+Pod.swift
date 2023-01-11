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
    
    func podsByJob(in ns: NamespaceSelector, job: [String: String], name: String) -> [Pod] {
        
        if let client = client {
           return try! client.pods.list(in: ns,options: [.labelSelector(.eq(job))]).wait().items.map { Pod(id: $0.name!, name: $0.name!,k8sName: "", status: $0.status?.phase ?? "unknow", expect: $0.spec?.containers.count ?? 0, warning: $0.status?.containerStatuses == nil ? $0.spec?.containers.count ?? 0 : $0.status?.containerStatuses?.filter{$0.ready == false}.count ?? 0, containers: ($0.spec?.containers.map{Container(id: $0.name, name: $0.name, image: $0.image!,path: $0.terminationMessagePath!, policy: $0.terminationMessagePolicy!, pullPolicy: $0.imagePullPolicy!)})!, clusterIP: $0.status?.podIP ?? "unknow", nodeIP: $0.status?.hostIP ?? "unknow", labels: $0.metadata?.labels
                                                                                                                         , annotations: $0.metadata?.annotations, namespace: $0.metadata?.namespace ?? "unknow"
                                                                                                           , controllerType: .Job, controllerName: name
           ,raw: $0
           )}
        } else {
            return []
        }
        
    }
    
    func podsByCronJob(in ns: NamespaceSelector, cronJob: String) -> [Pod] {
//        if let client = client {
//            return try! client.pods.list(in: ns,options: [.labelSelector(.eq(["job-name": cronJob]))]).wait().items.map { Pod(id: $0.name!, name: $0.name!,k8sName: cronJob, status: ($0.status?.phase)!, expect: $0.spec?.containers.count ?? 0, warning: $0.status?.containerStatuses == nil ? $0.spec?.containers.count ?? 0 : $0.status?.containerStatuses?.filter{$0.ready == false}.count ?? 0, containers: ($0.spec?.containers.map{Container(id: $0.name, name: $0.name, image: $0.image!,path: $0.terminationMessagePath!, policy: $0.terminationMessagePolicy!, pullPolicy: $0.imagePullPolicy!)})!, clusterIP: $0.status?.podIP ?? "unknow", nodeIP: $0.status?.hostIP ?? "unknow", labels: $0.metadata?.labels
//                                                                                                                               , annotations: $0.metadata?.annotations, namespace: $0.metadata?.namespace ?? "unknow",raw: $0)}
//        } else {
            return []
//        }
        
    }
    
    func podsByDeployment(in ns: NamespaceSelector, deployment: String) -> [Pod] {
//        if let client = client {
//            return try! client.pods.list(in: ns,options: [.labelSelector(.eq(["app.kubernetes.io/name": deployment]))]).wait().items.map { Pod(id: $0.name!, name: $0.name!,k8sName: deployment, status: ($0.status?.phase)!, expect: $0.spec?.containers.count ?? 0, warning: $0.status?.containerStatuses == nil ? $0.spec?.containers.count ?? 0 : $0.status?.containerStatuses?.filter{$0.ready == false}.count ?? 0, containers: ($0.spec?.containers.map{Container(id: $0.name, name: $0.name, image: $0.image!,path: $0.terminationMessagePath!, policy: $0.terminationMessagePolicy!, pullPolicy: $0.imagePullPolicy!)})!, clusterIP: $0.status?.podIP ?? "unknow", nodeIP: $0.status?.hostIP ?? "unknow", labels: $0.metadata?.labels
//                                                                                                                                        , annotations: $0.metadata?.annotations, namespace: $0.metadata?.namespace ?? "unknow",raw: $0)}
//        } else {
            return []
//        }
        
    }
    
    func podsByReplica(in ns: NamespaceSelector, replica: String) -> [Pod] {
//        if let client = client {
//            return try! client.pods.list(in: ns,options: [.labelSelector(.eq(["app.kubernetes.io/name": replica]))]).wait().items.map { Pod(id: $0.name!, name: $0.name!, k8sName: replica,status: ($0.status?.phase)!, expect: $0.spec?.containers.count ?? 0, warning: $0.status?.containerStatuses == nil ? $0.spec?.containers.count ?? 0 : $0.status?.containerStatuses?.filter{$0.ready == false}.count ?? 0, containers: ($0.spec?.containers.map{Container(id: $0.name, name: $0.name, image: $0.image!,path: $0.terminationMessagePath!, policy: $0.terminationMessagePolicy!, pullPolicy: $0.imagePullPolicy!)})!, clusterIP: $0.status?.podIP ?? "unknow", nodeIP: $0.status?.hostIP ?? "unknow", labels: $0.metadata?.labels
//                                                                                                                                             , annotations: $0.metadata?.annotations, namespace: $0.metadata?.namespace ?? "unknow", raw: $0)}
//        } else {
            return []
//        }
        
    }
    
    func podsByDaemon(in ns: NamespaceSelector, daemon: String) -> [Pod] {
//        if let client = client {
//            return try! client.pods.list(in: ns,options: [.labelSelector(.eq(["app.kubernetes.io/name": daemon]))]).wait().items.map { Pod(id: $0.name!, name: $0.name!, k8sName: daemon,status: ($0.status?.phase)!, expect: $0.spec?.containers.count ?? 0, warning: $0.status?.containerStatuses == nil ? $0.spec?.containers.count ?? 0 : $0.status?.containerStatuses?.filter{$0.ready == false}.count ?? 0, containers: ($0.spec?.containers.map{Container(id: $0.name, name: $0.name, image: $0.image!,path: $0.terminationMessagePath!, policy: $0.terminationMessagePolicy!, pullPolicy: $0.imagePullPolicy!)})!, clusterIP: $0.status?.podIP ?? "unknow", nodeIP: $0.status?.hostIP ?? "unknow", labels: $0.metadata?.labels
//                                                                                                                                            , annotations: $0.metadata?.annotations, namespace: $0.metadata?.namespace ?? "unknow",raw: $0)}
//        } else {
            return []
//        }
        
    }
    
    func podsByService(in ns: NamespaceSelector, service: String) -> [Pod] {
//        if let client = client {
//            return try! client.pods.list(in: ns,options: [.labelSelector(.eq(["app.kubernetes.io/name": service]))]).wait().items.map { Pod(id: $0.name!, name: $0.name!, k8sName: service,status: ($0.status?.phase)!, expect: $0.spec?.containers.count ?? 0, warning: $0.status?.containerStatuses == nil ? $0.spec?.containers.count ?? 0 : $0.status?.containerStatuses?.filter{$0.ready == false}.count ?? 0, containers: ($0.spec?.containers.map{Container(id: $0.name, name: $0.name, image: $0.image!,path: $0.terminationMessagePath!, policy: $0.terminationMessagePolicy!, pullPolicy: $0.imagePullPolicy!)})!, clusterIP: $0.status?.podIP ?? "unknow", nodeIP: $0.status?.hostIP ?? "unknow", labels: $0.metadata?.labels
//                                                                                                                                              , annotations: $0.metadata?.annotations, namespace: $0.metadata?.namespace ?? "unknow",raw: $0)}
//        } else {
            return []
//        }
       
    }
    
    func podsByStateful(in ns: NamespaceSelector, stateful: String) -> [Pod] {
//        if let client = client {
//            return try! client.pods.list(in: ns,options: [.labelSelector(.eq(["app.kubernetes.io/name": stateful]))]).wait().items.map { Pod(id: $0.name!, name: $0.name!, k8sName: stateful,status: ($0.status?.phase)!, expect: $0.spec?.containers.count ?? 0, warning: $0.status?.containerStatuses == nil ? $0.spec?.containers.count ?? 0 : $0.status?.containerStatuses?.filter{$0.ready == false}.count ?? 0, containers: ($0.spec?.containers.map{Container(id: $0.name, name: $0.name, image: $0.image!,path: $0.terminationMessagePath!, policy: $0.terminationMessagePolicy!, pullPolicy: $0.imagePullPolicy!)})!, clusterIP: $0.status?.podIP ?? "unknow", nodeIP: $0.status?.hostIP ?? "unknow", labels: $0.metadata?.labels
//                                                                                                                                              , annotations: $0.metadata?.annotations, namespace: $0.metadata?.namespace ?? "unknow", raw: $0)}
//        } else {
            return []
//        }
        
    }
}
