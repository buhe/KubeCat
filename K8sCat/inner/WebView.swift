//
//  WebView.swift
//  Yamler
//
//  Created by 顾艳华 on 2022/12/14.
//

import SwiftUI
import WebKit
import Foundation

class WKHandler: NSObject, WKScriptMessageHandler {
    let yamlble: Yamlble
    let model: Model
    var lastYaml: String
    init(yamlble: Yamlble, model: Model, lastYaml: String) {
        self.yamlble = yamlble
        self.model = model
        self.lastYaml = lastYaml
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let dict = message.body as? [String : AnyObject] else {
            return
        }

        print("from webview \(dict)")
        if dict["message"] != nil {
            lastYaml = dict["message"]! as! String
        }
        if dict["done"]! as! String == "true" {
            // download yaml
            yamlble.decodeYaml(client: model.client, yaml: lastYaml)
        }
    }
}
struct WebView: UIViewRepresentable {
    
    @Environment(\.colorScheme) private var colorScheme
//    let pod: Pod
//    let container: Container
    let yamlble: Yamlble
    let model: Model

    func makeUIView(context: Context) -> WKWebView {
        let wk = WKWebView()
        
        return wk
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let yaml = yamlble.encodeYaml(client: model.client)
        webView.configuration.userContentController.add(WKHandler(yamlble: yamlble, model: model, lastYaml: yaml), name: "toggleMessageHandler")
        let baseUrl = Bundle.main.url(forResource: "index", withExtension: "html")!
//        print(baseUrl)
        var component = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
        component?.queryItems = [URLQueryItem(name: "items", value: yaml), URLQueryItem(name: "theme", value: colorScheme == .dark ? "dark" : "light")]
        
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

