//
//  RelatedImageModel.swift
//  WeatherApp
//
//  Created by Ashli Rankin on 1/22/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation
struct AllImages:Codable{
  let hits:[ImageData]
}
struct ImageData:Codable{
  let largeImageURL:URL
}
