//
//  AWSClient.swift
//  K8sCat
//
//  Created by 顾艳华 on 2023/1/6.
//

import Foundation
import SotoEKS
import SotoSTS

struct MyAWSClient {
    
    
    let ak = "AKIATFIZFNSISE3OVGXB"
    let sk = "sJ/XDebzWVD/RklpTiMeGSTvp7Sc8Ik+pq0SepVG"
    let clusterName = "dev-core"
    let region = "us-west-1"
    func getCluster() -> AWSCluster{
        let client = AWSClient(
            credentialProvider: .static(accessKeyId: ak, secretAccessKey: sk),
            httpClientProvider: .createNew
        )
        let eks = EKS(client: client, region: .uswest1)
        var r = EKS.DescribeClusterRequest(name: clusterName)
        let c = try! eks.describeCluster(r).wait().cluster
        let server = c?.endpoint
        let ca = c?.certificateAuthority?.data
        print("sever: \(server!) ca: \(ca!)")
        try! client.syncShutdown()
        return AWSCluster(sever: server!, ca: ca!)
    }

    func getToken() -> String {
        let client = AWSClient(
            credentialProvider: .static(accessKeyId: ak, secretAccessKey: sk),
            httpClientProvider: .createNew
        )
        let sts = STS(client: client, region: .uswest1)
        var r = TokenRequest(name: clusterName)
        
//        r.validate(name: clusterName)
        let t = try! sts.getCallerIdentityToken(r).wait()
        print("sts: \(t)")
        try! client.syncShutdown()
        return ""
    }
}

struct AWSCluster {
    let sever: String
    let ca: String
}
