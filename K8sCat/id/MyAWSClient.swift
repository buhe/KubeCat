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
    
    static let TOKEN_PREFIX = "k8s-aws-v1."
    func getCluster() -> AWSCluster{
        let client = AWSClient(
            credentialProvider: .static(accessKeyId: ak, secretAccessKey: sk),
            httpClientProvider: .createNew
        )
        let eks = EKS(client: client, region: .uswest1)
        let r = EKS.DescribeClusterRequest(name: clusterName)
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
        let url = try! sts.signURL(
            url: URL(string: sts.endpoint+"/?Action=GetCallerIdentity&Version=2011-06-15")!,
            httpMethod: .GET,
            headers: ["x-k8s-aws-id": clusterName],
            expires: .seconds(60)
        ).wait()
        print("signed: \(url.absoluteString)")
        var token = MyAWSClient.TOKEN_PREFIX + Base64FS.encodeString(str: url.absoluteString)
        token.remove(at: token.index(before: token.endIndex))
        token.remove(at: token.index(before: token.endIndex))
//        let r = "vP0FjdGlvbj1HZXRDYWxsZXJJZGVudGl0eSZWZXJzaW9uPTIwMTEtMDYtMTUm"
//        token = token.replacingOccurrences(of: "/", with: r)
        print("sts: \(token)")
        try! client.syncShutdown()
        return token
    }
}

struct AWSCluster {
    let sever: String
    let ca: String
}
