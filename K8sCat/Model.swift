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
    @AppStorage(wrappedValue: true, "first") var first: Bool
    private var viewContext: NSManagedObjectContext
    private var current: ClusterEntry?
//    @FetchRequest(
//        sortDescriptors: [],
//        animation: .default)
//    private var cluters: FetchedResults<ClusterEntry>
    var client: KubernetesClient?
    var hasAndSelectDemo = false
    
    var nodes: [core.v1.Node]?
    var namespaces: [core.v1.Namespace] = []
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
    var pvcs: [core.v1.ObjectReference]?
    var hpas: [String: [autoscaling.v2beta1.HorizontalPodAutoscaler]] = ["": []]
//    var pvcs: [core.v1.PersistentVolumeClaim]?
//    var replications: [String: [core.v1.ReplicationController]] = ["": []]
    
    func logs(in ns: NamespaceSelector, pod: Pod, container: Container, delegate:  LogWatcherDelegate) throws -> SwiftkubeClientTask? {
        if let client = client {
            return try client.pods.follow(in: ns, name: pod.name, container: container.name, delegate: delegate)
        } else {
            return nil
        }
    }
    
    
    fileprivate func workaroundChinaSpecialBug() {
        let url = URL(string: "https://www.baidu.com")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let _ = data else { return }
//            print(String(data: data, encoding: .utf8)!)
        }
        
        task.resume()
    }
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        if first {
            workaroundChinaSpecialBug()
            first = false
        }
        
        select(viewContext: viewContext)
    }
    
    fileprivate func selectNotSome(c: ClusterEntry) -> (Bool) {
        return (c != self.current)
    }
    
    fileprivate func pervNoDemo() -> (Bool) {
        return (self.client != nil)
    }
    
    mutating func select(viewContext: NSManagedObjectContext) {
        var clusters = try! viewContext.fetch(NSFetchRequest(entityName: "ClusterEntry")) as! [ClusterEntry]
        if clusters.isEmpty {
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
        for c in clusters {
            if c.selected {
                print("found cluster: \(c)")
                if c.demo {
                    print("has demo")
                    hasAndSelectDemo = true
                }
                
                if !selectNotSome(c: c) {
                    break
                }
                
                if pervNoDemo() {
                    try? self.client!.syncShutdown()
                    client = nil
                }
                clearAll()
                let type = ClusterType(rawValue: c.type!)
                var config: KubernetesClientConfig?
                switch type {
                case .KubeConfig, .Aliyun:
                    config = try? Config(content: c.config!).config()
                case .AWS:
                    config = try? AWS(awsId: c.accessKeyID!, awsSecret: c.secretAccessKey!, region: c.region!, clusterName: c.clusterName!).config()
                default: break
                }
                if config != nil {
                    // no demo
                    client = KubernetesClient(config: config!)
                }
                self.current = c
                try? namespace()
                
            }
        }
    }
    
    mutating func clearAll() {
        nodes = nil
        namespaces = []
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
    
    mutating func namespace() throws {
        if let client = client {
            do{
                let namespaces = try client.namespaces.list().wait().items
                self.namespaces = namespaces
            }catch{
                print(error)
            }
        
            
        } else {
            self.namespaces = []
        }
    }
    
    mutating func node() throws {
        if let client = client {
            self.nodes = try client.nodes.list().wait().items
        } else {
            self.nodes = []
        }
    }
    
    mutating func pv() throws {
        if let client = client {
            let pvs = try client.persistentVolumes.list().wait().items
            self.pvs = pvs
        } else {
            self.pvs = []
        }

    }
    
    mutating func pvc() throws {
        if let client = client {
            let pvcs = try client.persistentVolumes.list().wait().items.map{($0.spec?.claimRef)!}
            
            self.pvcs = pvcs
        } else {
            self.pvcs = []
        }

    }
    
    mutating func pod(in ns: NamespaceSelector) throws {
        if let client = client {
            let pods = try client.pods.list(in: ns).wait().items
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
    
    mutating func hpa(in ns: NamespaceSelector) throws {
        if let client = client {
            let hpa = try client.autoScalingV2Beta1.horizontalPodAutoscalers.list(in: ns).wait().items
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
    
    mutating func deployment(in ns: NamespaceSelector) throws {
        if let client = client {
            let deployments = try client.appsV1.deployments.list(in: ns).wait().items
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
    
    mutating func job(in ns: NamespaceSelector) throws {
        if let client = client {
            let job = try client.batchV1.jobs.list(in: ns).wait().items
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
    
    mutating func cronJob(in ns: NamespaceSelector) throws {
        if let client = client {
            let cronJob = try client.batchV1.cronJobs.list(in: ns).wait().items
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
    
    mutating func statefull(in ns: NamespaceSelector) throws {
        if let client = client {
            let statefull = try client.appsV1.statefulSets.list(in: ns).wait().items
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
    
    mutating func service(in ns: NamespaceSelector) throws {
        if let client = client {
            let service = try client.services.list(in: ns).wait().items
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
    
    mutating func configMap(in ns: NamespaceSelector) throws {
        if let client = client {
            let configMap = try client.configMaps.list(in: ns).wait().items
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
    
    mutating func secret(in ns: NamespaceSelector) throws {
        if let client = client {
            let secret = try client.secrets.list(in: ns).wait().items
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
    
    mutating func daemon(in ns: NamespaceSelector) throws {
        if let client = client {
            let daemon = try client.appsV1.daemonSets.list(in: ns).wait().items
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
    
    mutating func replica(in ns: NamespaceSelector) throws {
        if let client = client {
            let replica = try client.appsV1.replicaSets.list(in: ns).wait().items
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
