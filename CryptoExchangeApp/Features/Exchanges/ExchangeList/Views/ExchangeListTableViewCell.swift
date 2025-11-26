import UIKit
import Kingfisher
import SnapKit

final class ExchangeListTableViewCell: UITableViewCell {
    static let identifier = "ExchangeTableViewCell"
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = DesignSystem.ImageSize.logoSmall / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = DesignSystem.Colors.secondaryBackground
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystem.Typography.subtitle
        label.textColor = DesignSystem.Colors.textPrimary
        return label
    }()
    
    private let volumeLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystem.Typography.body
        label.textColor = DesignSystem.Colors.textSecondary
        return label
    }()
    
    private let dateLaunchedLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystem.Typography.caption
        label.textColor = DesignSystem.Colors.textSecondary
        return label
    }()
    
    private let leftStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = DesignSystem.Spacing.tiny
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.kf.cancelDownloadTask()
        logoImageView.image = nil
    }
    
    private func setupView() {
        contentView.addSubview(logoImageView)
        contentView.addSubview(leftStackView)
        
        leftStackView.addArrangedSubview(nameLabel)
        leftStackView.addArrangedSubview(volumeLabel)
        leftStackView.addArrangedSubview(dateLaunchedLabel)
        
        logoImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(DesignSystem.Spacing.medium)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(DesignSystem.ImageSize.logoSmall)
        }
        
        leftStackView.snp.makeConstraints { make in
            make.leading.equalTo(logoImageView.snp.trailing).offset(DesignSystem.Spacing.medium)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(DesignSystem.Spacing.medium)
        }
    }
    
    func configure(with viewModel: ExchangeViewModel) {
        nameLabel.text = viewModel.name
        volumeLabel.text = L10n.Exchanges.volume(viewModel.spotVolume)
        dateLaunchedLabel.text = L10n.Exchanges.launched(formatDate(viewModel.dateLaunched))
        
        if let logoURL = viewModel.logoURL, let url = URL(string: logoURL) {
            let processor = DownsamplingImageProcessor(size: CGSize(
                width: DesignSystem.ImageSize.logoSmall,
                height: DesignSystem.ImageSize.logoSmall
            ))
            
            logoImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "building.columns.fill"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
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
