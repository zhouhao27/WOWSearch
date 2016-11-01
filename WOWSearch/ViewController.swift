//
//  ViewController.swift
//  WOWSearch
//
//  Created by Zhou Hao on 01/11/16.
//  Copyright © 2016年 Zhou Hao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    var searchController : WOWSearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.searchController = WOWSearchController(searchViewController: nil)
        
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.definesPresentationContext = true
        self.searchController.searchBar.placeholder = "Search in navbar"
        
        self.definesPresentationContext = true
        
        self.navigationItem.titleView = self.searchController.searchBar
        
        self.searchController.customSearchBar.containerBackgroundColor = UIColor.clear
        self.searchController.customSearchBar.textColor = UIColor.white
        self.searchController.customSearchBar.contentBackgroundColor = UIColor.clear
        self.searchController.customSearchBar.placeholderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        self.searchController.customSearchBar.searchIconColor = UIColor.orange
        self.searchController.customSearchBar.contentTintColor = UIColor.white
        self.searchController.customSearchBar.tintColor = UIColor.white
        
        self.searchController.customSearchBar.containerBorderColor = UIColor.orange
        self.searchController.customSearchBar.containerBorderOffset = 5
        self.searchController.customSearchBar.containerBorderWidth = 1
        self.searchController.customSearchBar.containerBottomBorder = true
//        self.searchController.customSearchBar.containerRightBorder = true
//        self.searchController.customSearchBar.containerLeftBorder = true
//        self.searchController.customSearchBar.containerTopBorder = true
        
        self.searchController.searchBar.setImage(UIImage(named:"Clear"), for: UISearchBarIcon.clear, state: .normal)
        self.searchController.searchBar.setImage(UIImage(named:"ClearHighlight"), for: UISearchBarIcon.clear, state: .highlighted)
        self.searchController.customSearchBar.tintForNormalClear = UIColor.orange
    }

    // --- UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController)
    {
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        
        return cell
    }

}

