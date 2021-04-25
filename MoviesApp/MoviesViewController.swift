//
//  MoviesViewController.swift
//  MoviesApp
//
//  Created by Joanna Zatorska on 17/04/2021.
//

import UIKit

class ShowsViewController: UIViewController {
    
    private var dependencies: Dependencies?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func setup(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

