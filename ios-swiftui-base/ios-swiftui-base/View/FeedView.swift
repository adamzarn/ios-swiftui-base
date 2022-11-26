//
//  FeedView.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 11/22/21.
//

import SwiftUI

struct FeedView: View, ErrorAlertPresenter {
    @EnvironmentObject var currentSession: CurrentSession
    @StateObject var viewModel = FeedViewModel()
    
    var errorMessageState: State<String?> = State(initialValue: nil)
    var errorIsPresentedState: State<Bool> = State(initialValue: false)
    
    var body: some View {
        NavigationView {
            FeedContentView(isLoading: viewModel.isLoading, feed: viewModel.feed)
                .task { await getFeed() }
                .navigationTitle("Feed")
                .toolbar(content: {
                    LogoutButton(authService: viewModel.authService).environmentObject(currentSession)
                })
                .alert(isPresented: errorIsPresentedState.projectedValue, content: alert)
        }
    }
    
    func getFeed() async {
        do {
            try await viewModel.getFeed()
        } catch {
            if let error = error as? ServiceError {
                switch error {
                case .server(let exception): setErrorMessage(exception.reason)
                case .couldNotDecodeResponse(let message): setErrorMessage(message)
                default: setErrorMessage(nil)
                }
            }
        }
    }
}

struct FeedContentView: View {
    var isLoading: Bool
    var feed: [Post]
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                List {
                    ForEach(feed, id: \.id) { post in
                        PostListItemView(viewModel: PostListItemViewModel(post: post))
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
