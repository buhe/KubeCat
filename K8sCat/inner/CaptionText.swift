//
//  CaptionText.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/27.
//

import SwiftUI

struct CaptionText: View {
    let text: String
    var body: some View {
        Text(text).font(.caption)
    }
}

struct CaptionText_Previews: PreviewProvider {
    static var previews: some View {
        CaptionText(text: "123")
    }
}
