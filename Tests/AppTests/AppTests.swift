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

  func test_onAppear_createsInitialModels_1() async {
    let expectedModels: [PersistenceModel] = [.init(foo: "bar")]
    
    let store = TestStore(
      initialState: .init(),
      reducer: { AppReducer() },
      withDependencies: {
        $0.someDependency.fetch = { return [] }
        $0.someDependency.create = { _ in }
      }
    )
    
    await store.send(.onAppear)
    store.dependencies.someDependency.fetch = { return expectedModels }
    await store.receive(.initialFetch(.success([])))
    await store.receive(.createInitialModels)
    await store.receive(.modelsLoaded(.success(expectedModels)))
  }
  
  func test_onAppear_createsInitialModels_2() async {
    let expectedModels: [PersistenceModel] = [.init(foo: "bar")]
    
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
    store.dependencies.someDependency.fetch = { return expectedModels }
    await store.receive(.createInitialModels)
    await store.receive(.modelsLoaded(.success(expectedModels)))
  }
  
  func test_onAppear_createsInitialModels_3() async {
    let expectedModels: [PersistenceModel] = [.init(foo: "bar")]
    
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
    store.dependencies.someDependency.fetch = { return expectedModels }
    await store.receive(.modelsLoaded(.success(expectedModels)))
  }
  
  func test_onAppear_createsInitialModels_4() async {
    let expectedModels: [PersistenceModel] = [.init(foo: "bar")]
    
    let store = TestStore(
      initialState: .init(),
      reducer: { AppReducer() },
      withDependencies: {
        $0.someDependency.fetch = { return [] }
        $0.someDependency.create = { _ in }
      }
    )
    

    await store.send(.onAppear)
    
    await store.withDependencies {
      $0.someDependency.fetch = { return expectedModels }
    } operation: {
      await store.receive(.initialFetch(.success([])))
    }
    
    await store.receive(.createInitialModels)
    await store.receive(.modelsLoaded(.success(expectedModels)))
  }
  
  func test_onAppear_createsInitialModels_5() async {
    let expectedModels: [PersistenceModel] = [.init(foo: "bar")]
    
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
    
    await store.withDependencies {
      $0.someDependency.fetch = { return expectedModels }
    } operation: {
      await store.receive(.createInitialModels)
    }
    
    await store.receive(.modelsLoaded(.success(expectedModels)))
  }
  
  func test_onAppear_createsInitialModels_6() async {
    let expectedModels: [PersistenceModel] = [.init(foo: "bar")]
    
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
    
    await store.withDependencies {
      $0.someDependency.fetch = { return expectedModels }
    } operation: {
      await store.receive(.modelsLoaded(.success(expectedModels)))
    }
  }
}
