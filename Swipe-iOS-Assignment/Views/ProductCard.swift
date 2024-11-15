//
//  ProductCard.swift
//  Swipe-iOS-Assignment
//
//  Created by Jayanth Ambaldhage on 15/11/24.
//

import SwiftUI

struct ProductCard: View {
    let product: Product
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // MARK: Image
            Group {
                if let url = URL(string: product.imageUrl), !product.imageUrl.isEmpty {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            defaultImage
                        default:
                            defaultImage
                        }
                    }
                } else {
                    defaultImage
                }
            }
            .frame(height: 200)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            
            // MARK: properties
            HStack {
                Text(product.name)
                    .font(.headline)
                Spacer()
                Button(action: onFavoriteToggle) {
                    Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(product.isFavorite ? .red : .gray)
                }
                .accessibilityLabel(product.isFavorite ? "Remove from favorites" : "Add to favorites")
            }
            
            Text(product.type)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Text("Price: ₹\(String(format: "%.2f", product.price))")
                    .font(.subheadline)
                Spacer()
                Text("Tax: \(String(format: "%.1f%%", product.tax))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
    
    // MARK: Default Image
    private var defaultImage: some View {
        Image("noImage")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .foregroundColor(.gray)
            .frame(height: 200)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.gray.opacity(0.1))
            .accessibilityLabel("Default product image")
    }

}

struct ProductCard_Previews: PreviewProvider {
    static var sampleProduct = Product(
        name: "Sample Product",
        type: "Electronics",
        price: 299.99,
        tax: 18.0,
        imageUrl: "https://example.com/sample-product.jpg",
        isFavorite: false
    )
    
    static var previews: some View {
        VStack {
            ProductCard(product: sampleProduct) {
                print("Favorite toggled")
            }
            
            ProductCard(product: Product(
                name: "Another Product",
                type: "Clothing",
                price: 59.99,
                tax: 10.0,
                imageUrl: "",
                isFavorite: true
            )) {
                print("Favorite toggled")
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .background(Color.gray.opacity(0.1))
    }
}
