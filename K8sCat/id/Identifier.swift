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
//        let token = MyAWSClient().getToken()
        let c = MyAWSClient().getCluster()
        let data = Data(base64Encoded: c.ca)!
        
        
//        let d2 = [UInt8](ca.utf8)
        let caCert = try NIOSSLCertificate.fromPEMBytes([UInt8](data))
        let userToken = "k8s-aws-v1.aHR0cHM6Ly9zdHMudXMtd2VzdC0xLmFtYXpvbmF3cy5jb20vP0FjdGlvbj1HZXRDYWxsZXJJZGVudGl0eSZWZXJzaW9uPTIwMTEtMDYtMTUmWC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVEZJWkZOU0lTRTNPVkdYQiUyRjIwMjMwMTA3JTJGdXMtd2VzdC0xJTJGc3RzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyMzAxMDdUMDM0MzM4WiZYLUFtei1FeHBpcmVzPTYwJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCUzQngtazhzLWF3cy1pZCZYLUFtei1TaWduYXR1cmU9MTQ1MzYxMmZmMTdmNDcyYjExMGJjOTc2NGEwNjA2MjViNGZiOTNjOTMzYTcwMDI2NDhkODk1MTVhYmIwMmI0Mw"
        let authentication = KubernetesClientAuthentication.bearer(token: userToken)
        
        let config = KubernetesClientConfig(
            masterURL: URL(string: c.sever)!,
            namespace: "default",
            authentication: authentication,
            trustRoots: NIOSSLTrustRoots.certificates(caCert),
            insecureSkipTLSVerify: false
        )
        
        return config
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
        let context = kubeConfig.contexts?.filter{$0.name == currentContext}.first!
        let cluster = kubeConfig.clusters?.filter{$0.name == context?.context.cluster}.first!
        let user = kubeConfig.users?.filter{$0.name == context?.context.user}.first!
        
        let p = try NIOSSLCertificate(bytes: .init((user?.authInfo.clientCertificateData)!), format: NIOSSLSerializationFormats.pem)
        let k = try NIOSSLPrivateKey(bytes: .init((user?.authInfo.clientKeyData)!), format: NIOSSLSerializationFormats.pem)
        
        let authentication = KubernetesClientAuthentication.x509(clientCertificate: p, clientKey: k)
        
        let caCert = try NIOSSLCertificate.fromPEMBytes([UInt8]((cluster?.cluster.certificateAuthorityData)!))
        
        let config = KubernetesClientConfig(
            masterURL: URL(string: (cluster?.cluster.server)!)!,
            namespace: context?.context.namespace ?? "default",
            authentication: authentication,
            trustRoots: NIOSSLTrustRoots.certificates(caCert),
            insecureSkipTLSVerify: false
        )

        return config
    }
}

struct Default: CertIdentifier {
    
    func config() throws -> SwiftkubeClient.KubernetesClientConfig? {
        let decoder = YAMLDecoder()
        guard let kubeConfig = try? decoder.decode(KubeConfig.self, from: """
apiVersion: v1
kind: Config
clusters:
- cluster:
    api-version: v1
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM0VENDQWNtZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFTTVJBd0RnWURWUVFERXdkcmRXSmwKTFdOaE1CNFhEVEl5TVRJeE9UQTJNemt4TTFvWERUTXlNVEl4TmpBMk16a3hNMW93RWpFUU1BNEdBMVVFQXhNSAphM1ZpWlMxallUQ0NBU0l3RFFZSktvWklodmNOQVFFQkJRQURnZ0VQQURDQ0FRb0NnZ0VCQU51ZUR4NEJqd0IvCkdyTWlKQ3YyRHBObHVJZDRQdUU2WlNmNUZ4N1VoYm5UTEJGcFN4QTI3TzNFQkZ6empSRTc0NmdzYnRkcnE3M2UKRlJ1NFNIUWp2MDFFc1hhaEwzaC9ETldYUFZldlpMZTRKTEd3NGlyZ2UvUlhHYW9FTEN4dHhCdURSaUs0TFZLKwp4M1FrdCsxa3VYRVRBRlh3WHQwVWxReWN6R2VBN0s0YldaaEdsQ0F6K0RyeUxrSmhVdGs4N0VEcm5jVDg4R1NiCmwxT29xZkQ4MDNXdEU4Qks0RmpEZ040RlVnMFljNFBTdHp4VXQ0M241R25zM2QvVzVoTVZoZUhIRk5LZ3l3WXQKYURta282SnNoVzBoSk9kL2ZiQnBlSGJ5bExhWXY4VSs0S2VzMkRFcHl2cHpLcjRiRno5TTZVanp1ay91cDJ1egpuYzczMkkyZWFJOENBd0VBQWFOQ01FQXdEZ1lEVlIwUEFRSC9CQVFEQWdLa01BOEdBMVVkRXdFQi93UUZNQU1CCkFmOHdIUVlEVlIwT0JCWUVGUFRPNWhITG9yckZhSlQveHdwY3lyWkdCYmV0TUEwR0NTcUdTSWIzRFFFQkN3VUEKQTRJQkFRQlpHNmRtVGtjK2NISnJOTldHeHZQRHlhcHJxY0ZLc1VqTTF1V21leW8zT1RONFVTN0Vyek9yTXRCNwo0WWs3ZUF4OFRjWnZzZ0JHcmsvUjhFZHNNTGhlZk5hbWVQdlg5bzZrcFY4bHdIVTFGMlNjUm5WU2twVWFZem02Cjh6WW12WkdLUVBobUlsVmx2dStYRGZHTXdsRFFTbUpPRXJCamtMRUJ5d3YxSjFkNll1aVgvd0pXU2k4Q3FqaS8KTVF2aXNaKy9pb1QzT3ZveWNQbDBUNUZicjllN2VZV3ZFaWRxY2lteFROMnR4Y1F0K25kZll4cnJDeHFqR2p0SQpxOGU5djhJUGFkV1lDMHpJdE5lL28rc0NUenYxQVRxRDlxVG5YajN4M1lxMFJRQnBlYm9mZHRYODhzUkNRS3psCjVyQzRiL0hYUjBQSmlScGlmSytTeDhGQzYraHoKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
    server: "https://192.168.31.16:6443"
  name: "local"
contexts:
- context:
    cluster: "local"
    user: "kube-admin-local"
  name: "local"
current-context: "local"
users:
- name: "kube-admin-local"
  user:
    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURDakNDQWZLZ0F3SUJBZ0lJQzJmZmpMa1JDN2t3RFFZSktvWklodmNOQVFFTEJRQXdFakVRTUE0R0ExVUUKQXhNSGEzVmlaUzFqWVRBZUZ3MHlNakV5TVRrd05qTTVNVE5hRncwek1qRXlNVFl3TmpVeE1EaGFNQzR4RnpBVgpCZ05WQkFvVERuTjVjM1JsYlRwdFlYTjBaWEp6TVJNd0VRWURWUVFERXdwcmRXSmxMV0ZrYldsdU1JSUJJakFOCkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQTQ1WldVQjVsRHNqRDc2Zy8ybHpCUm8wRTJKRU4KbE1SVGtnVW1GVzZseTlhUDdJNlk1eEI3Q0tjVEJxMFpHMXdweUZ0ZkFiYVUxSnFvKys1cVAvdG5wY1N1MFV4TAo0UUl0SkgzTXhyN2ZMZnEwZk92bkNlZGhIRVB4QlJJNjRqZ2ozMmozWXowU3RZZTl3dU4xekp0VHpzcUExTlgvCk4yalY5VnNWcDVkTlhERXR5QUxlK0VjOVFQSG1sZ2o2dHlDdkZjT3Jwb2o3MnQ1SGw4Nmp1eU1kRjFKdndVd2kKTU1KUVJXU0N5ckQzblpDeFRXU1hpVGlzL3hwUWtBeUR0ZmVSTzd5cUhHVTh1aS9wTkZOUXlnMldjT3cxYVVsVAppSkRDUEcvYU1WdWl6RVk5bDU4eE1kU0cwLzRkLzgreUV1L2UvaVNJVjYyNWM2YStBOWdCMlJYMnN3SURBUUFCCm8wZ3dSakFPQmdOVkhROEJBZjhFQkFNQ0JhQXdFd1lEVlIwbEJBd3dDZ1lJS3dZQkJRVUhBd0l3SHdZRFZSMGoKQkJnd0ZvQVU5TTdtRWN1aXVzVm9sUC9IQ2x6S3RrWUZ0NjB3RFFZSktvWklodmNOQVFFTEJRQURnZ0VCQUlwSgp0RGpIa3pQZTVIbCt4MmdQYWppWUFZeDZLdjB0ekNTU0JmOVJhM0JkTDk3bXNJd3FaUlZJMUloVmVTUFlPS1kxCnk5SlV2aytmdTR5SVFreDRmYWlYSTZhM0RRZXhaQ2V1TkExMGg2RDkyY1JKV1pWZU81OVcrSUI3VzJvVkxEMzgKc2VHTkcyeEVjVG5NWmEyb0xqNk5SMytCZHNIcGY4L21kQ0VOMUc1VXpKQVV5eFArQUFHYUJQa2xsN1Exclh3RAovR245a1k3c240SmlnMHVZVVpNVWQ5ZTY0bk01a2MzZE9GeGtoVmZ6UXB3RElENGV3aHN3V3N1OFRmdW9lOThNCkpkU3pVeWdRMDNXSWdxVFFSUldHQStJKzN2RmlpMmNvcGZrNUZYaVZ1UGlYeDhvYzV1blNvMEpWdmViWDJ1bTYKaEU5TnpwYUx1QVVmeW5yeTVYZz0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
    client-key-data: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcFFJQkFBS0NBUUVBNDVaV1VCNWxEc2pENzZnLzJsekJSbzBFMkpFTmxNUlRrZ1VtRlc2bHk5YVA3STZZCjV4QjdDS2NUQnEwWkcxd3B5RnRmQWJhVTFKcW8rKzVxUC90bnBjU3UwVXhMNFFJdEpIM014cjdmTGZxMGZPdm4KQ2VkaEhFUHhCUkk2NGpnajMyajNZejBTdFllOXd1TjF6SnRUenNxQTFOWC9OMmpWOVZzVnA1ZE5YREV0eUFMZQorRWM5UVBIbWxnajZ0eUN2RmNPcnBvajcydDVIbDg2anV5TWRGMUp2d1V3aU1NSlFSV1NDeXJEM25aQ3hUV1NYCmlUaXMveHBRa0F5RHRmZVJPN3lxSEdVOHVpL3BORk5ReWcyV2NPdzFhVWxUaUpEQ1BHL2FNVnVpekVZOWw1OHgKTWRTRzAvNGQvOCt5RXUvZS9pU0lWNjI1YzZhK0E5Z0IyUlgyc3dJREFRQUJBb0lCQUZ1SFdiMHREQzJPOXFZSwp2MnRkaEdtUVMxT2h1cG1LLzZVcEp2RFZxQjQ3YzNTS3dObWsyaVpYc3lJck9YNjBhU1ZvQWVTWmZtK21wN0Z5CmFBN0ZXQ0RsNGZ6UXQyK054WVA0aUFPaVBmV3E3eTJTWGord2EzREhya1lBMStlazltQmlRYVFLcXR5UTgvTk8KTVZFUll2bzJuT3Q4Q1FGS3kwbTYwUkd1bXZFcEgvMlFsU1BnbFl3RVF5NGZGT1Y2ZFJ2MXorNXdDVkhPcGpsMwp5YUZSRTlNd0krT3pBMzJRNXRJNDI2WFY5ZzFLMWZUZmhvMVA5S3JLOFV0SzdieEp3VFZ0ZHc4enZ6VzRGK2NYCnF4a0x6M0VFaWtlS3ZvTE02RXN6TEJBWGRWMkJ1WXBSMng1VkNjQlZ4Y1ZWVG5KRDdaTDBOMnBEZkNibEUrMUsKUnROSG9vRUNnWUVBNzhMNC9idFMrRWJUdlRoVHVlMWlRblZkbW9JWDdiZkhKNU5uSU1UaWNsdmZmUUZXcnRZYwo2bjUwczBOMmZzS1VsQmx1VUJTVEFZajdCSzdSSmtEV1p4V0pERkVFQkNLOXpIY1FvUVlHQUNjY1FsM2lPczR0CnBPWmFwZ0s3Q3gway9EQlV5NUNURTVRTkFDcXNtZGNwbUlzdzc4RjdIK2dOMGFDRHJmZVlka0VDZ1lFQTh3QkkKa2EwWnlTd0dJOU4yblhqR1M3STJkTGNuVStwUFJqN2dEbGxpV1hqeUpXeExNL1o1YWc4cUI4Y3BhdUxPQVVxUApHeEhjOXdLTE9WMXRXMFVpUnR2RUZ1TVVzeCtsTDQrVjNYVWROblF5OStqc0RmRUw4M3VaUzVQalJxNEZrdFhICmlzS1VKMTZ0Z1RqMjRsbmhhZzZveU5oTFRobzFRS0lYYXVvRjkvTUNnWUVBdmU0cDZIWVlSKzF6bHBXa1hja2EKNmFLbnY5b0dzcDIrK2k3ZXB5clFaOTgzcjRMNzlBeFJZOEZCR1REOEVYWjYxTWRBaDllRWpOYkNZdmRKWDVCRgpSK3ZiWVJKY3FCb05XSWVKZU1XWXcwNDRLS3JPcDk3a2NaaTVmb0R6UXQ2WGlkK1BqS0srbitmTVZMRjVnWFRjCjBxYVE0WnpYdUhMUFg1eFVNOS9MdXdFQ2dZRUE0YTk2dHFtQkVHRHQxdW8zK09ySnFGWDgwNHVqWUFGMjNQUGEKWGhsUUNXOFYzZ0hsR242b3B3TXNjd3JiQWFWaDFMc3RpK09jU0dFNWN1NjllUTROVnFnWFIzWmhyRGNRME1wWApVdFhKYXVDaTBiS25RZytFblA5SEVYVnBtU1JZa3RZdnZFVVpHak9KaTBHZnNmdnVLZlV4ZDAvREtPZVlXODN2ClYrRy81MWNDZ1lFQTcweEdOUlMyYVVkalhYcnpUMHBpNEFtRUhGMHdZYTd4ZEpyWXVNa3hLeFRvcGNkODErTnEKUWpXNFM3RUtMSG9EelpFSzJjRnlhSWV3VmpvZ3ZrTHZpQmRNSmk3MmRDWFN2d2R1SXhmdWk2VlpRbUFGSjRibApUbk1kdEhERFo3OS9URWNVQlNzaWJJUzNBdmlGdnE5K0RaWlQwU2tyNXpjQmhBUnJGTFFYdGNnPQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo=
""") else {
                return nil
            }
//        print("\(kubeConfig)")
        
        let p = try NIOSSLCertificate(bytes: .init((kubeConfig.users?.first!.authInfo.clientCertificateData)!), format: NIOSSLSerializationFormats.pem)
        let k = try NIOSSLPrivateKey(bytes: .init((kubeConfig.users?.first!.authInfo.clientKeyData)!), format: NIOSSLSerializationFormats.pem)
        
        let authentication = KubernetesClientAuthentication.x509(clientCertificate: p, clientKey: k)
        
        let caCert = try NIOSSLCertificate.fromPEMBytes([UInt8]((kubeConfig.clusters?.first!.cluster.certificateAuthorityData)!))
        
        let config = KubernetesClientConfig(
           masterURL: URL(string: "https://192.168.31.16:6443")!,
           namespace: "default",
           authentication: authentication,
           trustRoots: NIOSSLTrustRoots.certificates(caCert),
           insecureSkipTLSVerify: false
        )

//        let client = KubernetesClient(config: config)
        return config
    }
    
    
}
