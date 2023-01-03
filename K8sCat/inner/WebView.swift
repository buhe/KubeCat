//
//  WebView.swift
//  Yamler
//
//  Created by 顾艳华 on 2022/12/14.
//

import SwiftUI
import WebKit
import Foundation
import SwiftkubeClient
import SwiftkubeModel

class WKHandler: NSObject, WKScriptMessageHandler {
    let yamlble: Yamlble
    init(yamlble: Yamlble) {
        self.yamlble = yamlble
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let dict = message.body as? [String : AnyObject] else {
            return
        }

        print("from webview \(dict)")
        if dict["done"]! as! String == "true" {
            // download yaml
            yamlble.decodeYaml(client: nil, yaml: dict["message"]! as! String)
        }
    }
}
struct WebView: UIViewRepresentable {
    
    @Environment(\.colorScheme) private var colorScheme
//    let pod: Pod
//    let container: Container
    let yamlble: Yamlble
    let client: KubernetesClient?

    func makeUIView(context: Context) -> WKWebView {
        let wk = WKWebView()
        wk.configuration.userContentController.add(WKHandler(yamlble: yamlble), name: "toggleMessageHandler")
        return wk
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        
        let baseUrl = Bundle.main.url(forResource: "index", withExtension: "html")!
//        print(baseUrl)
        var component = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
        component?.queryItems = [URLQueryItem(name: "theme", value: colorScheme == .dark ? "dark" : "light")]
        
        if let url = component?.url {
//            print(url)
            webView.loadFileURL(url, allowingReadAccessTo: url)
        }
        
        
        
//        let baseUrl = URL(string: "http://localhost:3000")!
//        var component = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
//        component?.queryItems = [URLQueryItem(name: "items", value: string)]
//        if let url = component?.url {
//            print(url)
//            webView.load(URLRequest(url: url))
//        }
        
    }
}

