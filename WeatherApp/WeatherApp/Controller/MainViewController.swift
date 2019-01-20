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
  var forcasts = [Periods](){
    didSet{
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
 
  private func getPlaceName(zipCode:String) -> String {
    
    ZipCodeHelper.getLocationName(from: zipCode) { (error, placeName) in
   
      if let error = error{
        print(error.localizedDescription)
      }
      if let placeName = placeName {
       self.place = placeName
        dump(placeName)
      }
    }
    return place
  }
  private func setUpMainUi(){
    self.welcomeLabel.text = "Welcome to World Weather"
    self.promptLabel.text = "Please enter you Zipcode"
  }
}
extension MainViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 7
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = weatherCollection.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as? WeatherCollectionViewCell else {return UICollectionViewCell()}
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize.init(width: 200, height: 250)
  }
  private func collectForcasts(qurey:String){
    WeatherApiClient.getForcast(qurey: qurey) { (error, forcasts) in
      if let error = error{
        print(error.errorMessage())
      }
      if let forcasts = forcasts{
        self.forcasts = forcasts
        dump(forcasts)
      }
    }
  }
}

extension MainViewController:UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let text = textField.text {
      if let zipcode = Int(text) {
        isZipcode = true
         let placeName =  getPlaceName(zipCode: String(zipcode))
        collectForcasts(qurey: placeName)
      }else {
        isZipcode = false
        print("not a zipcode")
       
      }
    }
    return true
  }
}
