import UIKit

protocol CategoriesDelegate: AnyObject {
    func didSelectCategory(_ selectedCategory: TrackerCategory)
}


final class CategoriesViewController: UIViewController {
    
    var categories = [TrackerCategory]()
    
    weak var delegate: CategoriesDelegate?
    private let viewModel = TrackerCategoryViewModel()
    private let eventViewModel = EventViewModel()
    private var categoryTableViewHeightConstraint: NSLayoutConstraint?
    
    
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame:CGRect(x: 0, y: 0, width: 133, height: 22))
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.backgroundColor = .white
        label.textAlignment = .center
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        label.attributedText =
        NSMutableAttributedString(string: "category".localized,
                                  attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26
        paragraphStyle.alignment = .center
        label.attributedText =
        NSMutableAttributedString(string: "category_placeholder".localized, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let placeholderImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "1"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = false
        return imageView
    }()
    
    private let categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        tableView.estimatedRowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = .white
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        return tableView
    }()
    
    lazy var addCategory: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.backgroundColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1).cgColor
        button.layer.cornerRadius = 16
        
        let titleAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17)
        ]
        
        let titleAtributedString = NSAttributedString(string: "add_category".localized,
                                                      attributes: titleAttribute)
        button.tintColor = .white
        button.setAttributedTitle(titleAtributedString, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createCategory), for: .touchUpInside)
        return button
    }()
    

    @objc func createCategory() {
        let newCategoryVC = NewCategoryViewController(viewModel: viewModel, eventViewModel: eventViewModel)
        present(newCategoryVC, animated: true)
    }
    

    private func bindCategoryViewModel() {
        viewModel.$categories.bind { [weak self] trackerCategory in
            self?.categoryTableView.reloadData()
        }
        viewModel.$isPlaceholderHidden.bind { [weak self] isHidden in
            self?.placeholderImage.isHidden = isHidden
            self?.placeholderLabel.isHidden = isHidden
        }
        viewModel.$isTableViewHidden.bind { [weak self] isHidden in
            self?.categoryTableView.isHidden = isHidden
        }
        viewModel.$selectedCategory.bind { [weak self] selectedCategory in
            guard let selectedCategory = selectedCategory else { return }
            self?.delegate?.didSelectCategory(selectedCategory)
        }
        
        viewModel.bindCategory()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindCategoryViewModel()
    }
    
    func setupTableView() {
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }
    
    func setupUI() {
        setupTableView()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(placeholderImage)
        scrollView.addSubview(placeholderLabel)
        scrollView.addSubview(categoryTableView)
        scrollView.addSubview(addCategory)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 38),
            titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 84),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            placeholderImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            placeholderImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 246),
            placeholderImage.widthAnchor.constraint(equalToConstant: 80),
            placeholderImage.heightAnchor.constraint(equalToConstant: 80),
            
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: placeholderImage.centerXAnchor),
            placeholderLabel.widthAnchor.constraint(equalToConstant: 343),
            
            categoryTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            categoryTableView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            categoryTableView.widthAnchor.constraint(equalToConstant: 343),
            categoryTableView.bottomAnchor.constraint(equalTo: addCategory.topAnchor, constant: -26),
            
            addCategory.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 276),
            addCategory.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            addCategory.widthAnchor.constraint(equalToConstant: 335),
            addCategory.heightAnchor.constraint(equalToConstant: 60),
        ])
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        categoryTableView.layoutIfNeeded()
    }

}

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let categoryCell = categoryTableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else { fatalError() }
        let selectedCategories = viewModel.categories[indexPath.row]
        categoryCell.checkmarkImage.isHidden = false
        viewModel.didSelectTrackerCategory(category: selectedCategories)
        dismiss(animated: true)
    }
}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row != lastRowIndex {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = viewModel.categories[indexPath.row]
        guard let categoryCell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else { return UITableViewCell() }
        let categoryName = category.categoryName
        categoryCell.categoryLabel.text = categoryName
        categoryCell.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        return categoryCell
    }
}

