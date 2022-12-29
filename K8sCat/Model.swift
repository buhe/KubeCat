//
//  Model.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/21.
//

import Foundation
import SwiftkubeClient
import SwiftkubeModel

struct Model {
    let client: KubernetesClient
    
    var nodes: [core.v1.Node] = []
    var namespaces: [core.v1.Namespace] = []
    var pods: [String: [core.v1.Pod]] = ["": []]
    var deployments: [String: [apps.v1.Deployment]] = ["": []]
    var jobs: [String: [batch.v1.Job]] = ["": []]
    var cronJobs: [String: [batch.v1beta1.CronJob]] = ["": []]
    var statefulls: [String: [apps.v1.StatefulSet]] = ["": []]
    var services: [String: [core.v1.Service]] = ["": []]
    var configMaps: [String: [core.v1.ConfigMap]] = ["": []]
    var secrets: [String: [core.v1.Secret]] = ["": []]
    var daemons: [String: [apps.v1.DaemonSet]] = ["": []]
    var replicas: [String: [apps.v1.ReplicaSet]] = ["": []]
//    var replications: [String: [core.v1.ReplicationController]] = ["": []]
    
    func logs(in ns: NamespaceSelector, pod: Pod, container: Container, delegate:  LogWatcherDelegate) throws -> SwiftkubeClientTask {
        try client.pods.follow(in: ns, name: pod.name, container: container.name, delegate: delegate)
        
    }
    
    func podsByDeployment(in ns: NamespaceSelector, deployment: String) -> [Pod] {
        try! client.pods.list(in: ns,options: [.labelSelector(.eq(["app.kubernetes.io/name": deployment]))]).wait().items.map { Pod(id: $0.name!, name: $0.name!,k8sName: deployment, status: ($0.status?.phase)!, expect: $0.spec?.containers.count ?? 0, pending: 0, containers: ($0.spec?.containers.map{Container(id: $0.name, name: $0.name, image: $0.image!)})!, clusterIP: ($0.status?.podIP)!, nodeIP: ($0.status?.hostIP)!)}
    }
    
    func podsByReplica(in ns: NamespaceSelector, replica: String) -> [Pod] {
        try! client.pods.list(in: ns,options: [.labelSelector(.eq(["app.kubernetes.io/name": replica]))]).wait().items.map { Pod(id: $0.name!, name: $0.name!, k8sName: replica,status: ($0.status?.phase)!, expect: $0.spec?.containers.count ?? 0, pending: 0, containers: ($0.spec?.containers.map{Container(id: $0.name, name: $0.name, image: $0.image!)})!, clusterIP: ($0.status?.podIP)!, nodeIP: ($0.status?.hostIP)!)}
    }
    
    func podsByDaemon(in ns: NamespaceSelector, daemon: String) -> [Pod] {
        try! client.pods.list(in: ns,options: [.labelSelector(.eq(["app.kubernetes.io/name": daemon]))]).wait().items.map { Pod(id: $0.name!, name: $0.name!, k8sName: daemon,status: ($0.status?.phase)!, expect: $0.spec?.containers.count ?? 0, pending: 0, containers: ($0.spec?.containers.map{Container(id: $0.name, name: $0.name, image: $0.image!)})!, clusterIP: ($0.status?.podIP)!, nodeIP: ($0.status?.hostIP)!)}
    }
    
    func podsByService(in ns: NamespaceSelector, service: String) -> [Pod] {
        try! client.pods.list(in: ns,options: [.labelSelector(.eq(["app.kubernetes.io/name": service]))]).wait().items.map { Pod(id: $0.name!, name: $0.name!, k8sName: service,status: ($0.status?.phase)!, expect: $0.spec?.containers.count ?? 0, pending: 0, containers: ($0.spec?.containers.map{Container(id: $0.name, name: $0.name, image: $0.image!)})!, clusterIP: ($0.status?.podIP)!, nodeIP: ($0.status?.hostIP)!)}
    }
    
    func podsByStateful(in ns: NamespaceSelector, stateful: String) -> [Pod] {
        try! client.pods.list(in: ns,options: [.labelSelector(.eq(["app.kubernetes.io/name": stateful]))]).wait().items.map { Pod(id: $0.name!, name: $0.name!, k8sName: stateful,status: ($0.status?.phase)!, expect: $0.spec?.containers.count ?? 0, pending: 0, containers: ($0.spec?.containers.map{Container(id: $0.name, name: $0.name, image: $0.image!)})!, clusterIP: ($0.status?.podIP)!, nodeIP: ($0.status?.hostIP)!)}
    }
    
    fileprivate func workaroundChinaSpecialBug() {
        let url = URL(string: "https://www.baidu.com")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let _ = data else { return }
//            print(String(data: data, encoding: .utf8)!)
        }
        
        task.resume()
    }
    
    init() {
        client = KubernetesClient(config: try! Default().config()!)
        workaroundChinaSpecialBug()
        
        try? namespace()
        try? pod(in: .default)
        try? node()
        
    }
    
    mutating func namespace() throws {
        let namespaces = try client.namespaces.list().wait().items
//        print("ns is \(namespaces)")
        self.namespaces = namespaces
    }
    
    mutating func node() throws {
        self.nodes = try client.nodes.list().wait().items
    }
    
    mutating func pod(in ns: NamespaceSelector) throws {
        let pods = try client.pods.list(in: ns).wait().items
        switch ns {
        case .namespace(let name):
            self.pods[name] = pods
        default: break
        }
    }
    
    mutating func deployment(in ns: NamespaceSelector) throws {
        let deployments = try client.appsV1.deployments.list(in: ns).wait().items
//        let l = deployments.map {
//            $0.metadata?.labels
//        }
//        print("label: \(l)")
//        let n = deployments.map {
//            $0.name
//        }
//        print("name: \(n)")
        switch ns {
        case .namespace(let name):
            self.deployments[name] = deployments
        default: break
        }
    }
    
    mutating func job(in ns: NamespaceSelector) throws {
        let job = try client.batchV1.jobs.list(in: ns).wait().items
        switch ns {
        case .namespace(let name):
            self.jobs[name] = job
        default: break
        }
    }
    
    mutating func cronJob(in ns: NamespaceSelector) throws {
        let cronJob = try client.batchV1Beta1.cronJobs.list(in: ns).wait().items
        switch ns {
        case .namespace(let name):
            self.cronJobs[name] = cronJob
        default: break
        }
    }
    
    mutating func statefull(in ns: NamespaceSelector) throws {
        let statefull = try client.appsV1.statefulSets.list(in: ns).wait().items
        switch ns {
        case .namespace(let name):
            self.statefulls[name] = statefull
        default: break
        }
    }
    
    mutating func service(in ns: NamespaceSelector) throws {
        let service = try client.services.list(in: ns).wait().items
        switch ns {
        case .namespace(let name):
            self.services[name] = service
        default: break
        }
    }
    
    mutating func configMap(in ns: NamespaceSelector) throws {
        let configMap = try client.configMaps.list(in: ns).wait().items
        switch ns {
        case .namespace(let name):
            self.configMaps[name] = configMap
        default: break
        }
    }
    
    mutating func secret(in ns: NamespaceSelector) throws {
        let secret = try client.secrets.list(in: ns).wait().items
        switch ns {
        case .namespace(let name):
            self.secrets[name] = secret
        default: break
        }
    }
    
    mutating func daemon(in ns: NamespaceSelector) throws {
        let daemon = try client.appsV1.daemonSets.list(in: ns).wait().items
        switch ns {
        case .namespace(let name):
            self.daemons[name] = daemon
        default: break
        }
    }
    
    mutating func replica(in ns: NamespaceSelector) throws {
        let replica = try client.appsV1.replicaSets.list(in: ns).wait().items
        switch ns {
        case .namespace(let name):
            self.replicas[name] = replica
        default: break
        }
    }
    
//    mutating func replication(in ns: NamespaceSelector) throws {
//        let replication = try client.replicationControllers.list(in: ns).wait().items
//        switch ns {
//        case .namespace(let name):
//            self.replications[name] = replication
//        default: break
//        }
//    }
}
