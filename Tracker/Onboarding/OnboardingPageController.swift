import UIKit


final class OnboardingPageViewController: UIPageViewController {
    
    
    private var pages: [OnboardingModel] = [
        OnboardingModel(text: "track_everything".localized, image: "onboard1"),
        OnboardingModel(text: "not_only_water".localized, image: "onboard2")
    ]
    
    lazy var pageControl: UIPageControl = {
       let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .black
        pc.pageIndicatorTintColor = .black.withAlphaComponent(0.3)
        pc.numberOfPages = pages.count
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    private lazy var entryButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("technologies".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        return button
    }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey : Any]? = nil
    ) {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: navigationOrientation,
                   options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        configureView()
    }
    
    
    @objc func buttonClicked() {
       let tabBar = TabBarController()
       tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
    }
    
    private func configureView() {
        delegate = self
        dataSource = self
        
        guard let firstOnboardingPage = pages.first else { return }
        let vc = OnboardingViewController(model: firstOnboardingPage, index: 0)
        setViewControllers([vc], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        
    }
    
    private func setUI() {
        view.addSubview(pageControl)
        view.addSubview(entryButton)
        
        NSLayoutConstraint.activate([
        
            entryButton.heightAnchor.constraint(equalToConstant: 60),
            entryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            entryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            entryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: entryButton.topAnchor, constant: -24)
        ])
    }
}


extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? OnboardingViewController else { return nil }
        let currentIndex = currentVC.pageIndex
        let previousIndex = (currentIndex - 1 + pages.count) % pages.count
        let previousPage = pages[previousIndex]
        
        return OnboardingViewController(model: previousPage, index: previousIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? OnboardingViewController else { return nil }
        let currenIndex = currentVC.pageIndex
        let nextIndex = (currenIndex + 1) % pages.count
        let nextPage = pages[nextIndex]
        
        return OnboardingViewController(model: nextPage, index: nextIndex)
    }
    
    
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first as? OnboardingViewController {
            pageControl.currentPage = currentViewController.pageIndex
        }
    }
}
