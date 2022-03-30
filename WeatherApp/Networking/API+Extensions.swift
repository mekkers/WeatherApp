//
//  API+Extensions.swift
//  WeatherApp
//
//  Created by igor mekkers on 29.03.2022.
//

import Foundation

extension API {
    static let baseURLString = "https://api.openweathermap.org/data/2.5/"
    
    static func getURLFor(lat: Double, lon: Double) -> String {
        return "\(baseURLString)onecall?lat=\(lat)&lon=\(lon)&exlude=minutely&appid=\(key)&units=metric"
    }
}
