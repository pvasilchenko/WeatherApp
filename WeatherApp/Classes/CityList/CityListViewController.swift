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
    
    private enum CellID {
        static let cityCell = "cityCell"
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var celsDegreeButton: UIButton!
    @IBOutlet private weak var fahrDegreeButton: UIButton!
    
    var presenter: CityListPresenterProtocol?
    
    private var isCelsDegree = true
    
    private var citiesArray = [CityEntity]()
    
    var output: CityListViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDegreeTapped(celsDegreeButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        presenter?.updateWeather()
    }
    
    func display(cities: [CityEntity]) {
        self.citiesArray = cities
        self.tableView.reloadData()
    }
    
    @IBAction private func setupDegreeTapped(_ sender: UIButton) {
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
    
    @IBAction private func addCityButtonTapped(_ sender: Any) {
        output?.addCity()
    }
}

extension CityListViewController {
    
    private func setupInactiveButton(_ button: UIButton) {
        button.layer.borderWidth = 1
        button.titleLabel?.textColor = UIColor(red: 224, green: 223, blue: 223, alpha: 1)
    }
    
    private func setupActiveButton(_ activeButton: UIButton) {
        activeButton.titleLabel?.textColor = UIColor.red
        activeButton.setTitleColor(UIColor.red, for: .normal)
        activeButton.layer.borderWidth = 0
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
            presenter?.deleteCity(city: citiesArray[indexPath.row])
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
