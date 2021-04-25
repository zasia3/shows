//
//  ShowDetailsViewController.swift
//  MoviesApp
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import UIKit

class ShowDetailsViewController: UIViewController {
    private var viewModel: ShowDetailsViewModelProtocol
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.showDetails.show.name
        return label
    }()
    
    lazy var favouritesToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        return toggle
    }()
    
    lazy var favouriteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "My favourite: "
        return label
    }()
    
    lazy var favouriteStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .top
        stack.distribution = .equalSpacing
        stack.spacing = 5
        return stack
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 5
        return stack
    }()
    
    lazy var crewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let crew = viewModel.crew
        label.text = "Crew: \(crew?.person.name ?? "n/a")"
        return label
    }()
    
    lazy var episodesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show episodes", for: .normal)
        button.addTarget(self, action: #selector(tappedShowEpisodes), for: .touchUpInside)
        button.setTitleColor(UIColor(named: "Hero"), for: .normal)
        return button
    }()
    
    init(viewModel: ShowDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    private func setupLayout() {
        let inset = CGFloat(10)
        favouritesToggle.isOn = viewModel.isFavourite
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        favouriteStackView.addArrangedSubview(favouriteLabel)
        favouriteStackView.addArrangedSubview(favouritesToggle)
        stackView.addArrangedSubview(favouriteStackView)
        stackView.addArrangedSubview(crewLabel)
        stackView.addArrangedSubview(episodesButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: inset),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset)
        ])
    }
    
    @objc func switchValueDidChange() {
        viewModel.toggleFavourite(favouritesToggle.isOn)
    }
    
    @objc func tappedShowEpisodes() {
        let episodesViewController = EpisodesViewController(episodes: viewModel.showDetails.episodes)
        present(episodesViewController, animated: true, completion: nil)
    }
}

extension ShowDetailsViewController: ShowDetailsViewModelDelegate {
    
}
