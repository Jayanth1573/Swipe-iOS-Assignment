//
//  ProductListViewModel.swift
//  Swipe-iOS-Assignment
//
//  Created by Jayanth Ambaldhage on 15/11/24.
//


import Foundation
import SwiftUI

@MainActor
class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let productService = ProductService.shared
    private let coreDataManager = CoreDataManager.shared
    
    // Computed property to filter products based on search text
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products
        } else {
            return products.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    // Computed property to sort products, with favorites at the top
    var sortedProducts: [Product] {
        filteredProducts.sorted { $0.isFavorite && !$1.isFavorite }
    }
    
    /// Function to fetch products from Core Data and API
    func fetchProducts() {
        isLoading = true
        errorMessage = nil
        
        // First, load saved products from Core Data
        self.products = coreDataManager.fetchProducts()
        
        Task {
            do {
                // Then, fetch products from API
                let fetchedProducts = try await productService.fetchProducts()
                
                // Update existing products and add new ones
                for fetchedProduct in fetchedProducts {
                    if let index = self.products.firstIndex(where: { $0.name == fetchedProduct.name }) {
                        // Update existing product, preserving favorite status
                        var updatedProduct = self.products[index]
                        updatedProduct.name = fetchedProduct.name
                        updatedProduct.type = fetchedProduct.type
                        updatedProduct.price = fetchedProduct.price
                        updatedProduct.tax = fetchedProduct.tax
                        updatedProduct.imageUrl = fetchedProduct.imageUrl
                        // isFavorite is not updated, preserving local changes
                        self.products[index] = updatedProduct
                        coreDataManager.saveProduct(updatedProduct)
                    } else {
                        // Add new product
                        let newProduct = Product(id: fetchedProduct.id,
                                                 name: fetchedProduct.name,
                                                 type: fetchedProduct.type,
                                                 price: fetchedProduct.price,
                                                 tax: fetchedProduct.tax,
                                                 imageUrl: fetchedProduct.imageUrl,
                                                 isFavorite: false)
                        self.products.append(newProduct)
                        coreDataManager.saveProduct(newProduct)
                    }
                }
                
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    /// Function to toggle the favorite status of a product
    func toggleFavorite(for product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index].isFavorite.toggle()
            coreDataManager.updateFavoriteStatus(for: product.id, isFavorite: products[index].isFavorite)
            objectWillChange.send()
        }
    }
    
    /// Function to add a new product to the list and save it to Core Data
    func addProduct(_ product: Product) {
        products.append(product)
        coreDataManager.saveProduct(product)
    }
}


