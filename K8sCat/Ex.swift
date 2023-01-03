//
//  Ex.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/20.
//

import SwiftUI
import SwiftkubeClient
import SwiftkubeModel


extension View {
    func border(width: CGFloat, edges: [Edge], color: SwiftUI.Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct Hpa: Identifiable {
    var id: String
    var name: String
//    let k8sName: String
//    let labels: [String: String]?
//    let annotations: [String: String]?
    let namespace: String
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
    let raw: core.v1.Pod?
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
    let status: Bool
    let raw: apps.v1.Deployment?
}

struct PersistentVolume: Identifiable {
    var id: String
    var name: String
    let labels: [String: String]?
    let annotations: [String: String]?
    
//    let capactiy: String
    let accessModes: String
//    let reclaim: String
    let status: String
    let storageClass: String
}

struct PersistentVolumeClaim: Identifiable {
    var id: String
    var name: String
//    let labels: [String: String]?
//    let annotations: [String: String]?
}

struct Job: Identifiable {
    var id: String
    var name: String
    let k8sName: String
    let labels: [String: String]?
    let annotations: [String: String]?
    let namespace: String
    let status: Bool
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
    let status: Bool
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
    let status: Bool
}

struct Replica: Identifiable {
    var id: String
    var name: String
    var k8sName: String
    let labels: [String: String]?
    let annotations: [String: String]?
    let namespace: String
    let status: Bool
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
