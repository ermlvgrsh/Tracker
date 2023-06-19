import UIKit

final class TrackerCreatorViewController: UIViewController {
    
 
    private let createTrackerLabel: UILabel = {
        let createTrackerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 149, height: 22))
        createTrackerLabel.font = .systemFont(ofSize: 16, weight: .medium)
        createTrackerLabel.backgroundColor = .white
        createTrackerLabel.textAlignment = .center
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        createTrackerLabel.attributedText =
        NSMutableAttributedString(string: "Создание трекера",
                                  attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        createTrackerLabel.translatesAutoresizingMaskIntoConstraints = false
        return createTrackerLabel
    }()
    
    private lazy var centerStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [habbitButton, irregularEventButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [createTrackerLabel, UIView(), centerStackView])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let habbitButton: UIButton = {
        let habbitButton = UIButton(type: .system)
        habbitButton.backgroundColor = .black
        habbitButton.setTitleColor(.white, for: .normal)
        habbitButton.layer.masksToBounds = true
        habbitButton.layer.cornerRadius = 16
        
        let titleAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        let titleAtributedString = NSAttributedString(string: "Привычка",
                                                      attributes: titleAttribute)
        habbitButton.setAttributedTitle(titleAtributedString, for: .normal)
        habbitButton.translatesAutoresizingMaskIntoConstraints = false
        
        habbitButton.addTarget(self, action: #selector(habbitButtonPressed), for: .touchUpInside)
        return habbitButton
    }()
    
    private let irregularEventButton: UIButton = {
        let irregularEventButton = UIButton(type: .system)
        irregularEventButton.backgroundColor = .black
        irregularEventButton.setTitleColor(.white, for: .normal)
        irregularEventButton.layer.masksToBounds = true
        irregularEventButton.layer.cornerRadius = 16
        
        let titleAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        let titleAttributedString = NSAttributedString(string: "Нерегулярное событие",
                                                       attributes: titleAttribute)
        irregularEventButton.setAttributedTitle(titleAttributedString, for: .normal)
        irregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        
        irregularEventButton.addTarget(self, action: #selector(irregularEventButtonPressed), for: .touchUpInside)
        return irregularEventButton
    }()
    
    @objc func irregularEventButtonPressed() {
        print("Need to create irregular event")
    }
    @objc func habbitButtonPressed() {
        let newHabbitView = NewHabbitViewController()
        self.present(newHabbitView, animated: true)
        newHabbitView.delegate = TrackersViewController()
        
    }
    
    func constraintsForView() {
        view.addSubview(mainStackView)
        view.addSubview(createTrackerLabel)
        
        NSLayoutConstraint.activate([
            createTrackerLabel.heightAnchor.constraint(equalToConstant: 22),
            createTrackerLabel.widthAnchor.constraint(equalToConstant: 149),
            createTrackerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createTrackerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.topAnchor.constraint(equalTo: createTrackerLabel.bottomAnchor, constant: 16),
            
            habbitButton.widthAnchor.constraint(equalToConstant: 335),
            habbitButton.heightAnchor.constraint(equalToConstant: 60),
            habbitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habbitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            
            irregularEventButton.widthAnchor.constraint(equalToConstant: 335),
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60),
            irregularEventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            irregularEventButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        constraintsForView()
    }
}
