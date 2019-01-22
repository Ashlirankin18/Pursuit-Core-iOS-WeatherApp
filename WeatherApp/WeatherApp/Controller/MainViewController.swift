//
//  ViewController.swift
//  WeatherApp
//
//  Created by Alex Paul on 1/17/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  @IBOutlet weak var welcomeLabel: UILabel!
  @IBOutlet weak var promptLabel: UILabel!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var weatherCollection: UICollectionView!
  var isZipcode = Bool()
  var place = "" {
    didSet {
      self.welcomeLabel.text = "This is your 7-Day forcast for \(place)"
    }
  }
  var currentIndex = Int()
  var forcasts = [Periods](){
    didSet{
      DispatchQueue.main.async {
         self.weatherCollection.reloadData()
      }
      print("I am set")
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    textField.delegate = self
    weatherCollection.dataSource = self
    weatherCollection.delegate = self
    setUpMainUi()
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let destination = segue.destination as? DetailledWeatherViewController else {return}
    destination.placeName = place.replacingOccurrences(of: " ", with: "%20")
  }
  private func getPlaceName(zipCode:String){
    ZipCodeHelper.getLocationName(from: zipCode) { (error, placeName) in
      if let error = error{
        print(error.localizedDescription)
      }
      if let placeName = placeName {
        self.place = placeName
        print(placeName)
      }
    }
  }
  private func setUpMainUi(){
    self.welcomeLabel.text = "Welcome to World Weather"
    self.promptLabel.text = "Please enter you Zipcode"
  }
  private func collectForcasts(qurey:String){
    WeatherApiClient.getForecast(qurey: qurey) { (error, forcasts) in
      if let error = error{
        print(error.errorMessage())
      }
      if let forcasts = forcasts{
        self.forcasts = forcasts
        dump(forcasts)
      }
    }
  }
//  private func dateFormatter(nonFormattedDate:String) -> String{
//
//
//  }
}
extension MainViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return forcasts.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   let forcast = forcasts[indexPath.row]
    guard let cell = weatherCollection.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as? WeatherCollectionViewCell else {return UICollectionViewCell()}
   cell.dayImage.image = UIImage(named: forcast.icon)
    cell.dayTemp.text = """
    Max Temp: \(forcast.maxTempF)
    Min Temp: \(forcast.minTempF)
    """
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    currentIndex = indexPath.row
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize.init(width: 200, height: 250)
  }
  
}

extension MainViewController:UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let text = textField.text {
     collectForcasts(qurey: text)
      getPlaceName(zipCode: text)
    }
    return true
  }
}
