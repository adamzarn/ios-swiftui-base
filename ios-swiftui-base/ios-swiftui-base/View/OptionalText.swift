//
//  OptionalText.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 2/22/22.
//

import Foundation
import SwiftUI

struct OptionalText: View {
    var text: String?
    
    init(_ text: String?) {
        self.text = text
    }
    
    var body: some View {
        if let text = text {
            Text(text)
        } else {
            EmptyView()
        }
    }
}
