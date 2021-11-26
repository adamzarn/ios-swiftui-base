//
//  ProfilePhotoImageView.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 11/26/21.
//

import Foundation
import SwiftUI

struct ProfilePhotoImageView: View {
    var url: URL?
    var size: CGFloat
    
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            ProgressView()
        }
        .frame(width: size,
               height: size,
               alignment: .center)
        .cornerRadius(size/2)
    }
}
