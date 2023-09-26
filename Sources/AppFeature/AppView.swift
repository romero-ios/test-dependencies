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
        public var title: String

        public init(title: String = "") {
            self.title = title
        }
    }

    public enum Action: Equatable {
        case onAppear
        case someClient(TaskResult<[PersistenceModel]>)
    }

    public init() {}

    @Dependency(\.someClient) var someClient

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.title = "Hello, World!"
                return .run { send in
                    await send(.someClient(TaskResult { try await someClient.fetchAllByValue("foo") }))
                }

            case let .someClient(.success(entries)):
                print(entries)
                return .none

            case let .someClient(.failure(error)):
                print(error)
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
        Text(viewStore.title)
    }
}
