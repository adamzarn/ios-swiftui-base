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
    
    var time: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = formatter.date(from: post.createdAt) else { return "" }
        formatter.dateFormat = "M/d/yy h:mm aa"
        return formatter.string(from: date).lowercased()
    }
    
    var text: String {
        return post.text
    }
}
