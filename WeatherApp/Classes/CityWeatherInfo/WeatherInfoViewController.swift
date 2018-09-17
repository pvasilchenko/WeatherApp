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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var twoWeeksButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var chartView: LineChartView!
    
    let formatter = DateFormatter()
    
    var output: WeatherInfoViewOutput?
    
    var cityData: CityEntity?
    var isCelsius: Bool?
    
    var dateArray = [Date]()
    let calendar = Calendar.current
    
    fileprivate var itemsPerRow: CGFloat {return CGFloat(self.cityData?.daily?.allObjects.count ?? 0)}
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    var lineChartEntry = [ChartDataEntry]()
    
    var numberOfItems = 7 {
        didSet {
            self.collectionView.reloadData()
            self.dateArray = getDates()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.intervalButtonTapped(weekButton)
        self.chartView.delegate = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.output = WeatherInfoRouter(vc: self)
    }
    
    func setupView() {
        self.cityLabel.text = cityData?.name
        self.currentWeatherLabel.text = cityData?.currently?.summary
        if let temp = cityData?.currently?.temperature {
            if isCelsius ?? true {
                self.currentTempLabel.text = String(convertToCelsius(from: Int(temp))) + "°"
            } else {
                self.currentTempLabel.text = String(Int(temp)) + "°"
            }
        }
        if let icon = cityData?.currently?.icon {
            self.weatherImageView.image = UIImage(named: icon)
        }
        closeButton.tintColor = UIColor.white
    }
    
    func convertToCelsius(from fahrenheit: Int) -> Int {
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }

    
    @IBAction func closeButtonTapped(_ sender: Any) {
        output?.dismissViewController()
    }
}

extension WeatherInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return (self.cityData?.daily?.allObjects.count)!
        return numberOfItems
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
        let weather = cityData?.daily?.allObjects[indexPath.row] as! DailyWeatherEntity
        cell.setupCell(from: weather, and: dateArray[indexPath.row], isCelsius ?? true)
//        cell.addImage(galleryItem, galleryItem.mediaType)
        return cell
    }
}

// MARK: IntervalButton Click

extension WeatherInfoViewController {
    
    @IBAction func intervalButtonTapped(_ sender: UIButton) {
        var activeButton: UIButton?
        var inactiveButtons: [UIButton]
        switch sender {
        case weekButton:
            self.clearCollectionViewCellSelection()
            activeButton = weekButton
            inactiveButtons = [twoWeeksButton, monthButton]
            numberOfItems = 7
            self.chartView.data?.clearValues()
            self.lineChartEntry.removeAll()
        case twoWeeksButton:
            self.clearCollectionViewCellSelection()
            if self.cityData?.daily?.allObjects.count ?? 0 > 7 {
                activeButton = twoWeeksButton
                numberOfItems = 14
            }
            inactiveButtons = [weekButton, monthButton]
            self.chartView.data?.clearValues()
            self.lineChartEntry.removeAll()
        case monthButton:
            self.clearCollectionViewCellSelection()
            if self.cityData?.daily?.allObjects.count ?? 0 > 14 {
                activeButton = monthButton
                if self.cityData?.daily?.allObjects.count ?? 0 > 30 {
                    numberOfItems = dateArray.count - 1
                } else {
                    numberOfItems = (self.cityData?.daily?.allObjects.count)!
                }
            } else {
                return
            }
            self.lineChartEntry.removeAll()
            self.chartView.data?.clearValues()
            inactiveButtons = [weekButton, twoWeeksButton]
        default:
            self.clearCollectionViewCellSelection()
            self.lineChartEntry.removeAll()
            self.chartView.data?.clearValues()
            inactiveButtons = [weekButton, twoWeeksButton, monthButton]
        }
        
        for day in 0..<numberOfItems {
            let weather = cityData?.daily?.allObjects[day] as! DailyWeatherEntity
            var tmp = weather.apparentTemperature
            if isCelsius ?? true {
                tmp = Double(convertToCelsius(from: Int(tmp)))
            }
            self.setupChart(day, tmp)
        }
        if let isActiveButton = activeButton {
            setupActiveButton(isActiveButton)
        }
        setupInactiveButtons(inactiveButtons)
        
    }
    
    func setupInactiveButtons(_ buttons: [UIButton]) {
        for button in buttons {
            button.backgroundColor = view.backgroundColor
            button.layer.borderWidth = 1
            button.titleLabel?.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    func setupActiveButton(_ activeButton: UIButton) {
        activeButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        activeButton.titleLabel?.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        activeButton.layer.borderWidth = 0
        activeButton.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
    }
}

// MARK: Setup dayData

extension WeatherInfoViewController {
    
    func getDates() -> [Date] {
        let now = Date()
        var currentDate = previousMonth(date: now)
        var datesArray = [Date]()
        
        while currentDate < now {
            datesArray.append(currentDate)
            currentDate = nextDay(date:currentDate)
        }
        print("result: \(datesArray)")
        
        
        return datesArray
    }
    
    func nextDay(date: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = 1
        return Calendar.current.date(byAdding: dateComponents, to: date)!
    }
    
    func previousMonth(date: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = -1
        return Calendar.current.date(byAdding: dateComponents, to: date)!
    }
    
}


extension WeatherInfoViewController: ChartViewDelegate {
    
    func setupChart(_ date: Int, _ temp: Double) {
        lineChartEntry.append(ChartDataEntry(x: Double(date), y: temp))
            let set1 = LineChartDataSet(values: lineChartEntry, label: "DataSet 1")
            set1.valueTextColor = UIColor.white
            let data = LineChartData(dataSet: set1)
            ChartColorTemplates.pastel()
            self.chartView.data = data
    }
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        let pos = NSInteger(entry.x)
        
        let indexPath = IndexPath(item: Int(lineChartEntry[pos].x), section: 0)
        
        self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [.centeredVertically, .centeredHorizontally])
        
    }
    
    func clearCollectionViewCellSelection() {
        for index in 0..<numberOfItems {
            let indexPath = IndexPath(item: index, section: 0)
            self.collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.black
        }
    }
}
