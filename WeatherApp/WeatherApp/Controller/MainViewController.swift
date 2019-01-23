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
 
  @IBOutlet weak var aswitch: UISwitch!
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
    let forcast = forcasts[currentIndex]
    destination.placeName = place.replacingOccurrences(of: " ", with: "%20")
    destination.place = forcast
  }
  
 
  
  
  private func getPlaceName(zipCode:String){
    ZipCodeHelper.getLocationName(from: zipCode) { (error, placeName) in
      if let error = error{
        print(error.localizedDescription)
      }
      if let placeName = placeName {
        self.place = placeName
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
      }
    }
  }

  private func storeUserPrefrences(preference:String){
    if let zipCode = UserDefaults.standard.object(forKey: UserDefaultKeys.zipcode) as? String{
      print("There is value: \(zipCode)")
    }else{
      UserDefaults.standard.set(preference, forKey: UserDefaultKeys.zipcode)
      print("there is no value")
    }
  }
  private func checksForZipCode(keyword:String){
    isZipcode = true
    for char in keyword {
      if Int(String(char)) == nil {
        isZipcode = false
        break // not a zip code
      }
    }
  }
}
extension MainViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return forcasts.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   let forcast = forcasts[indexPath.row]
    guard let cell = weatherCollection.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as? WeatherCollectionViewCell else {return UICollectionViewCell()}
    cell.dayLabel.text = forcast.dateTimeISO.formatFromISODateString(dateFormat: "yyyy-MM-d")
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
        checksForZipCode(keyword: text)
    if isZipcode == true {
      collectForcasts(qurey: text)
       getPlaceName(zipCode: text)
    }else {
      let charSet = CharacterSet.symbols
      guard !text.contains(charSet.description) && text.contains(",") && !text.contains(CharacterSet.whitespaces.description) else {return false}
      collectForcasts(qurey: text)
      place = text.capitalized
      }
    }
    return true
  }
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    return true
  }
}
