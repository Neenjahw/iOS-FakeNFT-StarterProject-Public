import UIKit

//MARK: - AuthorPageViewController
final class AuthorPageViewController: UIViewController {
    
    //MARK: - UIModels
    private lazy var backwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .chevron), for: .normal)
        button.addTarget(self, action: #selector(backToNftCollectionViewController), for: .touchUpInside)
        return button
    }()
    
    private lazy var authorPagePlaceholder: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(resource: .authorPagePlaceholder)
        return imageView
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        setupViews()
        setupConstraints()
        super.viewDidLoad()
    }
    
    //MARK: - Private methods
    @objc private func backToNftCollectionViewController() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - AutoLayout
extension AuthorPageViewController {
    private func setupViews() {
        [backwardButton,
         authorPagePlaceholder].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view?.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backwardButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backwardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            
            authorPagePlaceholder.topAnchor.constraint(equalTo: backwardButton.bottomAnchor, constant: 40),
            authorPagePlaceholder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            authorPagePlaceholder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            authorPagePlaceholder.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
