//
//  ErrorAlertPresenter.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 2/22/22.
//

import Foundation
import SwiftUI

protocol ErrorAlertPresenter {
    var errorMessageState: State<String?> { get set }
    var errorIsPresentedState: State<Bool> { get set }
    func setErrorMessage(_ message: String?)
}

extension ErrorAlertPresenter {
    func setErrorMessage(_ message: String?) {
        errorMessageState.wrappedValue = message
        errorIsPresentedState.wrappedValue = message != nil
    }
    
    func alert() -> Alert {
        Alert(title: Text("Something went wrong"),
              message: Text(errorMessageState.wrappedValue ?? ""),
              dismissButton: .default(Text("OK")))
    }
}
