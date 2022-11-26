//
//  PostListItemViewModel.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 11/26/21.
//

import Foundation

struct PostListItemViewModel {
    var post: Post
    
    var profilePhotoUrl: URL? {
        guard let urlString = post.user.profilePhotoUrl else { return nil }
        return URL(string: urlString)
    }
    
    var name: String {
        return post.user.fullName
    }
    
    var time: String? {
        return post.createdAt.formattedDate()
    }
    
    var text: String {
        return post.text
    }
}
