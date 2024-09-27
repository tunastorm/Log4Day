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
    
    private let resourceManager = ImageManager()
    
    private let realm = {
        do {
            return try? Realm(configuration: RealmConfiguration.getConfig())
        } catch {
            return nil
        }
    }()
    
    func detectRealmURL() {
        print(realm?.configuration.fileURL ?? "")
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
    
    func createLog(_ data: Log, photoDict: [Int:[Photo]], complitionHandler: RepositoryResult) {
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
    
    func searchCompoundedFilter<T:Object>(objet: T.Type, sortKey column: any ManagedObject, acending: Bool = true, compoundPredicate: NSCompoundPredicate, filter: (Query<T>) -> Query<Bool>) -> Results<T>?  {
        return realm?.objects(objet).where(filter).filter(compoundPredicate).sorted(byKeyPath: column.name, ascending: acending)
    }
    
    func updateItem<T:Object>(object: T.Type, value: [String: Any], complitionHandler: RepositoryResult) {
        print(#function, value)
        do {
            try realm?.write {
                realm?.create(object, value: value, update: .modified)
            }
            complitionHandler(.success(RepositoryStatus.updateSuccess))
        } catch {
            complitionHandler(.failure(RepositoryError.updatedFailed))
        }
    }
    
    @available(iOS 16.0, *)
    func deleteItem(_ data: Object, fileName: String? = nil, complitionHandler: RepositoryResult) {
        if let fileName {
            resourceManager.removeImageFromDocument(filename: fileName)
        }
        do {
            try realm?.write {
                realm?.delete(data)
            }
            complitionHandler(.success(RepositoryStatus.deleteSuccess))
        } catch {
            complitionHandler(.failure(RepositoryError.deleteFailed))
        }
    }
    
    func deleteCategory(_ data: Category, completionHandler: RepositoryResult) {
        let logs = data.content
        do {
            try realm?.write {
                logs.forEach { log in
                    log.places.forEach { realm?.delete($0) }
                    log.fourCut.forEach { realm?.delete($0) }
                    realm?.delete(log)
                }
                realm?.delete(data)
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
