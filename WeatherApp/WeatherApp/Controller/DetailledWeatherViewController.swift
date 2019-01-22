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
    }
  @IBAction func savedButtonPressed(_ sender: UIBarButtonItem) {
    
  }
  
  var placeName = ""{
    didSet{
      getImagePath(qurey: placeName)
    }
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
    let data = try  Data.init(contentsOf: path)
      DispatchQueue.main.async {
         self.cityImage.image = UIImage(data: data)
      }
    }catch{
      print("not path found")
    }
  }

}
