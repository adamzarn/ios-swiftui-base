//
//  ProfilePhotoImageView.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 11/26/21.
//

import Foundation
import SwiftUI

struct ProfilePhotoImageView: View {
    var user: User
    var size: CGFloat
    let borderWidth: CGFloat = 2
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(.gray, lineWidth: borderWidth)
                .frame(width: size + borderWidth, height: size + borderWidth, alignment: .center)
                .cornerRadius((size + borderWidth)/2)
            ProfilePhotoContentView(user: user, size: size)
                .frame(width: size,
                       height: size,
                       alignment: .center)
                .cornerRadius(size/2)
        }
    }
}

struct ProfilePhotoContentView: View {
    var user: User
    var size: CGFloat
    var url: URL? {
        guard let urlString = user.profilePhotoUrl else { return nil }
        return URL(string: urlString)
    }
    
    var body: some View {
        if user.profilePhotoUrl == nil {
            Text("MJ").background(Color.gray)
        } else {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
        }
    }
}
