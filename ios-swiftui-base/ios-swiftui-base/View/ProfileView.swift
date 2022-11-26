//
//  ProfileView.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 1/6/22.
//

import SwiftUI


class UsersService: ObservableObject {
    @Published var isUploadingProfilePhoto: Bool = false
    
    func uploadProfilePhoto(image: UIImage) async throws {
        guard let data = image.jpegData(compressionQuality: 0.25),
              let request = Endpoint.uploadProfilePhoto(data: data).urlRequest else {
            throw ServiceError.invalidUrlRequest
        }
        do {
            isUploadingProfilePhoto = true
            let (data, response) = try await URLSession.shared.data(for: request)
            if (response as? HTTPURLResponse)?.statusCode == 200 {
                isUploadingProfilePhoto = false
            } else {
                if let exception = try? JSONDecoder().decode(Exception.self, from: data) {
                    isUploadingProfilePhoto = false
                    throw ServiceError.server(exception: exception)
                }
            }
        } catch {
            isUploadingProfilePhoto = false
            throw error
        }
    }
}

enum UserAttribute: String, CaseIterable {
    case firstName = "First Name"
    case lastName = "Last Name"
    case username = "Username"
    case email = "Email"
    case password = "Password"
    case createdAt = "Member Since"
    
    var isEditable: Bool {
        return self != .createdAt
    }
}

@MainActor
class ProfileViewModel: ObservableObject {
    let authService: AuthService
    let usersService: UsersService
    var user: User? {
        didSet {
            firstName = user?.firstName ?? ""
            lastName = user?.lastName ?? ""
            username = user?.username ?? ""
            email = user?.email ?? ""
            password = "************"
        }
    }
    
    @Published var isEditing: Bool = false
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var attributeBeingEdited: UserAttribute?
    
    init(authService: AuthService = AuthService(),
         usersService: UsersService = UsersService()) {
        self.authService = authService
        self.usersService = usersService
    }
}

struct ProfileView: View {
    @EnvironmentObject var currentSession: CurrentSession
    @StateObject var viewModel = ProfileViewModel()
    
    @State var selectedImage: UIImage?
    @State var showingImagePicker: Bool = false

    var body: some View {
        NavigationView {
            List {
                photoItem
                ForEach(UserAttribute.allCases, id: \.self) { attribute in
                    ProfileItem(key: attribute.rawValue,
                                value: getBinding(forAttribute: attribute),
                                originalValue: getValue(forAttribute: attribute),
                                isEditing: attribute.isEditable ? $viewModel.isEditing : Binding.constant(false),
                                attributeBeingEdited: $viewModel.attributeBeingEdited,
                                editAction: {
                        viewModel.attributeBeingEdited = attribute
                    })
                }
            }
            .environment(\.defaultMinListRowHeight, 0)
            .listStyle(.plain)
            .navigationTitle("Profile")
            .toolbar(content: {
                HStack {
                    Button(action: {
                        withAnimation {
                            viewModel.attributeBeingEdited = nil
                            viewModel.isEditing.toggle()
                        }
                    }, label: {
                        viewModel.isEditing ? Text("Done").bold() : Text("Edit")
                    })
                    LogoutButton(authService: viewModel.authService).environmentObject(currentSession)
                }
            })
        }
        .sheet(isPresented: $showingImagePicker) {
            PHPickerView(image: $selectedImage)
        }
        .onAppear {
            viewModel.user = currentSession.user
        }
    }
    
    var photoItem: some View {
        HStack {
            Spacer()
            ProfilePhotoImageView(user: currentSession.user,
                                  selectedImage: $selectedImage,
                                  size: 120,
                                  isEditing: $viewModel.isEditing,
                                  didSelectEdit: {
                showingImagePicker = true
            })
            Spacer()
        }
        .listRowSeparator(.hidden)
        .padding(.vertical, 16)
        .buttonStyle(.plain)
    }
    
    func getValue(forAttribute attribute: UserAttribute) -> String {
        guard let user = currentSession.user else { return "" }
        switch attribute {
        case .firstName: return user.firstName
        case .lastName: return user.lastName
        case .username: return user.username
        case .email: return user.email
        case .password: return "************"
        default: return ""
        }
    }
    
    func getBinding(forAttribute attribute: UserAttribute) -> Binding<String> {
        switch attribute {
        case .firstName: return $viewModel.firstName
        case .lastName: return $viewModel.lastName
        case .username: return $viewModel.username
        case .email: return $viewModel.email
        case .password: return $viewModel.password
        case .createdAt: return Binding.constant(currentSession.user?.createdAt.formattedDate() ?? "")
        }
    }
}

struct ProfileItem: View {
    var key: String
    @Binding var value: String
    let originalValue: String
    @Binding var isEditing: Bool
    @Binding var attributeBeingEdited: UserAttribute?
    var editAction: (() -> Void)?
    
    init(key: String,
         value: Binding<String>,
         originalValue: String,
         isEditing: Binding<Bool>,
         attributeBeingEdited: Binding<UserAttribute?>,
         editAction: (() -> Void)?) {
        self.key = key
        self._value = value
        self.originalValue = originalValue
        self._isEditing = isEditing
        self._attributeBeingEdited = attributeBeingEdited
        self.editAction = editAction
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(key.uppercased())
                    .font(.subheadline)
                    .fontWeight(.bold)
                Spacer()
                if attributeBeingEdited?.rawValue == key {
                    EmptyView()
                } else {
                    Text(value)
                        .font(.subheadline)
                        .transition(.move(edge: .trailing))
                }
                if let editAction = editAction, isEditing {
                    if attributeBeingEdited?.rawValue == key {
                        EmptyView()
                    } else {
                        Button(action: editAction, label: {
                            Image(systemName: "pencil").renderingMode(.template).foregroundColor(.blue)
                        }).transition(AnyTransition.opacity.combined(with: .move(edge: .trailing)))
                    }
                }
            }.padding()
            if attributeBeingEdited?.rawValue == key {
                HStack {
                    TextField("Value", text: $value, prompt: Text(key)).textFieldStyle(.roundedBorder)
                    Button("Cancel", action: {
                        value = originalValue
                        attributeBeingEdited = nil
                    }).foregroundColor(.blue)
                    Button("Submit", action: {
                        value = originalValue
                        attributeBeingEdited = nil
                    }).foregroundColor(.blue)
                }
                .padding([.leading, .trailing, .bottom])
            }
            Color.gray.frame(height: 0.5)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
        .buttonStyle(.plain)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: "77155B07-E1A9-46AD-86EF-066544947A33",
                        firstName: "Michael",
                        lastName: "Jordan",
                        username: "Air Jordan",
                        email: "mj@gmail.com",
                        profilePhotoUrl: nil,
                        createdAt: "2021-11-04T00:17:01Z",
                        updatedAt: "2021-11-04T00:17:37Z",
                        isAdmin: false,
                        isEmailVerified: true)
        let currentSession = CurrentSession(defaults: MockUserDefaults(user: user))
        ProfileView().environmentObject(currentSession)
    }
}

struct ProfileItem_Previews: PreviewProvider {
    static var previews: some View {
        ProfileItem(key: "Name",
                    value: Binding.constant("Michael"),
                    originalValue: "Michael",
                    isEditing: Binding.constant(false),
                    attributeBeingEdited: Binding.constant(.firstName),
                    editAction: {})
            .previewLayout(.fixed(width: 375, height: 44))
    }
}
