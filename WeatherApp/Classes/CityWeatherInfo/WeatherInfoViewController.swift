//
//  CityWeatherInfoViewController.swift
//  weatherApp
//
//  Created by Pavel Vasylchenko on 9/16/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation
import UIKit
import Charts


class WeatherInfoViewController: UIViewController {
    
    private enum CellID {
        static let weatherInfoCell = "WeatherInfoCell"
    }

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var currentWeatherLabel: UILabel!
    @IBOutlet private weak var currentTempLabel: UILabel!
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var weekButton: UIButton!
    @IBOutlet private weak var twoWeeksButton: UIButton!
    @IBOutlet private weak var monthButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var chartView: LineChartView!
    
    var presenter: WeatherInfoPresenterProtocol?
    
    var output: WeatherInfoViewOutput?
    
    var isCelsius: Bool = true
    
    private var weatherInfo = [DailyWeatherEntity]()
    
    private var itemsPerRow: CGFloat {return CGFloat(self.weatherInfo.count)}
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    private var lineChartEntry = [ChartDataEntry]()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewLoaded()
        self.setupView()
        self.intervalButtonTapped(weekButton)
        self.chartView.delegate = self
    }
    
    fileprivate func setupView() {
        
        
        closeButton.tintColor = UIColor.white
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        output?.dismissViewController()
    }
    
    func displayWeather (result: [DailyWeatherEntity]) {
        self.chartView.data?.clearValues()
        self.lineChartEntry.removeAll()
        self.weatherInfo = result
        for day in 0..<weatherInfo.count {
            let weather = weatherInfo[day]
            var tmp = weather.apparentTemperature
            if isCelsius {
                tmp = Double(convertToCelsius(from: Int(tmp)))
            }
            self.setupChart(day, tmp)
        }
        collectionView.reloadData()
    }
    
    func displayName(name: String) {
        self.cityLabel.text = name
    }
    
    func displayCurrentWeather(weather: WeatherEntity) {
        self.currentWeatherLabel.text = weather.summary
        if isCelsius {
            self.currentTempLabel.text = String(convertToCelsius(from: Int(weather.temperature))) + "°"
        } else {
            self.currentTempLabel.text = String(Int(weather.temperature)) + "°"
        }
        if let icon = weather.icon {
            self.weatherImageView.image = UIImage(named: icon)
        }
    }
    
}

extension WeatherInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return (self.cityData?.daily?.allObjects.count)!
        return weatherInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.weatherInfoCell,
                                                      for: indexPath) as! WeatherCollectionViewCell
        let weather = weatherInfo[indexPath.row]
        
        cell.setupCell(from: weather, and: presenter?.getDates(index: indexPath.row) ?? Date(), isCelsius)
        return cell
    }
}

// MARK: IntervalButton Click

extension WeatherInfoViewController {
    
    @IBAction private func intervalButtonTapped(_ sender: UIButton) {
        var activeButton: UIButton?
        var inactiveButtons: [UIButton]
        switch sender {
        case weekButton:
            self.clearCollectionViewCellSelection()
            activeButton = weekButton
            presenter?.setRange(range: .oneWeek)
            inactiveButtons = [twoWeeksButton, monthButton]
        case twoWeeksButton:
            self.clearCollectionViewCellSelection()
            activeButton = twoWeeksButton
            presenter?.setRange(range: .twoWeeks)
            inactiveButtons = [weekButton, monthButton]
        case monthButton:
            self.clearCollectionViewCellSelection()
            activeButton = monthButton
            presenter?.setRange(range: .monthe)
            inactiveButtons = [weekButton, twoWeeksButton]
        default:
            self.clearCollectionViewCellSelection()
            inactiveButtons = [weekButton, twoWeeksButton, monthButton]
        }
        
        if let isActiveButton = activeButton {
            setupActiveButton(isActiveButton)
        }
        setupInactiveButtons(inactiveButtons)
    }
    
    private func setupInactiveButtons(_ buttons: [UIButton]) {
        for button in buttons {
            button.backgroundColor = view.backgroundColor
            button.layer.borderWidth = 1
            button.titleLabel?.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    private func setupActiveButton(_ activeButton: UIButton) {
        activeButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        activeButton.titleLabel?.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        activeButton.layer.borderWidth = 0
        activeButton.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
    }
}

extension WeatherInfoViewController: ChartViewDelegate {
    
    private func setupChart(_ date: Int, _ temp: Double) {
        lineChartEntry.append(ChartDataEntry(x: Double(date), y: temp))
            let set1 = LineChartDataSet(values: lineChartEntry, label: "DataSet 1")
            set1.valueTextColor = UIColor.white
            let data = LineChartData(dataSet: set1)
            self.chartView.data = data
    }
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        let pos = NSInteger(entry.x)
        
        let indexPath = IndexPath(item: Int(lineChartEntry[pos].x), section: 0)
        
        self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [.centeredVertically, .centeredHorizontally])
        
    }
    
    private func clearCollectionViewCellSelection() {
        for index in 0..<weatherInfo.count {
            let indexPath = IndexPath(item: index, section: 0)
            self.collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.black
        }
    }
}
