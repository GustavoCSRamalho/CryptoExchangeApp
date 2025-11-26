import UIKit
import SnapKit

final class ExchangeDetailsTableViewCell: UITableViewCell {
    static let identifier = "ExchangeDetailsTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystem.Typography.subtitle
        label.textColor = DesignSystem.Colors.textPrimary
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystem.Typography.body
        label.textColor = DesignSystem.Colors.success
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = DesignSystem.Colors.cardBackground
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(DesignSystem.Spacing.medium)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(priceLabel.snp.leading).offset(-DesignSystem.Spacing.small)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(DesignSystem.Spacing.medium)
            make.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(100)
        }
    }
    
    func configure(with viewModel: CurrencyViewModel) {
        nameLabel.text = viewModel.name
        priceLabel.text = viewModel.priceUSD
    }
}
