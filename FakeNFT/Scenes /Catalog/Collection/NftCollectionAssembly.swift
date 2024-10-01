import UIKit

public final class NftCollectionAssembly {
    
    private let servicesAssembler: ServicesAssembly
    
    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }
    
    public func build(with id: String) -> UIViewController {
        let presenter = NftCollectionPresenterImpl(
            service: servicesAssembler.nftService,
            editProfileServices: servicesAssembler.editProfileServices,
            profileService: servicesAssembler.profileService,
            orderService: servicesAssembler.orderServices,
            editOrderService: servicesAssembler.editOrderServices,
            nftCollectionId: id)
        
        let viewController = NftCollectionViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
