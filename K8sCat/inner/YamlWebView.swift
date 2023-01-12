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
    let close: () -> Void
    init(yamlble: Yamlble, model: Model, lastYaml: String, close: @escaping () -> Void) {
        self.yamlble = yamlble
        self.model = model
        self.lastYaml = lastYaml
        self.close = close
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let dict = message.body as? [String : AnyObject] else {
            return
        }

        print("from webview \(dict)")
        if dict["message"] != nil {
            lastYaml = dict["message"]! as! String
        }
        if  dict["done"] != nil && dict["done"]! as! String == "true" {
            // download yaml
//            print("load via yaml \(lastYaml)")
            yamlble.decodeYamlAndUpdate(client: model.client, yaml: lastYaml)
            close()
        }
    }
}
struct YamlWebView: UIViewRepresentable {
    
    @Environment(\.colorScheme) private var colorScheme
//    let pod: Pod
//    let container: Container
    let yamlble: Yamlble
    let model: Model
    let close: () -> Void

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let yaml = yamlble.encodeYaml(client: model.client)
        
        webView.configuration.userContentController.add(WKHandler(yamlble: yamlble, model: model, lastYaml: yaml, close: close), name: "toggleMessageHandler")
        let baseUrl = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "yaml")!
//        print(baseUrl)
        var component = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
        component?.queryItems = [URLQueryItem(name: "items", value: yaml), URLQueryItem(name: "theme", value: colorScheme == .dark ? "dark" : "light")]
        
        if let url = component?.url {
//            print(url)
            webView.loadFileURL(url, allowingReadAccessTo: url)
        }
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        
        
        
        
//        let baseUrl = URL(string: "http://localhost:3000")!
//        var component = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
//        component?.queryItems = [URLQueryItem(name: "items", value: string)]
//        if let url = component?.url {
//            print(url)
//            webView.load(URLRequest(url: url))
//        }
        
    }
}

