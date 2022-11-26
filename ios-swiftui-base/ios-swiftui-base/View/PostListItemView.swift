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
            postTextView
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
            OptionalText(viewModel.time)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    var postTextView: some View {
        Text(viewModel.text)
            .font(.subheadline)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct PostListItem_Previews: PreviewProvider {
    static var previews: some View {
        let post = Post(id: "1",
                        text: "Hello",
                        createdAt: "2021-11-04T00:17:01Z",
                        user: User.mock)
        let viewModel = PostListItemViewModel(post: post)
        PostListItemView(viewModel: viewModel)
            .previewLayout(.fixed(width: 375, height: 100))
    }
}

