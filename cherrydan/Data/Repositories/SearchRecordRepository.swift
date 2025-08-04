import Foundation

protocol SearchRecordRepositoryProtocol {
    func getSearchRecords() throws -> [SearchRecord]
    func saveSearchResult(_ text: String) throws
    func deleteSearchResult(_ id: String) throws
}

class SearchRecordRepository: SearchRecordRepositoryProtocol {
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
    }
    
    func getSearchRecords() throws -> [SearchRecord] {
        let request = SearchRecordEntity.fetchRequest()
        
        let entities = try coreDataStack.context.fetch(request)
        return entities.map { entity in
            SearchRecord(
                id: entity.id ?? "",
                text: entity.text ?? "",
                createdAt: entity.createdAt ?? ""
            )
        }
    }
    
    func saveSearchResult(_ text: String) throws {
        try coreDataStack.performInTransaction {
            let entity = SearchRecordEntity(context: coreDataStack.context)
            entity.id = UUID().uuidString
            entity.text = text
            entity.createdAt = Date().ISO8601Format()
        }
    }
    
    func deleteSearchResult(_ id: String) throws {
        try coreDataStack.performInTransaction {
            let request = SearchRecordEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id)
            if let entity = try coreDataStack.context.fetch(request).first {
                coreDataStack.context.delete(entity)
            }
        }
    }
}
