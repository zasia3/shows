//
//  ShowDetailsViewController.swift
//  MoviesApp
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import UIKit

class ShowDetailsViewController: UIViewController {
    private var viewModel: ShowDetailsViewModelProtocol
    
    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        if let url = viewModel.showDetails.show.image?.localUrl {
            imgView.image = UIImage(contentsOfFile: url.path)
        } else {
            imgView.image = UIImage(systemName: "camera.on.rectangle")
            imgView.tintColor = UIColor(named: "Hero")
        }
        return imgView
    }()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.showDetails.show.name
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = UIColor(named: "Hero")
        return label
    }()
    
    lazy var favouritesToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        toggle.onTintColor = UIColor(named: "Accent")
        toggle.accessibilityLabel = "Set favourite"
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
        stack.alignment = .fill
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
        button.setTitleColor(UIColor(named: "Text"), for: .normal)
        return button
    }()
    
    let contentView = UIView()
    
    init(viewModel: ShowDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad () {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    private func setupLayout() {
        favouritesToggle.isOn = viewModel.isFavourite
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        favouriteStackView.addArrangedSubview(favouriteLabel)
        favouriteStackView.addArrangedSubview(favouritesToggle)
        stackView.addArrangedSubview(favouriteStackView)
        stackView.addArrangedSubview(crewLabel)
        stackView.addArrangedSubview(episodesButton)
        
        setupScrollViewLayout()
        setupContentViewLayout()
        setupStackViewLayout()
    }
    
    private func setupScrollViewLayout() {
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        scrollView.constraintHorizontally(to: view)
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func setupContentViewLayout() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.constraintVertically(to: scrollView)
    }
    
    func setupStackViewLayout() {
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        stackView.constraintHorizontally(to: contentView, constant: 5)
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
    
    @objc func switchValueDidChange() {
        viewModel.toggleFavourite(favouritesToggle.isOn)
    }
    
    @objc func tappedShowEpisodes() {
        if viewModel.showDetails.episodes.isEmpty {
            showAlert(message: "No episodes")
            return
        }
        let episodesViewController = EpisodesViewController(episodes: viewModel.showDetails.episodes)
        present(episodesViewController, animated: true, completion: nil)
    }
}
