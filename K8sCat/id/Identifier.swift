//
//  Identifier.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/21.
//

import Foundation
import SwiftkubeClient
import NIO
import Yams
import NIOSSL


protocol CertIdentifier {
    func config() throws -> KubernetesClientConfig?
}

struct AWS: CertIdentifier {
    let awsId: String
    let awsSecret: String
    let region: String
    let clusterName: String
    
    func config() throws -> SwiftkubeClient.KubernetesClientConfig? {
        let token = MyAWSClient(ak: awsId, sk: awsSecret, region: region, clusterName: clusterName).getToken()
        let c = MyAWSClient(ak: awsId, sk: awsSecret, region: region, clusterName: clusterName).getCluster()
        if let c = c {
            if let data = Data(base64Encoded: c.ca) {
                let caCert = try NIOSSLCertificate.fromPEMBytes([UInt8](data))
                let authentication = KubernetesClientAuthentication.bearer(token: token)
                if let url = URL(string: c.sever) {
                    let config = KubernetesClientConfig(
                        masterURL: url,
                        namespace: "default",
                        authentication: authentication,
                        trustRoots: NIOSSLTrustRoots.certificates(caCert),
                        insecureSkipTLSVerify: false
                    )
                    
                    return config
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
        
    }
    
    
}

struct Config: CertIdentifier {
    let content: String
    
    func config() throws -> SwiftkubeClient.KubernetesClientConfig? {
        let decoder = YAMLDecoder()
        guard let kubeConfig = try? decoder.decode(KubeConfig.self, from: content) else {
                return nil
            }
        if kubeConfig.clusters == nil || kubeConfig.contexts == nil || kubeConfig.users == nil {
            return nil
        }
//        print("\(kubeConfig)")
        let currentContext = kubeConfig.currentContext
        let ctxs = kubeConfig.contexts?.filter{$0.name == currentContext}
        if ctxs == nil || ctxs!.isEmpty {
            return nil
        }
        let context = ctxs!.first!
        let cluters = kubeConfig.clusters?.filter{$0.name == context.context.cluster}
        if cluters == nil || cluters!.isEmpty {
            return nil
        }
        let cluster = cluters!.first!
        let users = kubeConfig.users?.filter{$0.name == context.context.user}
        if users == nil || users!.isEmpty {
            return nil
        }
        let user = users!.first!
        if let clientCertificateData = user.authInfo.clientCertificateData,let clientKeyData = user.authInfo.clientKeyData,let certificateAuthorityData = cluster.cluster.certificateAuthorityData {
            let p = try NIOSSLCertificate(bytes: .init(clientCertificateData), format: NIOSSLSerializationFormats.pem)
            let k = try NIOSSLPrivateKey(bytes: .init(clientKeyData), format: NIOSSLSerializationFormats.pem)
            
            let authentication = KubernetesClientAuthentication.x509(clientCertificate: p, clientKey: k)
            
            let caCert = try NIOSSLCertificate.fromPEMBytes([UInt8](certificateAuthorityData))
            if let url = URL(string: cluster.cluster.server) {
                let config = KubernetesClientConfig(
                    masterURL: url,
                    namespace: context.context.namespace ?? "default",
                    authentication: authentication,
                    trustRoots: NIOSSLTrustRoots.certificates(caCert),
                    insecureSkipTLSVerify: false
                )
                return config
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
