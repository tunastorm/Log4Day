//
//  Repository.swift
//  Log4Day
//
//  Created by 유철원 on 9/21/24.
//

import Foundation
import RealmSwift

final class Repository {
    
    typealias RepositoryResult = (Result<RepositoryStatus, RepositoryError>) -> Void
    typealias propertyhandler = () -> Void
    
    static let shared = Repository()
    
    private let photoManager = PhotoManager()
    
    private let realm = {
        do {
            return try? Realm(configuration: RealmConfiguration.getConfig())
        } catch {
            return nil
        }
    }()
    
    func detectRealmURL() {
//        print(realm?.configuration.fileURL ?? "")
    }

    func createItem(_ data: Object, complitionHandler: RepositoryResult) {
        do {
            try realm?.write {
                realm?.add(data)
            }
            complitionHandler(.success(RepositoryStatus.createSuccess))
        } catch {
            complitionHandler(.failure(RepositoryError.createFailed))
        }
    }
    
    func fetchItem<T:Object>(object: T.Type, primaryKey: ObjectId) -> T? {
        return realm?.object(ofType: object, forPrimaryKey: primaryKey)
    }
    
    func fetchAll<T: Object>(obejct: T.Type, sortKey column: any ManagedObject, acending: Bool = true) -> Results<T>? {
        return realm?.objects(obejct).sorted(byKeyPath: column.name, ascending: acending)
    }
    
    func fetchAllFiltered<T: Object>(obejct: T.Type, sortKey column: any ManagedObject, acending: Bool = true, query: @escaping (Query<T>) -> Query<Bool>) -> Results<T>? {
        return realm?.objects(obejct).where(query).sorted(byKeyPath: column.name, ascending: acending)
    }

    func deleteCategory(_ data: Category, completionHandler: RepositoryResult) {
        let logs = data.content
        do {
            try realm?.write { [weak self] in
                logs.forEach { log in
                    log.places.forEach { self?.realm?.delete($0) }
                    log.fourCut.forEach {
                        self?.photoManager.removeImageFromDocument(filename: $0.name)
                        self?.realm?.delete($0)
                    }
                    self?.realm?.delete(log)
                }
                self?.realm?.delete(data)
            }
            completionHandler(.success(RepositoryStatus.deleteSuccess))
        } catch {
            completionHandler(.failure(RepositoryError.deleteFailed))
        }
    }
    
    func deleteLog(_ log: Log, completionHandler: RepositoryResult) {
        do {
            try realm?.write { [weak self] in
                log.places.forEach{ self?.realm?.delete($0) }
                log.fourCut.forEach {
                    self?.photoManager.removeImageFromDocument(filename: $0.name)
                    self?.realm?.delete($0)
                }
                self?.realm?.delete(log)
            }
            completionHandler(.success(RepositoryStatus.deleteSuccess))
        } catch {
            completionHandler(.failure(RepositoryError.deleteFailed))
            
        }
    }
    
    func queryProperty(queryHandeler: propertyhandler, completionHandler: RepositoryResult) {
        do {
            try realm?.write {
                queryHandeler()
            }
            completionHandler(.success(RepositoryStatus.updateSuccess))
        } catch {
            completionHandler(.failure(RepositoryError.updatedFailed))
        }
    }
}
