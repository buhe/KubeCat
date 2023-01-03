//
//  Model+Yaml.swift
//  K8sCat
//
//  Created by 顾艳华 on 2023/1/2.
//

import Foundation
import Yams
import SwiftkubeModel
import SwiftkubeClient


extension Pod {
    func encodeYaml(client: KubernetesClient?) -> String {
        if let _ = client {
            let encoder = YAMLEncoder()
            
            
            let r = try? encoder.encode(raw!)
            return r!
            
        } else {
            return ""
        }
    }
    
    func decodeYaml(client: KubernetesClient?, yaml: String) {
        if let client = client {
            let decoder = YAMLDecoder()
            let d = try? decoder.decode(core.v1.Pod.self, from: yaml)
            let _ = try? client.pods.update(d!).wait()
//            print("update \(r!)")
        }
    }
}

extension Deployment {
    func encodeYaml(client: KubernetesClient?) -> String {
        if let _ = client {
            let encoder = YAMLEncoder()
            
            
            let r = try? encoder.encode(raw!)
            return r!
            
        } else {
            return ""
        }
    }
    
    func decodeYaml(client: KubernetesClient?, yaml: String) {
        if let client = client {
            let decoder = YAMLDecoder()
            var d = try? decoder.decode(apps.v1.Deployment.self, from: yaml)
//            d?.spec?.replicas = 0
            let _ = try? client.appsV1.deployments.update(d!).wait()
//            print("update \(r!)")
        }
    }
}
