//
//  EpisodesViewController.swift
//  MoviesApp
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import UIKit
import Models

class EpisodesViewController: UIViewController {
    let episodes: [Episode]
    let cellReuseIdentifier = "EpisodesCell"
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(named: "Hero")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        return view
    }()
    
    init(episodes: [Episode]) {
        self.episodes = episodes
        super.init(nibName: nil, bundle: nil)
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
        view.addSubview(closeButton)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: inset),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            tableView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: inset),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset)
        ])
    }
    
    @objc func dismissTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension EpisodesViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseIdentifier)
        
        let episode = episodes[indexPath.row]
        cell.textLabel?.text = episode.name
        cell.detailTextLabel?.text = episode.summary
        return cell
    }
}
