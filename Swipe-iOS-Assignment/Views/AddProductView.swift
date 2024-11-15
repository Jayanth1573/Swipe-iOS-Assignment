//
//  AddProductView.swift
//  Swipe-iOS-Assignment
//
//  Created by Jayanth Ambaldhage on 15/11/24.
//

import SwiftUI

struct AddProductView: View {
    @StateObject private var viewModel = AddProductViewModel()
    @Environment(\.presentationMode) var presentationMode
    var onProductAdded: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                // MARK: New Image
                Section(header: Text("Product Image")) {
                    ZStack {
                        if let image = viewModel.selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 200)
                            
                            Image(systemName: "photo.badge.plus")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                        }
                    }
                    .onTapGesture {
                        viewModel.isShowingImagePicker = true
                    }
                }
                
                // MARK: New Properties
                Section(header: Text("Product Details")) {
                    TextField("Product Name", text: $viewModel.productName)
                    
                    Picker("Product Type", selection: $viewModel.productType) {
                        ForEach(viewModel.productTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    
                    TextField("Price", text: $viewModel.price)
                        .keyboardType(.decimalPad)
                    
                    TextField("Tax (%)", text: $viewModel.tax)
                        .keyboardType(.decimalPad)
                }
                
                
                // MARK: Addition button
                Section {
                    Button(action: {
                        Task {
                            let success = await viewModel.addProduct()
                            if success {
                                onProductAdded()
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }) {
                        Text("Add Product")
                            .frame(maxWidth: .infinity)
                    }
//                    .disabled(!viewModel.isFormValid)
                }
            }
            .navigationTitle("Add Product")
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Message"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $viewModel.isShowingImagePicker) {
                ImagePicker(image: $viewModel.selectedImage)
            }
        }
    }
}

struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView(onProductAdded: {})
    }
}
