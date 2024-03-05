//
//  Model+Scale.swift
//  K8sCat
//
//  Created by 顾艳华 on 2023/1/4.
//

import Foundation
import SwiftkubeModel

extension Model {
    func scaleDeployment(deployment: Deployment, replicas: Int32) async {
        if let client = client {
            if var scale = try? await client.appsV1.deployments.getScale(in: .namespace(deployment.namespace), name: deployment.name) {
                scale.spec?.replicas = replicas
                let _ = try? await client.appsV1.deployments.updateScale(in: .namespace(deployment.namespace), name: deployment.name, scale: scale)
            }
        }
    }
}
