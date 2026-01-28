import UIKit
import Foundation
import SnapKit

protocol ExchangesListDisplayLogic: AnyObject {
    func displayExchanges(viewModel: Exchanges.FetchExchanges.ViewModel)
    func displayError(viewModel: Exchanges.Error.ViewModel)
}

final class ExchangesListViewController: UIViewController {
    let interactor: ExchangesListInteractorProtocol?
    let router: ExchangesListCoordinatorProtocol?
    
    private var exchanges: [ExchangeViewModel]
    
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.isHidden = true
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(ExchangeListTableViewCell.self, forCellReuseIdentifier: ExchangeListTableViewCell.identifier)
        table.rowHeight = DesignSystem.CellHeight.exchangeList
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
        indicator.color = DesignSystem.Colors.primary
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Exchanges.emptyState
        label.textColor = DesignSystem.Colors.textSecondary
        label.font = DesignSystem.Typography.body
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    init(interactor: ExchangesListInteractorProtocol,
            router: ExchangesListCoordinatorProtocol) {
        self.interactor = interactor
        self.router = router
        self.exchanges = []
        super.init(nibName: nil, bundle: nil)
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
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
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(DesignSystem.Spacing.extraLarge)
            make.trailing.equalToSuperview().inset(DesignSystem.Spacing.extraLarge)
        }
        
        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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

extension ExchangesListViewController: ExchangesListDisplayLogic {
    func displayExchanges(viewModel: Exchanges.FetchExchanges.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.exchanges = viewModel.exchanges
            self.tableView.reloadData()
            self.loadingIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
            self.emptyStateLabel.isHidden = !viewModel.exchanges.isEmpty
            
            self.errorView.isHidden = true
            self.tableView.isHidden = false
        }
    }
    
    func displayError(viewModel: Exchanges.Error.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.loadingIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
            
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
            self.tableView.isHidden = true
        }
    }
}

extension ExchangesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exchanges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ExchangeListTableViewCell.identifier,
            for: indexPath
        ) as? ExchangeListTableViewCell else {
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
