import UIKit

final class ErrorView: UIView {
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = DesignSystem.Colors.error
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystem.Typography.titleSection
        label.textColor = DesignSystem.Colors.textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystem.Typography.body
        label.textColor = DesignSystem.Colors.textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = DesignSystem.Colors.primary
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = DesignSystem.Typography.subtitle
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(DesignSystem.Colors.textSecondary, for: .normal)
        button.titleLabel?.font = DesignSystem.Typography.body
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        button.setTitle(L10n.General.cancel, for: .normal)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var onRetry: (() -> Void)?
    var onCancel: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = DesignSystem.Colors.background
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(retryButton)
        stackView.addArrangedSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
            
            retryButton.heightAnchor.constraint(equalToConstant: 50),
            retryButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configure(with error: APIError) {
        titleLabel.text = error.title
        messageLabel.text = error.message
        retryButton.setTitle(error.actionButtonTitle, for: .normal)
        
        switch error {
        case .unauthorized, .forbidden:
            iconImageView.image = UIImage(systemName: "lock.circle.fill")
        case .tooManyRequests:
            iconImageView.image = UIImage(systemName: "clock.circle.fill")
        case .internalServerError:
            iconImageView.image = UIImage(systemName: "server.rack")
        case .networkFailure:
            iconImageView.image = UIImage(systemName: "wifi.slash")
        case .noData, .decodingError:
            iconImageView.image = UIImage(systemName: "doc.text.magnifyingglass")
        default:
            iconImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
        }
        
        retryButton.isHidden = !error.shouldShowRetry
        cancelButton.isHidden = !error.shouldShowRetry
    }
    
    @objc private func retryTapped() {
        onRetry?()
    }
    
    @objc private func cancelTapped() {
        onCancel?()
    }
}
