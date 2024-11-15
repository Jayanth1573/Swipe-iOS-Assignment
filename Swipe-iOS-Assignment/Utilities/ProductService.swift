//
//  ProductService.swift
//  Swipe-iOS-Assignment
//
//  Created by Jayanth Ambaldhage on 15/11/24.
//


import Foundation
import UIKit

struct APIProduct: Codable {
    let image: String
    let price: Double
    let product_name: String
    let product_type: String
    let tax: Double
//    let isFavorite: Bool
}


class ProductService {
    static let shared = ProductService()
    private init() {}
    
    /// The network error related to Product API
    enum NetworkError: String, Error {
        case invalidUrl = "Invalid Url"
        case failedRequest = "Failed request, status code != 200"
    }
    
    func fetchProducts() async throws -> [Product] {
        let url = URL(string: "https://app.getswipe.in/api/public/get")!
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw NetworkError.failedRequest }
        let apiProducts = try JSONDecoder().decode([APIProduct].self, from: data)
        
        return apiProducts.map { apiProduct in
            Product(
                name: apiProduct.product_name,
                type: apiProduct.product_type,
                price: apiProduct.price,
                tax: apiProduct.tax,
                imageUrl: apiProduct.image,
                isFavorite: false
            )
        }
    }
}


