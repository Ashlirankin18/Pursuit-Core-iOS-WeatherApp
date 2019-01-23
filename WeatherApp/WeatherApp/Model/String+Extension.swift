//
//  String+Extension.swift
//  WeatherApp
//
//  Created by Ashli Rankin on 1/22/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation
extension String {
  public func formatFromISODateString(dateFormat: String) -> String {
    let isoDateFormatter = ISO8601DateFormatter()
    var formattedDate = self
    if let date = isoDateFormatter.date(from: self) {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = dateFormat
      formattedDate = dateFormatter.string(from: date)
    }
    return formattedDate
  }
  
  public func dateFromISODateString() -> Date {
    let isoDateFormatter = ISO8601DateFormatter()
    var date = Date()
    if let isoDate = isoDateFormatter.date(from: self) {
      date = isoDate
    }
    return date
  }
}
