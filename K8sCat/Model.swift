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
    var replications: [String: [core.v1.ReplicationController]] = ["": []]
    
    func podsByDeployment(in ns: NamespaceSelector, deployment: String) -> [Pod] {
        try! client.pods.list(in: ns,options: [.labelSelector(.eq(["app.kubernetes.io/name": deployment]))]).wait().items.map { Pod(id: $0.name!, name: $0.name!, expect: $0.spec?.containers.count ?? 0, pending: 0, fail: 0, containers: ($0.spec?.containers.map{Container(id: $0.name, name: $0.name, image: $0.image!)})!)}
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
        
    }
    
    mutating func namespace() throws {
        let namespaces = try client.namespaces.list().wait().items
//        print("ns is \(namespaces)")
        self.namespaces = namespaces
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
        let l = deployments.map {
            $0.metadata?.labels
        }
        print("label: \(l)")
        let n = deployments.map {
            $0.name
        }
        print("name: \(n)")
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
    
    mutating func replication(in ns: NamespaceSelector) throws {
        let replication = try client.replicationControllers.list(in: ns).wait().items
        switch ns {
        case .namespace(let name):
            self.replications[name] = replication
        default: break
        }
    }
}
