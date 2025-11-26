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
        imageView.layer.cornerRadius = 50
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
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
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
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
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
        table.rowHeight = 60
        table.separatorColor = DesignSystem.Colors.separator
        table.backgroundColor = DesignSystem.Colors.cardBackground
        table.layer.cornerRadius = 12
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
    
    init(exchangeId: Int) {
        self.exchangeId = exchangeId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchDetail()
    }
    
    
    // MARK: - Setup
    
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
        
        
        // MARK: SnapKit Constraints
        
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
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
        }
        
        descriptionCard.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        infoCard.snp.makeConstraints { make in
            make.top.equalTo(descriptionCard.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        currenciesLabel.snp.makeConstraints { make in
            make.top.equalTo(infoCard.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        currenciesTableView.snp.makeConstraints { make in
            make.top.equalTo(currenciesLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-24)
            
            currenciesTableHeightConstraint = make.height.equalTo(0).constraint
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    
    // MARK: - Fetch
    
    private func fetchDetail() {
        loadingIndicator.startAnimating()
        interactor?.fetchDetail(request: ExchangeDetail.FetchDetail.Request(exchangeId: exchangeId))
    }
    
    
    // MARK: - Info Row Builder (SnapKit)
    
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
        
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        
        container.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.right.equalTo(valueLabel.snp.left).offset(-8)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.right.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(100)
        }
        
        return container
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
                self.logoImageView.kf.setImage(with: url,
                                               placeholder: UIImage(systemName: "building.columns.fill"))
            } else {
                self.logoImageView.image = UIImage(systemName: "building.columns.fill")
                self.logoImageView.tintColor = DesignSystem.Colors.textSecondary
            }
            
            self.infoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            self.infoStackView.addArrangedSubview(self.createInfoRow(title: L10n.Detail.website, value: viewModel.website))
            self.infoStackView.addArrangedSubview(self.createInfoRow(title: L10n.Detail.makerFee, value: viewModel.makerFee))
            self.infoStackView.addArrangedSubview(self.createInfoRow(title: L10n.Detail.takerFee, value: viewModel.takerFee))
            self.infoStackView.addArrangedSubview(self.createInfoRow(title: L10n.Detail.dateLaunched, value: viewModel.dateLaunched))
            
            let height = CGFloat(viewModel.currencies.count * 60)
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeDetailsTableViewCell.identifier, for: indexPath) as? ExchangeDetailsTableViewCell else {
            return UITableViewCell()
        }
        
        if let currency = currency {
            cell.configure(with: currency)
        }
        cell.selectionStyle = .none
        return cell
    }
}
