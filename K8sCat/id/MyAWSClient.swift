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
    
    
    let ak: String
    let sk: String
    let region: String
    let clusterName: String
    
    
    static let TOKEN_PREFIX = "k8s-aws-v1."
    func getCluster() -> AWSCluster{
        let client = AWSClient(
            credentialProvider: .static(accessKeyId: ak, secretAccessKey: sk),
            httpClientProvider: .createNew
        )
        var eks: EKS?
        switch region {
        case "us-west-1": eks = EKS(client: client, region: .uswest1)
        case "us-east-1": eks = EKS(client: client, region: .useast1)
        case "us-east-2": eks = EKS(client: client, region: .useast2)
        case "us-west-2": eks = EKS(client: client, region: .uswest2)
        case "ca-central-1": eks = EKS(client: client, region: .cacentral1)
        case "eu-west-1": eks = EKS(client: client, region: .euwest1)
        case "eu-west-2": eks = EKS(client: client, region: .euwest2)
        case "eu-west-3": eks = EKS(client: client, region: .euwest3)
        case "eu-south-1": eks = EKS(client: client, region: .eusouth1)
        case "eu-south-2": eks = EKS(client: client, region: .eusouth2)
        case "eu-central-1": eks = EKS(client: client, region: .eucentral1)
        case "eu-central-2": eks = EKS(client: client, region: .eucentral2)
        case "ap-northeast-1": eks = EKS(client: client, region: .apnortheast1)
        case "ap-northeast-2": eks = EKS(client: client, region: .apnortheast2)
        case "ap-northeast-3": eks = EKS(client: client, region: .apnortheast3)
        case "ap-southeast-1": eks = EKS(client: client, region: .apsoutheast1)
        case "ap-southeast-2": eks = EKS(client: client, region: .apsoutheast2)
        case "ap-southeast-3": eks = EKS(client: client, region: .apsoutheast3)
        case "ap-south-1": eks = EKS(client: client, region: .apsouth1)
        case "ap-south-2": eks = EKS(client: client, region: .apsouth2)
        case "sa-east-1": eks = EKS(client: client, region: .saeast1)
        default: break
        }
//        let eks = EKS(client: client, region: .uswest1)
        let r = EKS.DescribeClusterRequest(name: clusterName)
        let c = try? eks!.describeCluster(r).wait().cluster
        let server = c?.endpoint
        let ca = c?.certificateAuthority?.data
//        print("sever: \(server!) ca: \(ca!)")
        try! client.syncShutdown()
        return AWSCluster(sever: server!, ca: ca!)
    }

    func getToken() -> String {
        let client = AWSClient(
            credentialProvider: .static(accessKeyId: ak, secretAccessKey: sk),
            httpClientProvider: .createNew
        )
        var sts: STS?
        switch region {
        case "us-west-1": sts = STS(client: client, region: .uswest1)
        case "us-east-1": sts = STS(client: client, region: .useast1)
        case "us-east-2": sts = STS(client: client, region: .useast2)
        case "us-west-2": sts = STS(client: client, region: .uswest2)
        case "ca-central-1": sts = STS(client: client, region: .cacentral1)
        case "eu-west-1": sts = STS(client: client, region: .euwest1)
        case "eu-west-2": sts = STS(client: client, region: .euwest2)
        case "eu-west-3": sts = STS(client: client, region: .euwest3)
        case "eu-south-1": sts = STS(client: client, region: .eusouth1)
        case "eu-south-2": sts = STS(client: client, region: .eusouth2)
        case "eu-central-1": sts = STS(client: client, region: .eucentral1)
        case "eu-central-2": sts = STS(client: client, region: .eucentral2)
        case "ap-northeast-1": sts = STS(client: client, region: .apnortheast1)
        case "ap-northeast-2": sts = STS(client: client, region: .apnortheast2)
        case "ap-northeast-3": sts = STS(client: client, region: .apnortheast3)
        case "ap-southeast-1": sts = STS(client: client, region: .apsoutheast1)
        case "ap-southeast-2": sts = STS(client: client, region: .apsoutheast2)
        case "ap-southeast-3": sts = STS(client: client, region: .apsoutheast3)
        case "ap-south-1": sts = STS(client: client, region: .apsouth1)
        case "ap-south-2": sts = STS(client: client, region: .apsouth2)
        case "sa-east-1": sts = STS(client: client, region: .saeast1)
        default: break
        }
        let url = try! sts!.signURL(
            url: URL(string: sts!.endpoint+"/?Action=GetCallerIdentity&Version=2011-06-15")!,
            httpMethod: .GET,
            headers: ["x-k8s-aws-id": clusterName],
            expires: .seconds(60)
        ).wait()
//        print("signed: \(url.absoluteString)")
        var token = MyAWSClient.TOKEN_PREFIX + Base64FS.encodeString(str: url.absoluteString)
        token.remove(at: token.index(before: token.endIndex))
        token.remove(at: token.index(before: token.endIndex))
//        print("sts: \(token)")
        try! client.syncShutdown()
        return token
    }
}

struct AWSCluster {
    let sever: String
    let ca: String
}
