//
//  DocumentDirectoryHelper.swift
//  WeatherApp
//
//  Created by Ashli Rankin on 1/22/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation
final class DirectoryManager{
  private static let fileName = "Forecast.plist"
  private static var forecasts = [ForecastModel]()
  
  static func getForecasts() -> [ForecastModel]{
    let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: fileName).path
    if FileManager.default.fileExists(atPath: path){
      if let data =  FileManager.default.contents(atPath: path){
        do{
         forecasts = try PropertyListDecoder().decode([ForecastModel].self, from: data)
        }catch{
          print("Property list decoding error: \(error)")
        }
      }
    }else{
      print("\(fileName) does not exist")
    }
    return forecasts
  }
  static func saveItemsDocumentDirectory(){
    let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: fileName)
    do{
      let data = try PropertyListEncoder().encode(forecasts)
      try data.write(to: path, options: Data.WritingOptions.atomic)
    }catch{
      print("Property list encoding error: \(error)")
    }
  }
  static func addItem(item:ForecastModel){
    forecasts.append(item)
    saveItemsDocumentDirectory()
  }
}
