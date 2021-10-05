import UIKit

class CustomPopupView: UIView {
    
    private let popupView = UIView(frame: CGRect.zero)
    let yesButton = UIButton(frame: CGRect.zero)
    let noButton = UIButton(frame: CGRect.zero)
    private let title = UILabel(frame: CGRect.zero)
    private let message = UILabel(frame: CGRect.zero)
    private let alignConst: CGFloat = 3.5
    private let cornerRadius: CGFloat = 10
    private let defaultWindowWidth: CGFloat = 300
    private var buttonWidth: CGFloat {
        defaultWindowWidth/2
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
        setupPopupView()
        setupLabels()
        setupButtons()
        addSubview(popupView)
        
        popupView.translatesAutoresizingMaskIntoConstraints = false
        yesButton.translatesAutoresizingMaskIntoConstraints = false
        noButton.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    private func setupPopupView() {
        popupView.backgroundColor = UIColor.white
        popupView.layer.masksToBounds = true
        popupView.layer.cornerRadius = cornerRadius
    }
    
    private func setupLabels() {
        title.backgroundColor = UIColor(named: "color.purple")
        title.textColor = UIColor.white
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.adjustsFontSizeToFitWidth = true
        title.clipsToBounds = true
        title.textAlignment = .center
        title.layer.cornerRadius = cornerRadius
        
        message.textColor = UIColor.black
        message.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        message.numberOfLines = 0
        message.textAlignment = .center
        
        popupView.addSubview(title)
        popupView.addSubview(message)
    }
    
    private func setupButtons() {
        noButton.setTitleColor(UIColor.white, for: .highlighted)
        noButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        noButton.backgroundColor = UIColor(named: "color.green")
        noButton.layer.cornerRadius = cornerRadius
        
        yesButton.setTitleColor(UIColor(named: "color.purple"), for: .normal)
        yesButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        yesButton.backgroundColor = UIColor.white
        yesButton.layer.borderWidth = 2
        yesButton.layer.borderColor = UIColor(named: "color.purple")?.cgColor
        yesButton.layer.cornerRadius = cornerRadius
        
        popupView.addSubview(yesButton)
        popupView.addSubview(noButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            popupView.widthAnchor.constraint(equalToConstant: defaultWindowWidth),
            popupView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            popupView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: alignConst),
            title.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -alignConst),
            title.topAnchor.constraint(equalTo: popupView.topAnchor, constant: alignConst),
            title.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            message.heightAnchor.constraint(greaterThanOrEqualToConstant: 90),
            message.topAnchor.constraint(equalTo: title.bottomAnchor, constant: alignConst),
            message.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: alignConst),
            message.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -alignConst),
            message.bottomAnchor.constraint(equalTo: yesButton.topAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            noButton.heightAnchor.constraint(equalToConstant: 35),
            noButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            noButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: alignConst),
            noButton.trailingAnchor.constraint(equalTo: yesButton.leadingAnchor, constant: -alignConst),
            noButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -5),
        ])
        
        NSLayoutConstraint.activate([
            yesButton.heightAnchor.constraint(equalToConstant: 35),
            yesButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            yesButton.leadingAnchor.constraint(equalTo: noButton.trailingAnchor, constant: alignConst),
            yesButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -alignConst),
            yesButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -5),
        ])
    }
    
    func configure(_ title: String, _ message: String, _ noButton: String, _ yesButton: String) {
        self.title.text = title
        self.message.text = message
        self.noButton.setTitle(noButton, for: .normal)
        self.yesButton.setTitle(yesButton, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

