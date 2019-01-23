//
//  DetailledWeatherViewController.swift
//  WeatherApp
//
//  Created by Ashli Rankin on 1/18/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class DetailledWeatherViewController: UIViewController {
  
  @IBOutlet weak var welcomeLabel: UILabel!
  @IBOutlet weak var cityImage: UIImageView!
  
  @IBOutlet weak var weatherDescription: UILabel!
  override func viewDidLoad() {
        super.viewDidLoad()
welcomeLabel.text = "Weather forecast for \(placeName.replacingOccurrences(of: "%20", with: " ")) on date"
    setUpUi()
    }
  var place: Periods!
  private func UiImageToData(image:UIImage) -> Data?{
    let imageData = image.jpegData(compressionQuality: 0.5)
    return imageData
  }
  
  @IBAction func savedButtonPressed(_ sender: UIBarButtonItem) {
    if let data = UiImageToData(image: self.cityImage.image!){
      let forcast = ForecastModel.init(imageData: data, placeName: placeName)
      DirectoryManager.addItem(item: forcast)
    }
  }
  
  var placeName = "" {
    didSet{
      getImagePath(qurey: placeName)
    }
  }
  
  private func setUpUi(){
    self.weatherDescription.text = """
    This day is \(place.weather)
    
    Feels like  \(place.avgFeelslikeF)
    
    
    High: \(place.maxTempF)
    
    
    Low:  \(place.minTempF)
    """
  }
private func getImagePath(qurey:String){
    WeatherApiClient.getRelatedImageUrl(qurey: qurey) { (error, path) in
      if let error = error{
        print(error.errorMessage())
      }
      if let path = path {
        self.getImage(path: path.largeImageURL)
      }
    }
  }
private func getImage(path:URL){
    do{
    let data = try Data.init(contentsOf: path)
      DispatchQueue.main.async {
         self.cityImage.image = UIImage(data: data)
      }
    }catch{
      print("not path found")
    }
  }

}
