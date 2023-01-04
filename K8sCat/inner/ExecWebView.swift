//
//  WebView.swift
//  Yamler
//
//  Created by 顾艳华 on 2022/12/14.
//

import SwiftUI
import WebKit
import Foundation

struct ExecWebView: UIViewRepresentable {
    
    @Environment(\.colorScheme) private var colorScheme
//    let pod: Pod
//    let container: Container
    let close: () -> Void

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        let baseUrl = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "exec")!
//        print(baseUrl)
        var component = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
        component?.queryItems = [URLQueryItem(name: "theme", value: colorScheme == .dark ? "dark" : "light")]
        
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

