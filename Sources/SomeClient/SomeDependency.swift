//
//  File.swift
//
//
//  Created by Daniel Romero on 10/3/23.
//

import Dependencies
import Foundation

public struct SomeDependency {
  public var fetch: () async throws -> [PersistenceModel]
  public var create: (String) async throws -> Void
  
  public init(
    fetch: @escaping () -> [PersistenceModel],
    create: @escaping (String) async throws -> Void
  ) {
    self.fetch = fetch
    self.create = create
  }
}

extension SomeDependency {
  public static var live: Self {
    return .init(
      fetch: { return [.init(foo: "bar"), .init(foo: "baz")]},
      create: { _ in }
    )
  }
}

extension SomeDependency {
  public static var noop: Self {
    return .init(
      fetch: { return [] },
      create: { _ in }
    )
  }
}

extension SomeDependency: TestDependencyKey {
  public static var testValue: SomeDependency {
    return .noop
  }
}

extension SomeDependency: DependencyKey {
  public static var liveValue: SomeDependency {
    return .live
  }
}

extension DependencyValues {
  public var someDependency: SomeDependency {
    get { self[SomeDependency.self] }
    set { self[SomeDependency.self] = newValue }
  }
}
