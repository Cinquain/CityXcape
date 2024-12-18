//
//  Store.swift
//  CityXcape
//
//  Created by James Allan on 10/17/24.
//

import Foundation
import StoreKit


typealias FetchCompletionHandler = (([SKProduct]) -> Void)
typealias PurchaseCompletionHandler = ((SKPaymentTransaction?) -> Void)

final class Store: NSObject, ObservableObject {
    
    static let shared = Store()
    
    override init() {
        super.init()
        fetchProducts { product in
            print(product)
        }
    }
    
    private let productIdentifiers = Set(Product.allCases.compactMap({$0.rawValue}))
    private var fetchCompletionHandler: FetchCompletionHandler?
    private var purchaseCompletionHandler: PurchaseCompletionHandler?
    
    
    private var productRequest: SKProductsRequest?
    private var fetchedProducts: [SKProduct] = []
    private var completedPurchases: [String] = []
    
    
    private func startObservingPaymentQueue() {
        SKPaymentQueue.default().add(self)
    }
    
    func product(for identifier: String) -> SKProduct? {
        return fetchedProducts.first(where: {$0.productIdentifier == identifier})
    }
    
    func fetchProducts(_ completion: @escaping FetchCompletionHandler) {
        guard self.productRequest == nil else {return}
        fetchCompletionHandler = completion
        productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest?.delegate = self
        productRequest?.start()
    }
    
    func buy(_ product: SKProduct, completion: @escaping PurchaseCompletionHandler) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        purchaseCompletionHandler = completion
    }
    
    
    func purchaseProduct(_ product: SKProduct, completion: @escaping (Result<Bool, CustomError>) -> Void) {
        startObservingPaymentQueue()
        buy(product) { transaction in
            if transaction?.transactionState == .purchased {
                print("Product purchased successfully!")
                completion(.success(true))
            } else {
                print("Transaction Failed")
                completion(.failure(.failedPurchase))
            }
        }
    }
    
}


extension Store: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            var shouldFinishTransaction = false
            
            switch transaction.transactionState {
                case .purchased, .restored:
                    completedPurchases.append(transaction.payment.productIdentifier)
                    shouldFinishTransaction = true
                case .failed:
                    shouldFinishTransaction = true
                case .deferred, .purchasing:
                    break
            }
            
            if shouldFinishTransaction {
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.purchaseCompletionHandler?(transaction)
                    self.purchaseCompletionHandler = nil
                }
            }
            //End of transaction loop
        }
    }
}


extension Store: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let loadedProducts = response.products
        let invalidProducts = response.invalidProductIdentifiers
        
        guard !loadedProducts.isEmpty else {
            print("Could not load products")
            if !invalidProducts.isEmpty {
                print("Found invalid products: \(invalidProducts)")
            }
            return
        }
        fetchedProducts = loadedProducts
        DispatchQueue.main.async {
            self.fetchCompletionHandler?(loadedProducts)
            self.fetchCompletionHandler = nil
            self.productRequest = nil
        }
    }
}


