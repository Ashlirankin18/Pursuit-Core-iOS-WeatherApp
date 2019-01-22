//
//  SecretKeys.swift
//  WeatherApp
//
//  Created by Ashli Rankin on 1/18/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation
final class SecretKeys {
  let weatherkey = "FNBL4NXyZ3OMH88GpDBDZSVumyW3l5P34V3ZvtrU"
  let weatherClientId = "4QNoBUQ6rJUXiD0CkarL1"
  let pixabyKey = "11336352-a987f72672665f4fcf59eba82"
  
  static func weatherEndpointString(qurey:String) -> String {
   let urlString = "http://api.aerisapi.com/forecasts/\(qurey)?client_id=\(SecretKeys().weatherClientId)&client_secret=\(SecretKeys().weatherkey)"
    return urlString.replacingOccurrences(of: " ", with: "%20")

  }
  static func pixabyEndpointString(qurey:String) -> String {
    return "https://pixabay.com/api/?key=\(SecretKeys().pixabyKey)&q=\(qurey)"
  }
}
