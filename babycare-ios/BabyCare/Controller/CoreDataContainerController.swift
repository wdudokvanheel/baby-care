import CoreData
import Foundation
import SwiftUI
import UIKit

class CoreDataContainerController: ObservableObject {
    private let container = NSPersistentContainer(name: "DataStore")

    init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }

    func getContext() -> NSManagedObjectContext {
        return container.viewContext
    }

    func deleteAll(entity: String) {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)

        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                guard let objectData = object as? NSManagedObject else { continue }
                context.delete(objectData)
            }
            try context.save()
        } catch {
            print("Detele all data in \(entity) error :", error)
        }
    }

    func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Error while saving context: \(error.localizedDescription)")
        }
    }
}
