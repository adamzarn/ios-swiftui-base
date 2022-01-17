//
//  PostListItemView.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 11/22/21.
//

import Foundation
import SwiftUI

struct PostListItemView: View {
    var viewModel: PostListItemViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            postHeaderView
            Text(viewModel.text)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .listRowInsets(EdgeInsets())
    }
    
    var postHeaderView: some View {
        HStack {
            ProfilePhotoImageView(user: viewModel.post.user, size: 40)
            postHeaderTextView
            Spacer()
        }
    }
    
    var postHeaderTextView: some View {
        VStack(alignment: .leading) {
            Text(viewModel.name)
                .font(.headline)
                .fontWeight(.bold)
            Text(viewModel.time)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct PostListItem_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: "1",
                        firstName: "Michael",
                        lastName: "Jordan",
                        username: "Air Jordan",
                        email: "mj@gmail.com",
                        profilePhotoUrl: nil,
                        createdAt: "123",
                        updatedAt: "123",
                        isAdmin: true,
                        isEmailVerified: true)
        let post = Post(id: "1",
                        text: "Hello",
                        createdAt: "123",
                        user: user)
        PostListItemView(viewModel: PostListItemViewModel(post: post)).previewLayout(.fixed(width: 375, height: 200))
    }
}

