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

extension Model {
    func getDeploymentYaml(id: String) -> String {
        if let client = client {
            let encoder = YAMLEncoder()
            
            let i = try? client.appsV1.deployments.get(name: id).wait()
            let r = try? encoder.encode(i)
            return r!
            
        } else {
            return ""
        }
    }
    
    func loadDeploymentYaml(yaml: String) {
        if let client = client {
            let decoder = YAMLDecoder()
            let d = try? decoder.decode(apps.v1.Deployment.self, from: yaml)
            let r = try? client.appsV1.deployments.update(d!).wait()
        }
    }
}
