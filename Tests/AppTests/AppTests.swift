//
//  File.swift
//
//
//  Created by Daniel Romero on 9/26/23.
//

@testable import AppFeature
import SomeClient
import ComposableArchitecture
import XCTest

@MainActor
class AppTests: XCTestCase {

  func test_onAppear_createsInitialModels() async {
    let store = TestStore(
      initialState: .init(),
      reducer: { AppReducer() },
      withDependencies: {
        $0.someDependency.fetch = { return [] }
        $0.someDependency.create = { _ in }
      }
    )
    
    await store.send(.onAppear)
    await store.receive(.initialFetch(.success([])))
    await store.receive(.createInitialModels)
    await store.receive(.modelsLoaded(.success([])))
  }
}
