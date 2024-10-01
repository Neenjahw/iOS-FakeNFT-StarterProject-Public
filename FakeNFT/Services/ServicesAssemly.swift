final class ServicesAssembly {
    
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let profileStorage: ProfileStorage
    
    let orderService = OrderService()
    let paymentService = PaymentService()
    
    private let nftCollectionsStorage: NftCollectionsStorage
    private let orderStorage: OrderStorage
    
    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        nftCollectionsStorage: NftCollectionsStorage,
        profileStorage: ProfileStorage,
        orderStorage: OrderStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.profileStorage = profileStorage
        self.nftCollectionsStorage = nftCollectionsStorage
        self.orderStorage = orderStorage
    }
    
    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage, 
            collectionsStorage: nftCollectionsStorage
        )
    }
    
    var editProfileServices: EditProfileServices {
        EditProfileServicesImpl(
            networkClient: networkClient,
            profileStorage: profileStorage
        )
    }
    
    var profileService: ProfileService {
        ProfileServiceImpl(
            networkClient: networkClient,
            profileStorage: profileStorage
        )
    }
    
    var orderServices: OrderServices {
        OrderServiceImpl(
            networkClient: networkClient,
            orderStorage: orderStorage
        )
    }
    
    var editOrderServices: EditOrderService {
        EditOrderServiceImpl(
            networkClient: networkClient,
            orderStorage: orderStorage
        )
    }
}
