//
//  Token.swift
//  K8sCat
//
//  Created by 顾艳华 on 2023/1/7.
//

import Foundation
import SotoCore
import SotoSTS

public struct TokenRequest: AWSEncodableShape {
    static let K8S_AWS_ID_HEADER = "x-k8s-aws-id"
    public static var _encoding = [
        AWSMemberEncoding(label: K8S_AWS_ID_HEADER, location: .header(K8S_AWS_ID_HEADER))
    ]

    /// The name of the cluster to describe.
    public let name: String

    public init(name: String) {
        self.name = name
    }

    private enum CodingKeys: CodingKey {}
}

extension STS {
    public func getCallerIdentityToken(_ input: TokenRequest, logger: Logger = AWSClient.loggingDisabled, on eventLoop: EventLoop? = nil) -> EventLoopFuture<GetCallerIdentityResponse> {
        return self.client.execute(operation: "GetCallerIdentity", path: "/", httpMethod: .GET, serviceConfig: self.config, input: input, logger: logger, on: eventLoop)
    }
}

