//
//  File.swift
//
//
//  Created by Daniel Romero on 9/26/23.
//

import CoreData
import Dependencies
import Foundation

public protocol PersistenceConvertible {
  associatedtype Object: ModelConvertible
  
  @discardableResult
  func convert() -> Object
}

public protocol ModelConvertible {
  associatedtype Model: PersistenceConvertible
  
  func convert() -> Model
}

public protocol ValueFetchedDatabaseProviding {
  associatedtype Model: PersistenceConvertible
  associatedtype Object: ModelConvertible where Object.Model == Model
  associatedtype HashableType: Hashable
  
  var fetchAllByValue: (HashableType) async throws -> [Object.Model] { get set }
}

public class PersistenceObject {
  public var foo: String
  
  public init(foo: String) {
    self.foo = foo
  }
}

public struct PersistenceModel: Identifiable, Equatable {
  public var id = UUID()
  public var foo: String
  
  public init(foo: String) {
    self.foo = foo
  }
}

extension PersistenceObject: ModelConvertible {
  public typealias Model = PersistenceModel
  
  public func convert() -> PersistenceModel {
    return Model.init(foo: self.foo)
  }
}

extension PersistenceModel: PersistenceConvertible {
  public typealias Object = PersistenceObject
  
  public func convert() -> PersistenceObject {
    return .init(foo: self.foo)
  }
}

public struct ValueFetchedDatabaseClient<Model: PersistenceConvertible, Object: ModelConvertible, HashableType: Hashable>: ValueFetchedDatabaseProviding where Object.Model == Model {
  public var fetchAllByValue: (HashableType) async throws -> [Object.Model]
  
  public init(fetchAllByValue: @escaping (HashableType) async throws -> [Object.Model]) {
    self.fetchAllByValue = fetchAllByValue
  }
}

extension ValueFetchedDatabaseClient {
  public static func live() -> Self {
    return .init { _ in
      return []
    }
  }
}

// MARK: - Production code
extension ValueFetchedDatabaseClient where Model == PersistenceModel, Object == PersistenceObject, HashableType == String {
  public var fetchAllByValue: (String) async throws -> [Object.Model] {
    return { bar in
      return [.init(foo: "Entry 1")]
    }
  }
}

extension ValueFetchedDatabaseClient: TestDependencyKey where Model == PersistenceModel, Object == PersistenceObject, HashableType == String {
  public static var testValue: ValueFetchedDatabaseClient<Model, Object, HashableType> {
    return .noop()
  }
}

extension ValueFetchedDatabaseClient: DependencyKey where Model == PersistenceModel, Object == PersistenceObject, HashableType == String {
  public static var liveValue: ValueFetchedDatabaseClient<Model, Object, HashableType> {
    return .live()
  }
}

extension DependencyValues {
  public var someClient: ValueFetchedDatabaseClient<PersistenceModel, PersistenceObject, String> {
    get { self[ValueFetchedDatabaseClient<PersistenceModel, PersistenceObject, String>.self] }
    set { self[ValueFetchedDatabaseClient<PersistenceModel, PersistenceObject, String>.self] = newValue }
  }
}

// MARK: - Test code
extension ValueFetchedDatabaseClient where Model == PersistenceModel, Object == PersistenceObject, HashableType == String {
  public static func noop() -> Self {
    return .init(fetchAllByValue: { _ in return [] })
  }
}
