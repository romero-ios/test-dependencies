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

    func test_someClient_invokesProductionCode_asExpected() async {
        let expectedModels: [PersistenceModel] = [
            .init(foo: "Entry 1")
        ]

        let testStore = TestStore(
            initialState: .init(),
            reducer: { AppReducer() }
        )

        await testStore.send(.onAppear) {
            $0.title = "Hello, World!"
        }

        await testStore.receive(.someClient(.success(expectedModels)))
    }

    /*
     The .noop() dependency just returns an empty array, but the production code is executed.
     The inline mocked dependency will also not work in the second test case below.
     */

    func test_someClient_invokesTestCode_butFailsToDoSo() async {
        let testStore = TestStore(
            initialState: .init(),
            reducer: { AppReducer() },
            withDependencies: {
                $0.someClient = .noop()
            }
        )

        await testStore.send(.onAppear) {
            $0.title = "Hello, World!"
        }

        await testStore.receive(.someClient(.success([])))
    }

    func test_someClient_invokesTestCode_butFailsToDoSo2() async {
        let expectedModels: [PersistenceModel] = [
            .init(foo: "Test Entry")
        ]

        let testStore = TestStore(
            initialState: .init(),
            reducer: { AppReducer() },
            withDependencies: {
                $0.someClient.fetchAllByValue = { _ in
                    return [PersistenceModel(foo: "Test Entry")]
                }
            }
        )

        await testStore.send(.onAppear) {
            $0.title = "Hello, World!"
        }

        await testStore.receive(.someClient(.success(expectedModels)))
    }
}
