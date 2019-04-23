//
//  AllEmbassyVC.swift
//  Embassy
//
//  Created by Nacho González Miró on 24/03/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class AllEmbassyVC: UIViewController {
   
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var restoreFilter: UIBarButtonItem!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    // MARK: Global variables
    var serviceDb = ServiceDataBase()
    var serviceParse = ServiceParse()
    var embassyList = [Embassy]()
    var isFirstTime = false
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restoreFilter.isEnabled = false
        
        displayMenuBtn(button:menuBtn)
        setTableView()
        handleEmbassyList()
//        self.tableView.frame.size.width = 4 * (self.tableView.frame.size.width / 3)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NSLog("Estás en AllEmbassy VC")
    }

    func setTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.backgroundColor = .groupTableViewBackground
    }
    
    func handleEmbassyList() {
        let wasLoaded = UserDefaults.standard.bool(forKey: "firstTimeLoaded")
        if wasLoaded {
            embassyList = serviceDb.loadEmbassy(isSearched: false)
        } else {
            if Connectivity.isConnectedToInternet {
                loadEmbassiesAndCouncils()
            } else {
                showInformativeErrorMessage(title: "Error",
                                            message: "Asegurese de que tiene internet e inténtelo de nuevo. \n\n La primera vez que utilice la app, debes tener acceso a internet.")
            }
        }
    }
    
    // MARK: - Load Embassies and Councils for the First Time
    func loadEmbassiesAndCouncils() {
        Alamofire.request(URL_BASE, method: .get).responseData { response in
            switch response.result {
                case .success(let data):
                    do {
                        let parsedData = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                        let graphs = parsedData["@graph"] as! [[String:Any]]
                        self.serviceParse.parseEmbassy(object:graphs)
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }

                self.embassyList = self.serviceDb.loadEmbassy(isSearched: false)
                self.isFirstTime = true
                self.serviceDb.saveInUserDefaults(isLoggedIn: self.isFirstTime, forKey: "firstTimeLoaded")
                
                self.tableView.reloadData()
                
                case .failure(let error):
                self.showInformativeErrorMessage(title: "Atención", message: error.localizedDescription)
            }
        }
    }

    // MARK: - Go to Detail
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let destinationVC = segue.destination as! EmbassyDetailedVC
            destinationVC.embassy = sender as? Embassy
        }
    }
    
    // MARK: - IBActions
    @IBAction func filterTapped(_ sender: UIBarButtonItem) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .red
        searchController.searchBar.placeholder = "Introduce la Embajada o el Consulado"
        present(searchController, animated: true, completion: nil)
    }
    
    @IBAction func restoreFilterTapped(_ sender: UIBarButtonItem) {
        embassyList = serviceDb.loadEmbassy(isSearched: false)
        tableView.reloadData()
    }
    
    @IBAction func menuTapped(_ sender: UIButton) {
        // TODO: Delete it
    }
}

// MARK: - Extensions
extension AllEmbassyVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return embassyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell") as! FavouriteCell
        let embassy = embassyList[indexPath.row]
        cell.setFavouriteEmbassy(embassy: embassy)
        return cell
    }

}

extension AllEmbassyVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let embassySelected = self.embassyList[indexPath.row]
        self.performSegue(withIdentifier: "detail", sender: embassySelected)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        initCellAnimation(cell: cell)
    }
    
    // MARK: Handle Cell Animation
    func initCellAnimation(cell: UITableViewCell) {
        cell.alpha = 0
        
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
    }
}

extension AllEmbassyVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
        
        var filteredEmbassies : [Embassy] = []
        let embassySearched = handleFilterSearch(searchBar: searchBar)
        filteredEmbassies = embassyList.filter({ $0.name?.contains(embassySearched) == true })
        
        if !filteredEmbassies.isEmpty {
            embassyList = filteredEmbassies
            setRestoreFilter(isEnabled: true, color: .white)
            tableView.reloadData()
        } else {
            restoreFilter.isEnabled = false
            setRestoreFilter(isEnabled: false, color: .clear)
            showInformativeErrorMessage(title: "Vaya...", message: "No hemos encontrado ningún resultado. \n\n Por favor, asegúrate de que introduces el nombre del Consulado correctamente.")
            return
        }
    }
    
    func setRestoreFilter(isEnabled:Bool, color:UIColor) {
        restoreFilter.isEnabled = isEnabled
        restoreFilter.image = UIImage(named: "restore")
        restoreFilter.tintColor = color
    }
    
    func handleFilterSearch(searchBar:UISearchBar) -> String {
        var autoCompleteSearchSting = ""
        if searchBar.text!.contains("Consulado") {
            autoCompleteSearchSting = "Consulado de "
        } else if searchBar.text!.contains("Embajada") {
            autoCompleteSearchSting = "Embajada de "
        } else {
            autoCompleteSearchSting = ""
        }
        
        return autoCompleteSearchSting + "\(searchBar.text!)"
    }
}
