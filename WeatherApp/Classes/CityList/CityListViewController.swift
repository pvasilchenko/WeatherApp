//
//  CityListViewController.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 9/11/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces
import CoreData

class CityListViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var celsDegreeButton: UIButton!
    @IBOutlet weak var fahrDegreeButton: UIButton!
    
//    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var isCelsDegree = true
    
    var citiesArray = [CityEntity]()
    
    var output: CityListViewOutput?
    
    let coreDataRequest = CoreDataRequests()
    let request = ServerRequests()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.citiesArray = self.coreDataRequest.getCityData()
        self.setupDegreeTapped(celsDegreeButton)
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CityEntity")
//        fetchRequest.sortDescriptors = [
//            NSSortDescriptor(key: "name", ascending: true),
//            NSSortDescriptor(key: "latitude", ascending: true),
//            NSSortDescriptor(key: "longitude", ascending: true)
//        ]
//
//        fetchedResultsController = NSFetchedResultsController (fetchRequest: fetchRequest, managedObjectContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext , sectionNameKeyPath: nil, cacheName: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.output = CityListRouter(vc: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.citiesArray = self.coreDataRequest.getCityData()
        tableView.reloadData()
        self.updateWeather()
    }
    
    func updateWeather() {
        if citiesArray.count > 0 {
            for city in citiesArray {
                request.getWeather(city.value(forKey: Keys.latitude) as! String, city.value(forKey: Keys.longitude) as! String, callback: { results -> Void in
                    self.coreDataRequest.updateCityWeather(city, results)
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    @IBAction func setupDegreeTapped(_ sender: UIButton) {
        switch sender {
        case celsDegreeButton:
            isCelsDegree = true
            setupActiveButton(celsDegreeButton)
            setupInactiveButton(fahrDegreeButton)
        case fahrDegreeButton:
            isCelsDegree = false
            setupActiveButton(fahrDegreeButton)
            setupInactiveButton(celsDegreeButton)
        default:
            isCelsDegree = true
            setupActiveButton(celsDegreeButton)
            setupInactiveButton(fahrDegreeButton)
        }
        tableView.reloadData()
    }
    
    @IBAction func addCityButtonTapped(_ sender: Any) {
        output?.addCity()
    }
}

extension CityListViewController {
    
    func setupInactiveButton(_ button: UIButton) {
            button.layer.borderWidth = 1
            button.titleLabel?.textColor = UIColor(red: 224, green: 223, blue: 223, alpha: 1)
    }
    
    func setupActiveButton(_ activeButton: UIButton) {
        activeButton.titleLabel?.textColor = UIColor.red
        activeButton.setTitleColor(UIColor.red, for: .normal)
        activeButton.layer.borderWidth = 0
//        activeButton.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
    }
}

extension CityListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CityTableViewCell
        let city = self.citiesArray[indexPath.row]
        cell = tableView.dequeueReusableCell(withIdentifier: CellID.cityCell, for: indexPath) as! CityTableViewCell
        cell.reloadRow(city, isCelsDegree)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.displayCityWeather(for: self.citiesArray[indexPath.row], isCelsDegree)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.coreDataRequest.deleteCity(cityForDelete: citiesArray[indexPath.row])
            self.citiesArray.remove(at: indexPath.row)
            tableView.performBatchUpdates({
                tableView.deleteRows(at: [indexPath], with: .fade)
            }, completion: { (completed) in
                if completed {
                    tableView.reloadData()
                }
            })
        }
    }
}
