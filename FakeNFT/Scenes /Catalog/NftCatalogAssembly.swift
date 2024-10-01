import UIKit

public final class NftCatalogAssembly {
    
    private let servicesAssembler: ServicesAssembly
    
    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }
    
    public func build() -> UIViewController {
        let presenter = NftCatalogPresenterImpl(service: servicesAssembler.nftService)
        let viewController = NftCatalogViewController(presenter: presenter)
        presenter.view = viewController
        viewController.servicesAssembly = servicesAssembler
        return viewController
    }
}
