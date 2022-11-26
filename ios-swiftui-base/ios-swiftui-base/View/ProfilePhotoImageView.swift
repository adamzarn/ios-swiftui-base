//
//  ProfilePhotoImageView.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 11/26/21.
//

import Foundation
import SwiftUI
import AZCachedAsyncImage

struct ProfilePhotoImageView: View {
    var user: User?
    @Binding var selectedImage: UIImage?
    var size: CGFloat
    let borderWidth: CGFloat
    @Binding var isEditing: Bool
    let didSelectEdit: (() -> Void)?
    
    init(user: User?,
         selectedImage: Binding<UIImage?> = .constant(nil),
         size: CGFloat,
         borderWidth: CGFloat = 2,
         isEditing: Binding<Bool> = .constant(false),
         didSelectEdit: (() -> Void)? = nil) {
        self.user = user
        self._selectedImage = selectedImage
        self.size = size
        self.borderWidth = borderWidth
        self._isEditing = isEditing
        self.didSelectEdit = didSelectEdit
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(.gray, lineWidth: borderWidth)
                .frame(width: size + borderWidth, height: size + borderWidth, alignment: .center)
                .cornerRadius((size + borderWidth)/2)
            ProfilePhotoContentView(user: user, selectedImage: $selectedImage, size: size)
                .frame(width: size,
                       height: size,
                       alignment: .center)
                .cornerRadius(size/2)
            if isEditing {
                ZStack {
                    Color.gray.cornerRadius(size/8)
                    Button(action: {
                        didSelectEdit?()
                    }, label: {
                        Image(systemName: "camera")
                            .resizable()
                            .tint(.black)
                            .frame(width: size/8, height: size/8)
                    })
                }
                .frame(width: size/4, height: size/4)
                .roundedBorder(cornerRadius: size/8, color: .white, width: 2)
                .offset(x: size/3, y: size/3)
            }
        }
    }
}

struct ProfilePhotoImageView_Previews: PreviewProvider {
    static var previewSize: CGFloat = 300

    static var previews: some View {
        ProfilePhotoImageView(user: User.mock,
                              selectedImage: .constant(nil),
                              size: previewSize,
                              isEditing: .constant(true),
                              didSelectEdit: {})
            .previewLayout(.fixed(width: previewSize, height: previewSize))
    }
}

struct ProfilePhotoContentView: View {
    var user: User?
    @Binding var selectedImage: UIImage?
    var size: CGFloat
    var url: URL? {
        guard let urlString = user?.profilePhotoUrl else { return nil }
        return URL(string: urlString)
    }
    
    var body: some View {
        if let user = user {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                if user.profilePhotoUrl == nil {
                    Text(user.initials)
                        .font(.system(size: size/2.5))
                        .frame(width: size,
                               height: size,
                               alignment: .center)
                        .cornerRadius(size/2)
                        .background(Color.gray)
                } else {
                    AZCachedAsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
        } else {
            Color.gray
        }
        
    }
}
