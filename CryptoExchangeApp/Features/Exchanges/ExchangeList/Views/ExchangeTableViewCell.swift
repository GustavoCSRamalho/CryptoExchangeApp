import UIKit
import Kingfisher

final class ExchangeTableViewCell: UITableViewCell {
    static let identifier = "ExchangeTableViewCell"
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.backgroundColor = DesignSystem.Colors.secondaryBackground
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = DesignSystem.Colors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let volumeLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystem.Typography.body
        label.textColor = DesignSystem.Colors.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLaunchedLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystem.Typography.caption
        label.textColor = DesignSystem.Colors.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let leftStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(logoImageView)
        contentView.addSubview(leftStackView)
        
        leftStackView.addArrangedSubview(nameLabel)
        leftStackView.addArrangedSubview(volumeLabel)
        leftStackView.addArrangedSubview(dateLaunchedLabel)
        
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 50),
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            
            leftStackView.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 12),
            leftStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            leftStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with viewModel: ExchangeViewModel) {
        nameLabel.text = viewModel.name
        volumeLabel.text = L10n.Exchanges.volume(viewModel.spotVolume)
        dateLaunchedLabel.text = L10n.Exchanges.launched(formatDate(viewModel.dateLaunched))
        
        if let logoURL = viewModel.logoURL, let url = URL(string: logoURL) {
            logoImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "building.columns.fill"),
                options: [.transition(.fade(0.2))]
            )
        } else {
            logoImageView.image = UIImage(systemName: "building.columns.fill")
            logoImageView.tintColor = DesignSystem.Colors.textSecondary
        }
    }
    
    private func formatDate(_ dateString: String?) -> String {
        guard let dateString = dateString else { return L10n.General.notAvailable }
        
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: L10n.DateFormat.locale)
            outputFormatter.dateStyle = .long
            return outputFormatter.string(from: date)
        }
        
        return dateString
    }
}
