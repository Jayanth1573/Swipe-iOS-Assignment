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
    
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products
        } else {
            return products.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var sortedProducts: [Product] {
        filteredProducts.sorted { $0.isFavorite && !$1.isFavorite }
    }
    
    func fetchProducts() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedProducts = try await ProductService.shared.fetchProducts()
                self.products = fetchedProducts
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func toggleFavorite(for product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index].isFavorite.toggle()
        }
    }
}
