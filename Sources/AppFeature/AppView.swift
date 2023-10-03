//
//  File.swift
//
//
//  Created by Daniel Romero on 9/26/23.
//

import SomeClient
import Dependencies
import ComposableArchitecture
import SwiftUI
import Foundation

public struct AppReducer: Reducer {
  public struct State: Equatable {
    public var models: [PersistenceModel]
    
    public init(models: [PersistenceModel] = []) {
      self.models = models
    }
  }
  
  public enum Action: Equatable {
    case onAppear
    case initialFetch(TaskResult<[PersistenceModel]>)
    case createInitialModels
    case modelsLoaded(TaskResult<[PersistenceModel]>)
  }
  
  public init() {}
  
  @Dependency(\.someDependency) var someDependency
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          await send(.initialFetch(TaskResult { try await someDependency.fetch() }))
        }
        
      case .initialFetch(.success(let models)):
        if models.isEmpty {
          return .run { send in
            await send(.createInitialModels)
          }
        } else {
          state.models = models
          return .none
        }
        
      case .createInitialModels:
        return .run { send in
          await withThrowingTaskGroup(of: Void.self) { group in
            for _ in 0..<4 {
              group.addTask {
                try await someDependency.create("buzz")
              }
            }
          }
          await send(
            .modelsLoaded(
              TaskResult { try await someDependency.fetch() }
            )
          )
        }
        
      case .modelsLoaded(.success(let models)):
        state.models = models
        return .none
        
      case .initialFetch(.failure):
        return .none
        
      case .modelsLoaded(.failure):
        return .none
      }
    }
  }
}

public struct AppView: View {
  let store: StoreOf<AppReducer>
  @ObservedObject var viewStore: ViewStore<AppReducer.State, AppReducer.Action>
  
  public init(store: Store<AppReducer.State, AppReducer.Action>) {
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })
  }
  
  public var body: some View {
    List(viewStore.models) { model in
      Text(model.foo)
    }
  }
}
