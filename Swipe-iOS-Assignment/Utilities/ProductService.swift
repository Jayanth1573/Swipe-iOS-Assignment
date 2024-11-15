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
    
    func addProduct(name: String, type: String, price: Double, tax: Double, image: UIImage?) async throws -> Bool {
        let url = URL(string: "https://app.getswipe.in/api/public/add")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        // Add text fields
        let textFields: [String: String] = [
            "product_name": name,
            "product_type": type,
            "price": String(price),
            "tax": String(tax)
        ]
        
        for (key, value) in textFields {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Add image if available
        if let image = image, let imageData = image.jpegData(compressionQuality: 0.8) {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"files[]\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(imageData)
            data.append("\r\n".data(using: .utf8)!)
        }
        
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = data
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        
        if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
           let success = json["success"] as? Bool {
            return success
        }
        
        return false
    }
}


