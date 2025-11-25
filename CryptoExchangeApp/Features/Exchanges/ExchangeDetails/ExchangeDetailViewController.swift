import UIKit
import Kingfisher

protocol ExchangeDetailDisplayLogic: AnyObject {
    func displayDetail(viewModel: ExchangeDetail.FetchDetail.ViewModel)
    func displayError(viewModel: ExchangeDetail.Error.ViewModel)
}

final class ExchangeDetailViewController: UIViewController {
    var interactor: ExchangeDetailInteractorProtocol?
    private var cryptocurrency: Cryptocurrency
    
    private var viewModel: ExchangeDetail.FetchDetail.ViewModel?
    
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    init(cryptocurrency: Cryptocurrency) {
            self.cryptocurrency = cryptocurrency
            super.init(nibName: nil, bundle: nil)
        }
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = DesignSystem.Colors.secondaryBackground
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystem.Typography.caption
        label.textColor = DesignSystem.Colors.textSecondary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionCard: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var infoCard: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var currenciesLabel: UILabel = {
        let label = UILabel()
        label.text = "Trading Pairs"
        label.font = DesignSystem.Typography.titleSection
        label.textColor = DesignSystem.Colors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currenciesTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(CurrencyTableViewCell.self, forCellReuseIdentifier: CurrencyTableViewCell.identifier)
        table.rowHeight = 60
        table.separatorColor = DesignSystem.Colors.separator
        table.backgroundColor = DesignSystem.Colors.cardBackground
        table.layer.cornerRadius = 12
        table.isScrollEnabled = false
        return table
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = DesignSystem.Colors.primary
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var currenciesTableHeightConstraint: NSLayoutConstraint?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchDetail()
    }
    
    private func setupView() {
        title = "Details"
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
        
        errorView.onRetry = { [weak self] in
            self?.fetchDetail()
        }

        errorView.onCancel = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        
        
        currenciesTableHeightConstraint = currenciesTableView.heightAnchor.constraint(equalToConstant: 0)
        currenciesTableHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            idLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            idLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionCard.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 24),
            descriptionCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionCard.topAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionCard.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: descriptionCard.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: descriptionCard.bottomAnchor, constant: -16),
            
            infoCard.topAnchor.constraint(equalTo: descriptionCard.bottomAnchor, constant: 16),
            infoCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            infoCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            infoStackView.topAnchor.constraint(equalTo: infoCard.topAnchor, constant: 16),
            infoStackView.leadingAnchor.constraint(equalTo: infoCard.leadingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: infoCard.trailingAnchor, constant: -16),
            infoStackView.bottomAnchor.constraint(equalTo: infoCard.bottomAnchor, constant: -16),
            
            currenciesLabel.topAnchor.constraint(equalTo: infoCard.bottomAnchor, constant: 24),
            currenciesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            currenciesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            currenciesTableView.topAnchor.constraint(equalTo: currenciesLabel.bottomAnchor, constant: 12),
            currenciesTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            currenciesTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            currenciesTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func fetchDetail() {
        loadingIndicator.startAnimating()
        let request = ExchangeDetail.FetchDetail.Request(cryptocurrency: cryptocurrency)
        interactor?.fetchDetail(request: request)
    }
    
    private func createInfoRow(title: String, value: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.font = DesignSystem.Typography.body
        titleLabel.textColor = DesignSystem.Colors.textSecondary
        titleLabel.text = title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.font = DesignSystem.Typography.subtitle
        valueLabel.textColor = DesignSystem.Colors.textPrimary
        valueLabel.text = value
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -8),
            
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            valueLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            container.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        return container
    }
}

extension ExchangeDetailViewController: ExchangeDetailDisplayLogic {
    func displayDetail(viewModel: ExchangeDetail.FetchDetail.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.viewModel = viewModel
            self.loadingIndicator.stopAnimating()
            
            self.errorView.isHidden = true
            self.scrollView.isHidden = false
            
            self.nameLabel.text = viewModel.name
            self.idLabel.text = "ID: \(viewModel.id)"
            self.descriptionLabel.text = viewModel.description
            
            if let logoURL = viewModel.logoURL, let url = URL(string: logoURL) {
                self.logoImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "bitcoinsign.circle.fill"))
            } else {
                self.logoImageView.image = UIImage(systemName: "bitcoinsign.circle.fill")
            }
            
            self.infoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            self.infoStackView.addArrangedSubview(self.createInfoRow(title: "Website", value: viewModel.website))
            self.infoStackView.addArrangedSubview(self.createInfoRow(title: "Maker Fee", value: viewModel.makerFee))
            self.infoStackView.addArrangedSubview(self.createInfoRow(title: "Taker Fee", value: viewModel.takerFee))
            self.infoStackView.addArrangedSubview(self.createInfoRow(title: "Date Launched", value: viewModel.dateLaunched))
            
            let currenciesCount = viewModel.currencies.count
            let tableHeight = CGFloat(currenciesCount * 60)
            self.currenciesTableHeightConstraint?.constant = tableHeight
            self.currenciesTableView.reloadData()
            
            self.view.layoutIfNeeded()
        }
    }
    
    func displayError(viewModel: ExchangeDetail.Error.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.loadingIndicator.stopAnimating()
            
            let apiError: APIError
            if viewModel.message.contains("400") {
                apiError = .badRequest(message: "Invalid value for \"id\"")
            } else if viewModel.message.contains("401") {
                apiError = .unauthorized
            } else if viewModel.message.contains("403") {
                apiError = .forbidden
            } else if viewModel.message.contains("429") {
                apiError = .tooManyRequests
            } else if viewModel.message.contains("500") {
                apiError = .internalServerError
            } else {
                apiError = .unknown
            }
            
            self?.errorView.configure(with: apiError)
            self?.errorView.isHidden = false
            self?.scrollView.isHidden = true
        }
    }
}

extension ExchangeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.currencies.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CurrencyTableViewCell.identifier,
            for: indexPath
        ) as? CurrencyTableViewCell,
              let currency = viewModel?.currencies[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(with: currency)
        cell.selectionStyle = .none
        return cell
    }
}
