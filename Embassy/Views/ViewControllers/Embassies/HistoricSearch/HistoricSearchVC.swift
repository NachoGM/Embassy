//
//  HistoricSearchVC.swift
//  Embassy
//
//  Created by Nacho González Miró on 24/03/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit
import CoreData

class HistoricSearchVC: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noSearchLb: UILabel!
    @IBOutlet weak var restoreFilters: UIBarButtonItem!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    // MARK: Global variables
    var embassyList = [Embassy]()
    var serviceDb = ServiceDataBase()
    
    // MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        restoreFilters.isEnabled = false
        setTableView()
        displayMenuBtn(button: menuBtn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NSLog("Estás en HistoricSearch VC")
        embassyList = serviceDb.loadEmbassy(isSearched: true)
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableFooterView?.backgroundColor = .groupTableViewBackground
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embassyViewedDetail" {
            let destinationVC = segue.destination as! EmbassyViewedDetailVC
            destinationVC.embassy = sender as? Embassy
            destinationVC.modalTransitionStyle = .crossDissolve
            destinationVC.modalPresentationStyle = .overCurrentContext
        }
    }

    // MARK: IBActions
    @IBAction func filterTapped(_ sender: UIBarButtonItem) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .red
        searchController.searchBar.placeholder = "Introduce el nombre del Consulado"
        present(searchController, animated: true, completion: nil)
    }
    
    @IBAction func restoreFilters(_ sender: UIBarButtonItem) {
        embassyList = serviceDb.loadEmbassy(isSearched: true)
        tableView.reloadData()
    }
}

extension HistoricSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return embassyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lastSearch") as! HistoricCell
        let embassyViewed = embassyList[indexPath.row]
        cell.setEmbassyViewed(embassyViewed:embassyViewed)
        return cell
    }
}

extension HistoricSearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let embassy = embassyList[indexPath.row]
        self.performSegue(withIdentifier: "embassyViewedDetail", sender: embassy)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

extension HistoricSearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
        
        var filteredEmbassies : [Embassy] = []
        filteredEmbassies = embassyList.filter({$0.name == "Consulado de " + "\(searchBar.text!)"})

        if !filteredEmbassies.isEmpty {
            embassyList = filteredEmbassies

            restoreFilters.isEnabled = true
            restoreFilters.image = UIImage(named: "restore")
            restoreFilters.tintColor = .white
            tableView.reloadData()
        } else {
            restoreFilters.isEnabled = false 
            self.showInformativeErrorMessage(title: "Vaya...", message: "No hemos encontrado ningún resultado. \n\n Por favor, asegúrate de que introduces el nombre del Consulado correctamente.")
            return
        }
    }
}
