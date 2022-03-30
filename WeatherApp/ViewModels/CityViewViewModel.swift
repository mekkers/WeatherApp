//
//  CityViewViewModel.swift
//  WeatherApp
//
//  Created by igor mekkers on 29.03.2022.
//

import SwiftUI
import CoreLocation

final class CityViewViewModel: ObservableObject {
    
    @Published var weather = WeatherResponse.emty()
    
    @Published var city: String = "Anapa" {
        didSet {
            getLocation()
        }
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    private lazy var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    private lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh a"
        return formatter
    }()
    
    init() {
        getLocation()
    }
    
    var date: String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.current.dt)))
    }
    
    var weatherIcon: String {
        if weather.current.weather.count > 0 {
            return weather.current.weather[0].icon
        }
        return "sun.max.fill"
    }
    
    var temperature: String {
        return getTempFor(temp: weather.current.temp)
    }
    
    var conditions: String {
        if weather.current.weather.count > 0 {
            return weather.current.weather[0].main
        }
        return ""
    }
    
    var windSpeed: String {
        return String(format: "%0.1f", weather.current.wind_speed)
    }
    
    var humidity: String {
        return String(format: "%d%%", weather.current.humidity)
    }
    
    var rainChances: String {
        return String(format: "%0.0%%", weather.current.dew_point)
    }
    
    func getTimeFor(timestamp: Int) -> String {
        return timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
    
    func getTempFor(temp: Double) -> String {
        return String(format: "%0.1f", temp)
    }
    
    func getDayFor(timestamp: Int) -> String {
        return dayFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
    
    private func getLocation() {
        CLGeocoder().geocodeAddressString(city) { (placemarks, error) in
            if let places = placemarks, let place = places.first {
                self.getWeather(coord: place.location?.coordinate)
            }
        }
    }
    
    private func getWeather(coord: CLLocationCoordinate2D?) {
        if let coord = coord {
            let urlString = API.getURLFor(lat: coord.latitude, lon: coord.longitude)
            getWeatherInternal(city: city, for: urlString)
        } else {
            let urlString = API.getURLFor(lat: 44.8908, lon: 37.3239)
            getWeatherInternal(city: city, for: urlString)
        }
    }
    
    private func getWeatherInternal(city: String, for urlString: String) {
        NetworkManager<WeatherResponse>.fetch(for: URL(string: urlString)!) { (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.weather = response
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getAnimationFor(icon: String) -> String {
        switch icon {
        case "01d":
            return "dayClearSky"
        case "01n":
            return "nightClearSky"
        case "02d":
            return "dayFewClouds"
        case "02n":
            return "nightFewClouds"
        case "03d":
            return "dayScatteredClouds"
        case "03n":
            return "nightScatteredClouds"
        case "04d":
            return "dayBrokenClouds"
        case "04n":
            return "nightBrokenClouds"
        case "09d":
            return "dayShowerRains"
        case "09n":
            return "nightShowerRains"
        case "10d":
            return "dayRain"
        case "10n":
            return "nightRain"
        case "11d":
            return "dayThunderstorm"
        case "11n":
            return "nightThunderstorm"
        case "13d":
            return "daySnow"
        case "13n":
            return "nightSnow"
        case "50d":
            return "dayMist"
        case "50n":
            return "nightMist"
        default:
            return "dayClearSky"
        }
    }
    
    func getWeatherIconFor(icon: String) -> Image {
        switch icon {
        case "01d":
            return Image(systemName: "sun.max.fill") //dayClearSky
        case "01n":
            return Image(systemName: "moon.fill") //nightClearSky
        case "02d":
            return Image(systemName: "cloud.sun.fill") //dayFewClouds
        case "02n":
            return Image(systemName: "cloud.moon.fill") //nightFewClouds
        case "03d":
            return Image(systemName: "cloud.fill") //dayScatteredClouds
        case "03n":
            return Image(systemName: "cloud.fill") //nightScatteredClouds
        case "04d":
            return Image(systemName: "cloud.fill") //dayBrokenClouds
        case "04n":
            return Image(systemName: "cloud.fill") //nighBtrokenClouds
        case "09d":
            return Image(systemName: "cloud.drizzle.fill") //dayShowerRains
        case "09n":
            return Image(systemName: "cloud.drizzle.fill") //nightShowerRains
        case "10d":
            return Image(systemName: "cloud.heavyrain.fill") //dayRain
        case "10n":
            return Image(systemName: "cloud.heavyrain.fill") //nightRain
        case "11d":
            return Image(systemName: "cloud.bold.fill") //dayThunderstorm
        case "11n":
            return Image(systemName: "cloud.bold.fill") //nightThunderstorm
        case "13d":
            return Image(systemName: "cloud.snow.fill") //daySnow
        case "13n":
            return Image(systemName: "cloud.snow.fill") //nightSnow
        case "50d":
            return Image(systemName: "cloud.fog.fill") //dayMist
        case "50n":
            return Image(systemName: "cloud.fog.fill") //nightMist
        default:
            return Image(systemName: "sun.max.fill") //dayClearSky
        }
    }
}

