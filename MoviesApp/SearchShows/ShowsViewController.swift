//
//  ShowsViewController.swift
//  MoviesApp
//
//  Created by Joanna Zatorska on 17/04/2021.
//

import UIKit
import API
import Models

class ShowsViewController: UIViewController {
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Search for shows..."
        return textField
    }()
    
    lazy var favouriteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Filter favourites: "
        return label
    }()
    
    lazy var favouritesToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        toggle.onTintColor = UIColor(named: "Accent")
        toggle.accessibilityLabel = "Show favourites"
        return toggle
    }()
    
    lazy var favouriteStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .top
        stack.distribution = .equalSpacing
        stack.spacing = 5
        stack.addArrangedSubview(favouriteLabel)
        stack.addArrangedSubview(favouritesToggle)
        return stack
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 5
        return stack
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var activityView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tblView = UITableView(frame: .zero)
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.register(ShowCell.self, forCellReuseIdentifier: ShowCell.reuseIdentifier)
        return tblView
    }()
    
    private var dependencies: Dependencies
    private var viewModel: ShowsViewModelProtocol
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.viewModel = dependencies.createShowsViewModel()
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        tableView.dataSource = viewModel
        tableView.delegate = self
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSpinner(false)
        tableView.reloadData()
    }
    
    private func setupLayout() {
        let inset = CGFloat(10)
        view.addSubview(stackView)
        stackView.addArrangedSubview(searchTextField)
        stackView.addArrangedSubview(favouriteStackView)
        stackView.addArrangedSubview(tableView)
        
        activityView.addSubview(activityIndicator)
        view.addSubview(activityView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: inset),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset),
            activityView.topAnchor.constraint(equalTo: view.topAnchor),
            activityView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: activityView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: activityView.centerXAnchor)
        ])
    }
    
    @objc func textDidChange() {
        viewModel.textDidChange(to: searchTextField.text)
    }
    
    @objc func switchValueDidChange() {
        viewModel.filterFavourites(favouritesToggle.isOn)
    }
}

extension ShowsViewController: UITableViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedShow(at: indexPath)
        showSpinner(true)
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func showSpinner(_ show: Bool) {
        let alpha = show ? 1 : 0
        activityView.alpha = CGFloat(alpha)
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

extension ShowsViewController: ShowsViewModelDelegate {
    func didUpdateCell(at index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func didReceiveShows() {
        tableView.reloadData()
    }
    func didClearData() {
        tableView.reloadData()
    }
    func didReceiveError(_ error: APIError) {
        showAlert(message: error.localizedDescription)
    }
    
    func didRetrieveShowDetails(_ details: ShowDetails) {
        showSpinner(false)
        let showViewModel = dependencies.createShowDetailsViewModel(showDetails: details)
        let detailsViewController = ShowDetailsViewController(viewModel: showViewModel)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

