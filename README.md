
# Swift-iOS-Assignment

A SwiftUI-based iOS application that lets users view a list of products and add new ones. It uses Core Data for efficient data storage and seamless product management.


## Features

- User-friendly interface for a seamless experience.
- Smooth animations and transitions for a refined experience.
- Supports Dark mode.
- Seamless image selection using ImagePicker.
- Effortless product entry with support for image uploads.
- Reliable and secure API interactions for smooth communication.
- Save and manage favorite products with persistent storage.
- Form Validation.

## Tech Stack

Swift, SwiftUI, CoreData


## Requirements
- Xcode 15+
- iOS 16+
- Swift 6
- Active internet connection
## Installation

Clone my repository:
```bash
  git clone [repository-link]
  cd Swipe-iOS-Assignment
```

Open project in xcode:
```bash
  open Swipe-iOS-Assignment.xcodeproj
```
Build and run the project in xcode 

## Project Structure

```bash
Swipe-iOS-Assignment/
├── Views/
│   ├── AddProductView.swift
│   ├── ProductCard.swift
│   └── ProductListView.swift
├── Models/
│   ├── Product.swift
│   └── ProductModel.xcdatamodeld
├── ViewModels/
│   ├── AddProductViewModel.swift
│   └── ProductListViewModel.swift
├── Service/
│   ├── ProductService.swift
│   └── CoreDataManager.swift
├── Utilities/
│   └── ImagePicker.swift
└── Resources/
    ├── LaunchScreen.storyboard
    └── Assets.xcassets
```
## Usage

#### Adding a New Product

1. Open the app.
2. Tap the "+" button to access the product entry form.
3. Fill in the required details:
- Product Image: Tap the placeholder to select an image from your photo library.
- Product Name: Enter the product's name.
- Product Type: Choose one from the available options.
- Price: Input the product price.
- Tax Percentage: Specify the tax percentage (optional).
4. Tap "Add Product" to save the product.

5. Product image is optional and other fields are mandatory to add new product.
## Error Handling

The app features robust error handling to manage various issues effectively:
- Validation Errors:
    - Empty fields
    - Invalid number formats
- Network Errors:
    - API failures
    - Upload failures
In case of errors, alerts will notify you of the issue, ensuring clear and quick resolution.
## Screenshots

<img src="https://github.com/user-attachments/assets/68a1aba6-4c06-48e4-ad1d-b898d65b0cb1" alt="Screenshot 1" width="200" height="400" />
<img src="https://github.com/user-attachments/assets/04c6385f-a8b4-4478-972f-15fdf69abd7b" alt="Screenshot 2" width="200" height="400" />
<img src="https://github.com/user-attachments/assets/c98f653b-5e74-455c-9de5-774fb46813f4" alt="Screenshot 3" width="200" height="400" />
<img src="https://github.com/user-attachments/assets/a51bec8f-1d81-4439-9160-2ee2073f956c" alt="Screenshot 4" width="200" height="400" />



