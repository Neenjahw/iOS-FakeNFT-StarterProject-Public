import Foundation

protocol OrderStorage: AnyObject {
    func saveOrder(_ order: Order)
    func getOrder() -> Order?
}

final class OrderStorageImpl: OrderStorage {
    private var order: Order?
    
    private let syncQueue = DispatchQueue(label: "sync-order-queue")
    
    func saveOrder(_ order: Order) {
        syncQueue.async { [weak self] in
            self?.order = order
        }
    }
    
    func getOrder() -> Order? {
        syncQueue.sync {
            order
        }
    }
}
