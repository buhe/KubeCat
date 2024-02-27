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
import SwiftUI

extension Deployment {
    func encodeYaml(client: KubernetesClient?) -> String {
        if let _ = client {
            let encoder = YAMLEncoder()
            
            if raw != nil {
                let r = try? encoder.encode(raw!)
                return r ?? ""
            } else {
                return ""
            }
            
        } else {
            return ""
        }
    }
    
    func decodeYamlAndUpdate(client: KubernetesClient?, yaml: String) {
        if let client = client {
            let decoder = YAMLDecoder()
            let d = try? decoder.decode(apps.v1.Deployment.self, from: yaml)
            if d != nil {
                let _ = try? client.appsV1.deployments.update(d!).wait()
            }
        }
    }
}

extension Stateful {
    func encodeYaml(client: KubernetesClient?) -> String {
        if let _ = client {
            let encoder = YAMLEncoder()
            
            if raw != nil {
                let r = try? encoder.encode(raw!)
                return r ?? ""
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    
    func decodeYamlAndUpdate(client: KubernetesClient?, yaml: String) {
        if let client = client {
            let decoder = YAMLDecoder()
            let d = try? decoder.decode(apps.v1.StatefulSet.self, from: yaml)
            if d != nil {
                let _ = try? client.appsV1.statefulSets.update(d!).wait()
            }
        }
    }
}

extension Daemon {
    func encodeYaml(client: KubernetesClient?) -> String {
        if let _ = client {
            let encoder = YAMLEncoder()
            
            if raw != nil {
                let r = try? encoder.encode(raw!)
                return r ?? ""
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    
    func decodeYamlAndUpdate(client: KubernetesClient?, yaml: String) {
        if let client = client {
            let decoder = YAMLDecoder()
            let d = try? decoder.decode(apps.v1.DaemonSet.self, from: yaml)
            if d != nil {
                let _ = try? client.appsV1.daemonSets.update(d!).wait()
            }
        }
    }
}

extension Hpa {
    func encodeYaml(client: KubernetesClient?) -> String {
        if let _ = client {
            let encoder = YAMLEncoder()
            
            if raw != nil {
                let r = try? encoder.encode(raw!)
                return r ?? ""
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    
    func decodeYamlAndUpdate(client: KubernetesClient?, yaml: String) {
        if let client = client {
            let decoder = YAMLDecoder()
            let d = try? decoder.decode(autoscaling.v2beta1.HorizontalPodAutoscaler.self, from: yaml)
            if d != nil {
                let _ = try? client.autoScalingV2Beta1.horizontalPodAutoscalers.update(d!).wait()
            }
        }
    }
}

extension CronJob {
    func encodeYaml(client: KubernetesClient?) -> String {
        if let _ = client {
            let encoder = YAMLEncoder()
            
            if raw != nil {
                let r = try? encoder.encode(raw!)
                return r ?? ""
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    
    func decodeYamlAndUpdate(client: KubernetesClient?, yaml: String) {
        if let client = client {
            let decoder = YAMLDecoder()
            let d = try? decoder.decode(batch.v1.CronJob.self, from: yaml)
            if d != nil {
                let _ = try? client.batchV1.cronJobs.update(d!).wait()
            }
        }
    }
}

extension PersistentVolume {
    func encodeYaml(client: KubernetesClient?) -> String {
        if let _ = client {
            let encoder = YAMLEncoder()
            
            if raw != nil {
                let r = try? encoder.encode(raw!)
                return r ?? ""
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    
    func decodeYamlAndUpdate(client: KubernetesClient?, yaml: String) {
        if let client = client {
            let decoder = YAMLDecoder()
            let d = try? decoder.decode(core.v1.PersistentVolume.self, from: yaml)
            if d != nil {
                let _ = try? client.persistentVolumes.update(d!).wait()
            }
        }
    }
}



func urlScheme(yamlble: Yamlble, client: KubernetesClient?) {
    let utf8str = yamlble.encodeYaml(client: client).data(using: .utf8)
    if let utf8str = utf8str {
        let base64Encoded = utf8str.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
#if os(iOS)
        if let url = URL(string: "yamler://" + base64Encoded) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                if let url = URL(string: "https://apps.apple.com/cn/app/yamler/id1660009640") {
                    UIApplication.shared.open(url)
                }
            }
            
        }
#endif
    }
}
