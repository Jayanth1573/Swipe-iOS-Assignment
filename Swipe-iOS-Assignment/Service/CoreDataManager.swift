//
//  CoreDataManager.swift
//  Swipe-iOS-Assignment
//
//  Created by Jayanth Ambaldhage on 16/11/24.
//

import Foundation
import CoreData

class CoreDataManager {
    // Singleton instance for global access
    static let shared = CoreDataManager()
    
    // Private initializer to ensure singleton usage
    private init() {}
    
    // Lazy initialization of NSPersistentContainer
    lazy var persistentContainer: NSPersistentContainer = {
        // Create a container with the name of your Core Data model
        let container = NSPersistentContainer(name: "ProductModel")
        // Load the persistent stores
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                // If loading fails, crash the app and print the error
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    /// Save the managed object context if there are changes
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // If saving fails, crash the app and print the error
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /// Fetch all products from Core Data and convert them to Product model objects
    func fetchProducts() -> [Product] {
        let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        
        do {
            let results = try persistentContainer.viewContext.fetch(request)
            // Map ProductEntity objects to Product model objects
            return results.map { Product(from: $0) }
        } catch {
            print("Error fetching products: \(error)")
            return []
        }
    }
    
    /// Save or update a product in Core Data
    func saveProduct(_ product: Product) {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        // Create a predicate to find an existing product with the same ID
        request.predicate = NSPredicate(format: "id == %@", product.id as CVarArg)
        
        do {
            let results = try context.fetch(request)
            let entity: ProductEntity
            if let existingEntity = results.first {
                // Update existing entity if found
                entity = existingEntity
            } else {
                // Create new entity if not found
                entity = ProductEntity(context: context)
                entity.id = product.id
            }
            
            // Update entity properties with the product's data
            entity.name = product.name
            entity.type = product.type
            entity.price = product.price
            entity.tax = product.tax
            entity.imageUrl = product.imageUrl
            entity.isFavorite = product.isFavorite
            
            // Save the changes to Core Data
            saveContext()
        } catch {
            print("Error saving product: \(error)")
        }
    }
    
    /// Update the favorite status of a product in Core Data
    func updateFavoriteStatus(for productId: UUID, isFavorite: Bool) {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        // Create a predicate to find the product with the given ID
        request.predicate = NSPredicate(format: "id == %@", productId as CVarArg)
        
        do {
            let results = try context.fetch(request)
            if let entity = results.first {
                // Update the favorite status if the product is found
                entity.isFavorite = isFavorite
                // Save the changes to Core Data
                saveContext()
            }
        } catch {
            print("Error updating favorite status: \(error)")
        }
    }
}
