import UIKit
import Kingfisher
import SnapKit

protocol ExchangeDetailDisplayLogic: AnyObject {
    func displayDetail(viewModel: ExchangeDetail.FetchDetail.ViewModel)
    func displayError(viewModel: ExchangeDetail.Error.ViewModel)
}

final class ExchangeDetailViewController: UIViewController {
    var interactor: ExchangeDetailInteractorProtocol?
    private var exchangeId: Int
    
    private var viewModel: ExchangeDetail.FetchDetail.ViewModel?
    
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.isHidden = true
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = DesignSystem.Colors.secondaryBackground
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = DesignSystem.CornerRadius.circle
        imageView.clipsToBounds = true
        imageView.backgroundColor = DesignSystem.Colors.cardBackground
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystem.Typography.titleLarge
        label.textColor = DesignSystem.Colors.textPrimary
        label.textAlignment = .center
        return label
    }()
    
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystem.Typography.caption
        label.textColor = DesignSystem.Colors.textSecondary
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionCard: UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystem.Colors.cardBackground
        view.layer.cornerRadius = DesignSystem.CornerRadius.medium
        view.layer.shadowColor = DesignSystem.Shadow.color
        view.layer.shadowOpacity = DesignSystem.Shadow.opacity
        view.layer.shadowOffset = DesignSystem.Shadow.offset
        view.layer.shadowRadius = DesignSystem.Shadow.radius
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystem.Typography.body
        label.textColor = DesignSystem.Colors.textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var infoCard: UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystem.Colors.cardBackground
        view.layer.cornerRadius = DesignSystem.CornerRadius.medium
        view.layer.shadowColor = DesignSystem.Shadow.color
        view.layer.shadowOpacity = DesignSystem.Shadow.opacity
        view.layer.shadowOffset = DesignSystem.Shadow.offset
        view.layer.shadowRadius = DesignSystem.Shadow.radius
        return view
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = DesignSystem.Spacing.medium
        return stack
    }()
    
    private lazy var currenciesLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Detail.tradingPairs
        label.font = DesignSystem.Typography.titleSection
        label.textColor = DesignSystem.Colors.textPrimary
        return label
    }()
    
    private lazy var currenciesTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(ExchangeDetailsTableViewCell.self, forCellReuseIdentifier: ExchangeDetailsTableViewCell.identifier)
        table.rowHeight = DesignSystem.CellHeight.currencyDetail
        table.separatorColor = DesignSystem.Colors.separator
        table.backgroundColor = DesignSystem.Colors.cardBackground
        table.layer.cornerRadius = DesignSystem.CornerRadius.medium
        table.isScrollEnabled = false
        return table
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = DesignSystem.Colors.primary
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var currenciesTableHeightConstraint: Constraint?
    
    init(exchangeId: Int, interactor: ExchangeDetailInteractorProtocol) {
       self.exchangeId = exchangeId
       self.interactor = interactor
       super.init(nibName: nil, bundle: nil)
   }
       
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchDetail()
    }
    
    private func setupView() {
        title = L10n.Detail.title
        view.backgroundColor = DesignSystem.Colors.secondaryBackground
        
        view.addSubview(scrollView)
        view.addSubview(loadingIndicator)
        view.addSubview(errorView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(logoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(idLabel)
        contentView.addSubview(descriptionCard)
        descriptionCard.addSubview(descriptionLabel)
        contentView.addSubview(infoCard)
        infoCard.addSubview(infoStackView)
        contentView.addSubview(currenciesLabel)
        contentView.addSubview(currenciesTableView)
        
        errorView.onRetry = { [weak self] in self?.fetchDetail() }
        errorView.onCancel = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        
        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(DesignSystem.Spacing.large)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(DesignSystem.ImageSize.logoMedium)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(DesignSystem.Spacing.medium)
            make.left.right.equalToSuperview().inset(DesignSystem.Spacing.medium)
        }
        
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(DesignSystem.Spacing.tiny)
            make.left.right.equalToSuperview().inset(DesignSystem.Spacing.medium)
        }
        
        descriptionCard.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(DesignSystem.Spacing.large)
            make.left.right.equalToSuperview().inset(DesignSystem.Spacing.medium)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(DesignSystem.Spacing.medium)
        }
        
        infoCard.snp.makeConstraints { make in
            make.top.equalTo(descriptionCard.snp.bottom).offset(DesignSystem.Spacing.medium)
            make.left.right.equalToSuperview().inset(DesignSystem.Spacing.medium)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(DesignSystem.Spacing.medium)
        }
        
        currenciesLabel.snp.makeConstraints { make in
            make.top.equalTo(infoCard.snp.bottom).offset(DesignSystem.Spacing.large)
            make.left.right.equalToSuperview().inset(DesignSystem.Spacing.medium)
        }
        
        currenciesTableView.snp.makeConstraints { make in
            make.top.equalTo(currenciesLabel.snp.bottom).offset(DesignSystem.Spacing.medium)
            make.left.right.equalToSuperview().inset(DesignSystem.Spacing.medium)
            make.bottom.equalToSuperview().offset(-DesignSystem.Spacing.large)
            
            currenciesTableHeightConstraint = make.height.equalTo(0).constraint
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    
    private func fetchDetail() {
        loadingIndicator.startAnimating()
        interactor?.fetchDetail(request: ExchangeDetail.FetchDetail.Request(exchangeId: exchangeId))
    }
    
    
    private func createInfoRow(title: String, value: String) -> UIView {
        let container = UIView()
        
        let titleLabel = UILabel()
        titleLabel.font = DesignSystem.Typography.body
        titleLabel.textColor = DesignSystem.Colors.textSecondary
        titleLabel.text = title
        
        let valueLabel = UILabel()
        valueLabel.font = DesignSystem.Typography.subtitle
        valueLabel.textColor = DesignSystem.Colors.textPrimary
        valueLabel.text = value
        valueLabel.textAlignment = .right
        valueLabel.numberOfLines = 1
        valueLabel.lineBreakMode = .byTruncatingTail
        
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        
        container.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.right.equalTo(valueLabel.snp.left).offset(-DesignSystem.Spacing.small)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.right.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(100)
        }
        
        if title.lowercased() == "website" {
            valueLabel.textColor = DesignSystem.Colors.primary
            valueLabel.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleWebsiteTap(_:)))
            valueLabel.addGestureRecognizer(tap)
        }
        
        return container
    }
    
    @objc private func handleWebsiteTap(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel,
              let urlString = label.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              var url = URL(string: urlString) else { return }
        
        if !urlString.lowercased().hasPrefix("http") {
            if let fixedURL = URL(string: "https://" + urlString) {
                url = fixedURL
            }
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}


extension ExchangeDetailViewController: ExchangeDetailDisplayLogic {
    func displayDetail(viewModel: ExchangeDetail.FetchDetail.ViewModel) {
        DispatchQueue.main.async {
            self.viewModel = viewModel
            self.loadingIndicator.stopAnimating()
            
            self.errorView.isHidden = true
            self.scrollView.isHidden = false
            
            self.nameLabel.text = viewModel.name
            self.idLabel.text = L10n.Detail.idLabel(viewModel.id)
            self.descriptionLabel.text = viewModel.description
            
            if let logoURL = viewModel.logoURL,
               let url = URL(string: logoURL) {
                let processor = DownsamplingImageProcessor(size: CGSize(
                    width: DesignSystem.ImageSize.logoMedium,
                    height: DesignSystem.ImageSize.logoMedium
                ))
                
                self.logoImageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(systemName: "building.columns.fill"),
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(0.3)),
                        .cacheOriginalImage
                    ]
                )
            } else {
                self.logoImageView.image = UIImage(systemName: "building.columns.fill")
                self.logoImageView.tintColor = DesignSystem.Colors.textSecondary
            }
            
            self.infoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            self.infoStackView.addArrangedSubview(self.createInfoRow(title: L10n.Detail.website, value: viewModel.website))
            self.infoStackView.addArrangedSubview(self.createInfoRow(title: L10n.Detail.makerFee, value: viewModel.makerFee))
            self.infoStackView.addArrangedSubview(self.createInfoRow(title: L10n.Detail.takerFee, value: viewModel.takerFee))
            self.infoStackView.addArrangedSubview(self.createInfoRow(title: L10n.Detail.dateLaunched, value: viewModel.dateLaunched))
            
            let height = CGFloat(viewModel.currencies.count) * DesignSystem.CellHeight.currencyDetail
            self.currenciesTableHeightConstraint?.update(offset: height)
            self.currenciesTableView.reloadData()
            
            self.view.layoutIfNeeded()
        }
    }
    
    func displayError(viewModel: ExchangeDetail.Error.ViewModel) {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            
            let apiError: APIError
            if viewModel.message.contains("400") {
                apiError = .badRequest(message: L10n.Error.Message.badRequestId)
            } else if viewModel.message.contains("401") {
                apiError = .unauthorized
            } else if viewModel.message.contains("403") {
                apiError = .forbidden
            } else if viewModel.message.contains("429") {
                apiError = .tooManyRequests
            } else if viewModel.message.contains("500") {
                apiError = .internalServerError(statusCode: 500)
            } else {
                apiError = .unknown
            }
            
            self.errorView.configure(with: apiError)
            self.errorView.isHidden = false
            self.scrollView.isHidden = true
        }
    }
}


extension ExchangeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.currencies.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = viewModel?.currencies[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ExchangeDetailsTableViewCell.identifier,
            for: indexPath
        ) as? ExchangeDetailsTableViewCell else {
            return UITableViewCell()
        }
        
        if let currency = currency {
            cell.configure(with: currency)
        }
        cell.selectionStyle = .none
        return cell
    }
}
