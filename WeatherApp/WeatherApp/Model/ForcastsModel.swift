//
//  ForcastsModel.swift
//  WeatherApp
//
//  Created by Ashli Rankin on 1/20/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation
struct Response:Codable {
  let response: [Forcasts]
}
struct Forcasts:Codable {
  let periods: [Periods]?
}

struct Periods:Codable {
  let timestamp: Int
  let maxTempF:Int
  let maxTempC:Int
  let minTempF:Int
  let minTempC:Int
  let weather:String
  let icon:String
  let sunriseISO:String
  let sunsetISO:String
  let maxHumidity: Int
  let minHumidity:Int
  let avgFeelsLikeF:Int
  let avgFeelsLikeC: Int
  
}
