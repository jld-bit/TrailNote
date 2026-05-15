import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs: Set<String> = []

    let premiumProductID = "com.trailnote.premium.yearly"
    let freeTripLimit = 3

    var isPremium: Bool {
        purchasedProductIDs.contains(premiumProductID)
    }

    init() {
        Task {
            await loadProducts()
            await refreshPurchasedProducts()
        }
    }

    func loadProducts() async {
        do {
            products = try await Product.products(for: [premiumProductID])
        } catch {
            print("Failed to load StoreKit products: \(error)")
        }
    }

    func purchasePremium() async throws {
        guard let product = products.first(where: { $0.id == premiumProductID }) else { return }
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            purchasedProductIDs.insert(transaction.productID)
            await transaction.finish()
        case .pending, .userCancelled:
            break
        @unknown default:
            break
        }
    }

    func restore() async {
        for await result in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(result) {
                purchasedProductIDs.insert(transaction.productID)
            }
        }
    }

    private func refreshPurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(result) {
                purchasedProductIDs.insert(transaction.productID)
            }
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let signedType):
            return signedType
        case .unverified:
            throw StoreError.failedVerification
        }
    }

    enum StoreError: Error {
        case failedVerification
    }
}
