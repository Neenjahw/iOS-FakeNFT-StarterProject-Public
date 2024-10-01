import Foundation

typealias OrderCompletion = (Result<Order, Error>) -> Void

protocol OrderServices {
    func loadOrder(completion: @escaping OrderCompletion)
}

final class OrderServiceImpl: OrderServices {
    private let networkClient: NetworkClient
    private let orderStorage: OrderStorage
    
    init(networkClient: NetworkClient, orderStorage: OrderStorage) {
        self.networkClient = networkClient
        self.orderStorage = orderStorage
    }
    
    func loadOrder(completion: @escaping OrderCompletion) {
        if let order = orderStorage.getOrder() {
            completion(.success(order))
            return
        }
        
        let request = OrderRequest()
        networkClient.send(request: request, type: Order.self) { [weak orderStorage] result in
            switch result {
            case.success(let order):
                orderStorage?.saveOrder(order)
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
}

