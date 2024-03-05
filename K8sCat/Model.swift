//
//  Model.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/21.
//

import Foundation
import SwiftkubeClient
import SwiftkubeModel
import CoreData
import SwiftUI

struct Model {
    var retry = 10
    @AppStorage(wrappedValue: true, "first") var first: Bool
    private var viewContext: NSManagedObjectContext
    private var current: ClusterEntry?
    private var date = Date()
//    @FetchRequest(
//        sortDescriptors: [],
//        animation: .default)
//    private var cluters: FetchedResults<ClusterEntry>
    var client: KubernetesClient?
    var hasAndSelectDemo = false
    
    var nodes: [core.v1.Node]?

    var pods: [String: [core.v1.Pod]] = ["": []]
    var deployments: [String: [apps.v1.Deployment]] = ["": []]
    var jobs: [String: [batch.v1.Job]] = ["": []]
    var cronJobs: [String: [batch.v1.CronJob]] = ["": []]
    var statefulls: [String: [apps.v1.StatefulSet]] = ["": []]
    var services: [String: [core.v1.Service]] = ["": []]
    var configMaps: [String: [core.v1.ConfigMap]] = ["": []]
    var secrets: [String: [core.v1.Secret]] = ["": []]
    var daemons: [String: [apps.v1.DaemonSet]] = ["": []]
    var replicas: [String: [apps.v1.ReplicaSet]] = ["": []]
    var pvs: [core.v1.PersistentVolume]?
    var pvcs: [core.v1.ObjectReference?]?
    var hpas: [String: [autoscaling.v2.HorizontalPodAutoscaler]] = ["": []]
    
    mutating func logs(in ns: NamespaceSelector, pod: Pod, container: Container) -> SwiftkubeClientTask<String>? {
        checkAWSToken()
        if let client = client {
            do {
                return try client.pods.follow(in: ns, name: pod.name, container: container.name, retryStrategy: .never)
            } catch {
                print(error)
                return nil
            }
        } else {
            return nil
        }
    }
    
    
    fileprivate func workaroundChinaSpecialBug() {
        let url = URL(string: "https://www.baidu.com")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let _ = data else { return }
        }
        
        task.resume()
    }
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        if first {
            workaroundChinaSpecialBug()
            first = false
        }

    }
    
    mutating func checkAWSToken() {
        if current != nil && current!.type != nil && ClusterType(rawValue: current!.type!) == .AWS {
            if Date().timeIntervalSince1970 - date.timeIntervalSince1970  > 30 {
                if client != nil {
                    try? client!.syncShutdown()
                }
                
                let config = try? AWS(awsId: current!.accessKeyID ?? "", awsSecret: current!.secretAccessKey ?? "", region: current!.region ?? "", clusterName: current!.clusterName ?? "").config()
                if config != nil {
                    client = KubernetesClient(config: config!)
                }
                
                date = Date()
            }
            
        }
    }
    
    fileprivate func selectNotSame(c: ClusterEntry) -> (Bool) {
        return (c != self.current)
    }
    
    fileprivate func pervNoDemo() -> (Bool) {
        return (self.client != nil)
    }
    
    fileprivate func createDemoCluster(_ viewContext: NSManagedObjectContext, _ clusters: inout [ClusterEntry]) {
        let newItem = ClusterEntry(context: viewContext)
        newItem.name = "demo"
        newItem.type = ClusterType.Demo.rawValue
        newItem.icon = "d.circle"
        
        newItem.selected = true
        newItem.demo = true
        
        clusters.append(newItem)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    mutating func select(viewContext: NSManagedObjectContext) {
        retry = 10
        do {
            var clusters = try viewContext.fetch(NSFetchRequest(entityName: "ClusterEntry")) as! [ClusterEntry]
            if clusters.isEmpty {
                createDemoCluster(viewContext, &clusters)
            }
            for c in clusters {
                if c.selected {
                    print("found cluster: \(c)")
                    if c.demo {
                        print("has demo")
                        hasAndSelectDemo = true
                    }
                    
                    if !selectNotSame(c: c) {
                        break
                    }
                    
                    if pervNoDemo() {
                        if let client = self.client {
                            try? client.syncShutdown()
                        }
                        client = nil
                    }
                    clearAll()
                    let type = ClusterType(rawValue: c.type ?? "")
                    var config: KubernetesClientConfig?
                    switch type {
                    case .KubeConfig, .Aliyun:
                        config = try? Config(content: c.config ?? "").config()
                    case .AWS:
                        date = Date()
                        config = try? AWS(awsId: c.accessKeyID ?? "", awsSecret: c.secretAccessKey ?? "", region: c.region ?? "", clusterName: c.clusterName ?? "").config()
                    default: break
                    }
                    if config != nil {
                        // no demo
                        client = KubernetesClient(config: config!)
                    }
                    self.current = c
                    // Move to UI
                    // TODO
//                    Task {
//                        try? await node()
//                    }
                }
            }
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Fetch error \(nsError), \(nsError.userInfo)")
        }
    }
    
    mutating func clearAll() {
        nodes = nil
//        namespaces = []
        pods = ["": []]
        deployments = ["": []]
        jobs = ["": []]
        cronJobs = ["": []]
        statefulls = ["": []]
        services = ["": []]
        configMaps = ["": []]
        secrets = ["": []]
        daemons = ["": []]
        replicas = ["": []]
        hpas = ["": []]
        pvs = nil
        pvcs = nil
    }
    
    mutating func namespace() async throws -> [String] {
        checkAWSToken()
        if let client = client {
            do{
                retry = retry - 1
                let namespaces = try await client.namespaces.list().items
                print("set")
                return namespaces.map { $0.name ?? "unknow" }
    
            }catch{
                print(error)
                if retry > 0 {
                    print("retry \(retry)")
                    return try await namespace()
                } else {
                    print("retry end.")
                    return []
                }
                
            }
        
            
        } else {
            return []
        }
    }
    
    mutating func node() async throws {
        checkAWSToken()
        if let client = client {
            self.nodes = try await client.nodes.list().items
        } else {
            self.nodes = []
        }
    }
    
    mutating func pv() async throws {
        checkAWSToken()
        if let client = client {
            let pvs = try await client.persistentVolumes.list().items
            self.pvs = pvs
        } else {
            self.pvs = []
        }

    }
    
    mutating func pvc() async throws {
        checkAWSToken()
        if let client = client {
            let pvcs = try await client.persistentVolumes.list().items.map{$0.spec?.claimRef}
            
            self.pvcs = pvcs
        } else {
            self.pvcs = []
        }

    }
    
    mutating func pod(in ns: NamespaceSelector) async throws {
        checkAWSToken()
        if let client = client {
            let pods = try await client.pods.list(in: ns).items
            switch ns {
            case .namespace(let name):
                self.pods[name] = pods
            default: break
            }
        } else {
            switch ns {
            case .namespace(let name):
                self.pods[name] = []
            default: break
            }
        }
    }
    
    mutating func hpa(in ns: NamespaceSelector) async throws {
        checkAWSToken()
        if let client = client {
            let hpa = try await client.autoScalingV2.horizontalPodAutoscalers.list(in: ns).items
            switch ns {
            case .namespace(let name):
                self.hpas[name] = hpa
            default: break
            }
        } else{
            switch ns {
            case .namespace(let name):
                self.hpas[name] = []
            default: break
            }
        }
        
    }
    
    mutating func deployment(in ns: NamespaceSelector) async throws {
        checkAWSToken()
        if let client = client {
            let deployments = try await client.appsV1.deployments.list(in: ns).items
            switch ns {
            case .namespace(let name):
                self.deployments[name] = deployments
            default: break
            }
        } else {
            switch ns {
            case .namespace(let name):
                self.deployments[name] = []
            default: break
            }
        }
    }
    
    mutating func job(in ns: NamespaceSelector) async throws {
        checkAWSToken()
        if let client = client {
            let job = try await client.batchV1.jobs.list(in: ns).items
            switch ns {
            case .namespace(let name):
                self.jobs[name] = job
            default: break
            }
        } else {
            switch ns {
            case .namespace(let name):
                self.jobs[name] = []
            default: break
            }
        }
    }
    
    mutating func cronJob(in ns: NamespaceSelector) async throws {
        checkAWSToken()
        if let client = client {
            let cronJob = try await client.batchV1.cronJobs.list(in: ns).items
            switch ns {
            case .namespace(let name):
                self.cronJobs[name] = cronJob
            default: break
            }
        } else {
            switch ns {
            case .namespace(let name):
                self.cronJobs[name] = []
            default: break
            }
        }
    }
    
    mutating func statefull(in ns: NamespaceSelector) async throws {
        checkAWSToken()
        if let client = client {
            let statefull = try await client.appsV1.statefulSets.list(in: ns).items
            switch ns {
            case .namespace(let name):
                self.statefulls[name] = statefull
            default: break
            }
        } else {
            switch ns {
            case .namespace(let name):
                self.statefulls[name] = []
            default: break
            }
        }
    }
    
    mutating func service(in ns: NamespaceSelector) async throws {
        checkAWSToken()
        if let client = client {
            let service = try await client.services.list(in: ns).items
            switch ns {
            case .namespace(let name):
                self.services[name] = service
            default: break
            }
        } else {
            switch ns {
            case .namespace(let name):
                self.services[name] = []
            default: break
            }
        }
    }
    
    mutating func configMap(in ns: NamespaceSelector) async throws {
        checkAWSToken()
        if let client = client {
            let configMap = try await client.configMaps.list(in: ns).items
            switch ns {
            case .namespace(let name):
                self.configMaps[name] = configMap
            default: break
            }
        } else {
            switch ns {
            case .namespace(let name):
                self.configMaps[name] = []
            default: break
            }
        }
    }
    
    mutating func secret(in ns: NamespaceSelector) async throws {
        checkAWSToken()
        if let client = client {
            let secret = try await client.secrets.list(in: ns).items
            switch ns {
            case .namespace(let name):
                self.secrets[name] = secret
            default: break
            }
        } else {
            switch ns {
            case .namespace(let name):
                self.secrets[name] = []
            default: break
            }
        }
    }
    
    mutating func daemon(in ns: NamespaceSelector) async throws {
        checkAWSToken()
        if let client = client {
            let daemon = try await client.appsV1.daemonSets.list(in: ns).items
            switch ns {
            case .namespace(let name):
                self.daemons[name] = daemon
            default: break
            }
        } else {
            switch ns {
            case .namespace(let name):
                self.daemons[name] = []
            default: break
            }
        }
    }
    
    mutating func replica(in ns: NamespaceSelector) async throws {
        checkAWSToken()
        if let client = client {
            let replica = try await client.appsV1.replicaSets.list(in: ns).items
            switch ns {
            case .namespace(let name):
                self.replicas[name] = replica
            default: break
            }
        } else {
            switch ns {
            case .namespace(let name):
                self.replicas[name] = []
            default: break
            }
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
