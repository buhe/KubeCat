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
    public func getCallerIdentityToken(_ input: TokenRequest, logger: Logger = AWSClient.loggingDisabled, on eventLoop: EventLoop? = nil) -> EventLoopFuture<TokenResponse> {
        return self.client.execute(operation: "GetCallerIdentity", path: "/", httpMethod: .GET, serviceConfig: self.config, input: input, logger: logger, on: eventLoop)
    }
}

public struct TokenResponse: AWSDecodableShape {
    let kind: String?
    let apiVersion: String?
    let status: Status?
    
    private enum CodingKeys: String, CodingKey {
        case kind = "kind"
        case apiVersion = "apiVersion"
        case status
    }
    
    public init(king: String? = nil, apiVersion: String? = nil, status: Status? = nil) {
        self.kind = king
        self.apiVersion = apiVersion
        self.status = status
    }
}

public struct Status: AWSDecodableShape {
    let expirationTimestamp: String?
    let token: String?
    
    private enum CodingKeys: String, CodingKey {
        case expirationTimestamp = "expirationTimestamp"
        case token = "token"
    }
    
    public init(expirationTimestamp: String? = nil, token: String? = nil) {
        self.expirationTimestamp = expirationTimestamp
        self.token = token
    }
}

