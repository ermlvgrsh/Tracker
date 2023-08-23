import UIKit


final class StatisticViewController: UIViewController {
    
    private let viewModel: StatisticViewModel
    
    init(viewModel: StatisticViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var placeholderImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "3"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.backgroundColor = .systemBackground
        label.tintColor = .label
        label.textAlignment = .center
        label.text = "placeholder_statistic".localized
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var statisticsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.backgroundColor = .systemBackground
        label.tintColor = .label
        label.textAlignment = .left
        label.text = "statistic".localized
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var itemStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var bestPeriodView: StatisticView = {
        let periodView = StatisticView(description: "best_period_view".localized, counter: "-")
        periodView.translatesAutoresizingMaskIntoConstraints = false
        return periodView
    }()
    
    private lazy var bestDaysView: StatisticView = {
        let bestDayView = StatisticView(description: "best_days_view".localized, counter: "-")
        bestDayView.translatesAutoresizingMaskIntoConstraints = false
        return bestDayView
    }()
    
    private lazy var completedTrackersView: StatisticView = {
        let completedView = StatisticView(description: "completed_trackers".localized, counter: "-")
        completedView.translatesAutoresizingMaskIntoConstraints = false
        return completedView
    }()
    
    private lazy var averageValueView: StatisticView = {
        let averageValue = StatisticView(description: "average_value".localized, counter: "-")
        averageValue.translatesAutoresizingMaskIntoConstraints = false
        return averageValue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureStackView()
        initializeObserver()
        viewModel.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        completedTrackersView.configureBorder()
        averageValueView.configureBorder()
        bestDaysView.configureBorder()
        bestPeriodView.configureBorder()
    }
    
    private func showStatisticView() {
        itemStackView.isHidden = false
        placeholderLabel.isHidden = true
        placeholderImage.isHidden = true
    }
    
    private func showPlaceholder() {
        placeholderImage.isHidden = false
        placeholderLabel.isHidden = false
        itemStackView.isHidden = true
    }
    
    private func initializeObserver() {
        viewModel.$isPlaceholderHidden.bind { [weak self] isPlaceholderHidden in
            guard let self = self else { return }
            if isPlaceholderHidden {
                self.showStatisticView()
                return
            } else {
                self.showPlaceholder()
            }
        }
        viewModel.$completedTrackerValue.bind { [weak self] newCounter in
            self?.completedTrackersView.updateCounter(newCounter: newCounter)
        }
        viewModel.$averageValue.bind { [weak self] newCounter in
            self?.averageValueView.updateCounter(newCounter: newCounter)
        }
        viewModel.$bestDaysValue.bind { [weak self] newCounter in
            self?.bestDaysView.updateCounter(newCounter: newCounter)
        }
        viewModel.$bestPeriodValue.bind { [weak self] newwCounter in
            self?.bestPeriodView.updateCounter(newCounter: newwCounter)
        }
    }
    
    
    
    private func configureStackView() {
        view.addSubview(itemStackView)
        itemStackView.addArrangedSubview(bestPeriodView)
        itemStackView.addArrangedSubview(bestDaysView)
        itemStackView.addArrangedSubview(completedTrackersView)
        itemStackView.addArrangedSubview(averageValueView)
        
        
        NSLayoutConstraint.activate([
            itemStackView.heightAnchor.constraint(equalToConstant: 396),
            itemStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            itemStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            itemStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(placeholderImage)
        view.addSubview(placeholderLabel)
        view.addSubview(statisticsLabel)
        
        
        NSLayoutConstraint.activate([
            
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderImage.widthAnchor.constraint(equalToConstant: 80),
            placeholderImage.heightAnchor.constraint(equalToConstant: 80),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            placeholderLabel.widthAnchor.constraint(equalToConstant: 343),
            placeholderLabel.heightAnchor.constraint(equalToConstant: 18),
            
            statisticsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            statisticsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticsLabel.widthAnchor.constraint(equalToConstant: 254),
            statisticsLabel.heightAnchor.constraint(equalToConstant: 41)
        ])
    }
}
