//
//  ProductListView.swift
//  Swipe-iOS-Assignment
//
//  Created by Jayanth Ambaldhage on 15/11/24.
//

import SwiftUI

struct ProductListView: View {
    @StateObject private var viewModel = ProductListViewModel()
    @State private var isShowingAddProduct = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.sortedProducts) { product in
                                ProductCard(product: product) {
                                    viewModel.toggleFavorite(for: product)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Products")
            .searchable(text: $viewModel.searchText, prompt: "Search products")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isShowingAddProduct = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddProduct) {
                Text("Add product view")
            }
        }
        .onAppear {
            viewModel.fetchProducts()
        }
    }
}

#Preview {
    ProductListView()
}
