//
//  ForcatsApiClient.swift
//  WeatherApp
//
//  Created by Ashli Rankin on 1/19/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation
final class WeatherApiClient{
  static func getForecast(qurey:String,completionHandler: @escaping (AppError?,[Periods]?) -> Void){
    NetworkHelper.shared.performDataTask(endpointURLString: SecretKeys.weatherEndpointString(qurey: qurey), httpMethod: "GET", httpBody: nil) { (error, data, response) in
          
      if let error = error {
  completionHandler(AppError.badURL(error.errorMessage()),nil)
      }
      if let data = data {
        do {
          let forecasts = try JSONDecoder().decode(Weather.self, from: data).response.first?.periods
        dump(forecasts)
      completionHandler(nil,forecasts)
        } catch {
          completionHandler(AppError.decodingError(error),nil)
        }
      }
    }
  }
  static func getRelatedImageUrl(qurey:String,completionHandler: @escaping (AppError?,ImageData?) -> Void){
    NetworkHelper.shared.performDataTask(endpointURLString: SecretKeys.pixabyEndpointString(qurey: qurey), httpMethod: "GET", httpBody: nil) { (error, data, response) in
      if let error = error {
  completionHandler(AppError.badURL(error.errorMessage()),nil)
      }
  if let data = data{
        do{
        let imageData = try JSONDecoder().decode(AllImages.self, from: data).hits.randomElement()
          completionHandler(nil,imageData)
        } catch {
          completionHandler(AppError.decodingError(error),nil)
        }
        }
    }
  }
}
