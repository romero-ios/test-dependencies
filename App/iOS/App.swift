//
//  test_dependenciesApp.swift
//  test dependencies
//
//  Created by Daniel Romero on 9/26/23.
//


import AppFeature
import ComposableArchitecture
import SwiftUI

let store = Store(initialState: .init(), reducer: { AppReducer() })

@main
struct test_dependenciesApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(store: store)
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}
