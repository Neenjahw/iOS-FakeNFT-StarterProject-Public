import Foundation

typealias EditOrderCompletion = (Result<Order, Error>) -> Void

protocol EditOrderService {
    func sendEditOrderRequest(
        nfts: [String]?,
        id: String?,
        completion: @escaping EditOrderCompletion
    )
}

final class EditOrderServiceImpl: EditOrderService {
    private let networkClient: NetworkClient
    private let orderStorage: OrderStorage
    
    init(networkClient: NetworkClient, orderStorage: OrderStorage) {
        self.networkClient = networkClient
        self.orderStorage = orderStorage
    }
    
    func sendEditOrderRequest(
        nfts: [String]?,
        id: String?,
        completion: @escaping EditOrderCompletion
    ) {
        let dto = EditOrderDtoObject(
            nfts: nfts,
            id: id)
        let request = EditOrderRequest(dto: dto)
        networkClient.send(request: request, type: Order.self) { [weak self] result in
            switch result {
            case .success(let order):
                self?.orderStorage.saveOrder(order)
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
