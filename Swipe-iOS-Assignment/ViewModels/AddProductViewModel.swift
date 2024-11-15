//
//  AddProductViewModel.swift
//  Swipe-iOS-Assignment
//
//  Created by Jayanth Ambaldhage on 15/11/24.
//

import Foundation
import SwiftUI

@MainActor
class AddProductViewModel: ObservableObject {
    @Published var productName = ""
    @Published var productType = "Food"
    @Published var price = ""
    @Published var tax = ""
    @Published var selectedImage: UIImage?
    
    @Published var isShowingImagePicker = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    let productTypes = ["Food", "Fashion", "Phone","Electronics", "Home", "Beauty", "Sports", "Other"]
    
    var isFormValid: Bool {
        !productName.isEmpty && !price.isEmpty && !tax.isEmpty &&
        Double(price) != nil && Double(tax) != nil
    }
    
    func addProduct() async -> Bool {
        guard isFormValid,
              let price = Double(price),
              let tax = Double(tax) else {
            alertMessage = "Please fill in all required fields with valid information."
            showAlert = true
            return false
        }
        
        do {
            let success = try await ProductService.shared.addProduct(
                name: productName,
                type: productType,
                price: price,
                tax: tax,
                image: selectedImage
            )
            
            if success {
                alertMessage = "Product added successfully!"
                resetForm()
            } else {
                alertMessage = "Failed to add product. Please try again."
            }
            
            showAlert = true
            return success
        } catch {
            alertMessage = "Error: \(error.localizedDescription)"
            showAlert = true
            return false
        }
    }
    
    private func resetForm() {
        productName = ""
        productType = "Food"
        price = ""
        tax = ""
        selectedImage = nil
    }
}



