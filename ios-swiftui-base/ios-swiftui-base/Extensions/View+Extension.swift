//
//  View+Extension.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 2/27/22.
//

import Foundation
import UIKit
import SwiftUI

extension View {
    func roundedBorder(cornerRadius: CGFloat,
                       color: Color,
                       width: CGFloat) -> some View {
        overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(color, lineWidth: width))
    }
}
