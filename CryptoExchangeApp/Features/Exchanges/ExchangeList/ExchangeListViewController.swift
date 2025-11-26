import UIKit
import Foundation

protocol ExchangesDisplayLogic: AnyObject {
    func displayExchanges(viewModel: Exchanges.FetchExchanges.ViewModel)
    func displayError(viewModel: Exchanges.Error.ViewModel)
}

final class ExchangesViewController: UIViewController {
    var interactor: ExchangesInteractorProtocol?
    var router: ExchangesRouterProtocol?
    
    private var exchanges: [ExchangeViewModel] = []
    
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(ExchangeTableViewCell.self, forCellReuseIdentifier: ExchangeTableViewCell.identifier)
        table.rowHeight = 80
        table.separatorColor = DesignSystem.Colors.separator
        table.backgroundColor = DesignSystem.Colors.background
        return table
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refresh
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = DesignSystem.Colors.primary
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = L10n.Exchanges.emptyState
        label.textColor = DesignSystem.Colors.textSecondary
        label.font = DesignSystem.Typography.body
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchExchanges()
    }
    
    private func setupView() {
        title = L10n.Exchanges.title
        view.backgroundColor = DesignSystem.Colors.background
        
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(emptyStateLabel)
        view.addSubview(errorView)
        
        tableView.refreshControl = refreshControl
        
        errorView.onRetry = { [weak self] in
            self?.fetchExchanges()
        }
        
        errorView.onCancel = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchExchanges() {
        if !refreshControl.isRefreshing {
            loadingIndicator.startAnimating()
        }
        
        let request = Exchanges.FetchExchanges.Request()
        interactor?.fetchExchanges(request: request)
    }
    
    @objc private func handleRefresh() {
        fetchExchanges()
    }
}

extension ExchangesViewController: ExchangesDisplayLogic {
    func displayExchanges(viewModel: Exchanges.FetchExchanges.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.exchanges = viewModel.exchanges
            self?.tableView.reloadData()
            self?.loadingIndicator.stopAnimating()
            self?.refreshControl.endRefreshing()
            self?.emptyStateLabel.isHidden = !viewModel.exchanges.isEmpty
            
            self?.errorView.isHidden = true
            self?.tableView.isHidden = false
        }
    }
    
    func displayError(viewModel: Exchanges.Error.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.loadingIndicator.stopAnimating()
            self?.refreshControl.endRefreshing()
            
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
            
            self?.errorView.configure(with: apiError)
            self?.errorView.isHidden = false
            self?.tableView.isHidden = true
        }
    }
}

extension ExchangesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exchanges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ExchangeTableViewCell.identifier,
            for: indexPath
        ) as? ExchangeTableViewCell else {
            return UITableViewCell()
        }
        
        let exchange = exchanges[indexPath.row]
        cell.configure(with: exchange)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let request = Exchanges.SelectExchange.Request(index: indexPath.row)
        if let selectedExchange = interactor?.selectExchange(request: request) {
            router?.navigateToExchangeDetail(exchange: selectedExchange)
        }
    }
}
