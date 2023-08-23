import UIKit



final class OnboardingViewController: UIViewController {
    
    var pageIndex: Int
    
    private let text: String
    private let image: UIImage
    
    private lazy var backroungImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(model: OnboardingModel, index: Int) {
        self.pageIndex = index
        self.text = model.text
        self.image = UIImage(named: model.image) ?? UIImage.remove
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        textLabel.text = text
        backroungImage.image = image
        view.addSubview(backroungImage)
        view.addSubview(textLabel)
        
        
        NSLayoutConstraint.activate([
            textLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -304),
            textLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            backroungImage.topAnchor.constraint(equalTo: view.topAnchor),
            backroungImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backroungImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backroungImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            
        ])
    }
}
