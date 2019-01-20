//
//  ForcatsApiClient.swift
//  WeatherApp
//
//  Created by Ashli Rankin on 1/19/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation
final class WeatherApiClient{
  static func getForcast(qurey:String,completionHandler: @escaping (AppError?,[Periods]?) -> Void){
    NetworkHelper.shared.performDataTask(endpointURLString: SecretKeys.weatherEndpointString(qurey: qurey), httpMethod: "GET", httpBody: nil) { (error, data, response) in
      if let error = error {
  completionHandler(AppError.badURL(error.errorMessage()),nil)
      }
      if let data = data {
        do {
          let forcasts = try JSONDecoder().decode(Forcasts.self, from: data).periods
          completionHandler(nil,forcasts)
        } catch {
          completionHandler(AppError.decodingError(error),nil)
        }
      }
    }
  }
}
