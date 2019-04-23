//
//  EmbassyDetailedVC.swift
//  Embassy
//
//  Created by Nacho González Miró on 31/03/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit

class EmbassyDetailedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var embassy : Embassy!
    var serviceDb = ServiceDataBase()
    var detailList : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        detailList = setDetailList()
        saveSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("Estás en EmbassyDetailed VC")
    }
    
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setDetailList() -> [String] {
        return [dateToString(date: Date()), embassy.name ?? "Nombre no disponible", embassy.address ?? "Dirección no disponible", embassy.locality ?? "Localidad no disponible", embassy.metro ?? "Metro no disponible","\(embassy.lat!)", "\(embassy.lng!)"]
    }
    
    func saveSearch() {
        let title = embassy.name ?? "Título no disponible"
        let dateString = dateToString(date: Date())
        let address = embassy.address ?? "Dirección no disponible"
        let locality = embassy.locality ?? "Localidad no disponible"
        let metro = embassy.metro ?? "Metro no disponible"
        let lat = embassy.lat ?? 0.0
        let lng = embassy.lng ?? 0.0
        let accessibility = embassy.accessibility ?? 0.0
        
        serviceDb.saveEmbassy(title: title, streetAddress: address, locality: locality, lat: Double(truncating:lat), lng: Double(truncating:lng), metro: metro, accessibility: Int(truncating:accessibility), dateString: dateString, isSearched: true)
    }
}

extension EmbassyDetailedVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return detailList.count
        case 3:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return headerCell(embassy: embassy)
        case 1:
            return mapCell()
        case 2:
            return detailCell(embassy: embassy, indexPath: indexPath)
        case 3:
            return accessibilityCell(embassy: embassy)
        default:
            return headerCell(embassy: embassy)
        }
    }
    
    // MARK: Handle Cells
    func headerCell(embassy:Embassy) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell") as! TitleCell
        cell.setTitleCell(embassy: embassy)
        return cell
    }
    
    func mapCell() -> MapCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mapCell") as! MapCell
        cell.setMapCell(embassy: embassy)
        return cell
    }
    
    func detailCell(embassy:Embassy, indexPath:IndexPath) -> InfoCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as! InfoCell
        let titleList : [String] = ["Fecha", "Nombre", "Dirección", "Localidad", "Metro", "Latitud", "Longitud"]
        cell.setEmbassyInfo(titleList:titleList, detailList:detailList, indexPath:indexPath)
        return cell
    }
    
    func accessibilityCell(embassy:Embassy) -> AccessibilityCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accessibilityCell") as! AccessibilityCell
        cell.setAccessibilityCell(embassy: embassy)
        return cell
    }
    
}

extension EmbassyDetailedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100.0
        case 1:
            return 250.0
        case 2:
            return 60.0
        case 3:
            return 60.0
        default:
            return 100.0
        }
    }
}
