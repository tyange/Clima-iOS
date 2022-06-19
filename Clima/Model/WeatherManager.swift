//
//  WeatherManager.swift
//  Clima
//
//  Created by 유태양 on 2022/05/09.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

// WeatherManagerDelegate 프로토콜을 정의.
// WeatherManagerDelegate 프로토콜은 didUpdateWeather 함수를 내장하고 있다.
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=95754d4d0608c8c72868fa85d857b541"
    
    // WeatherManagerDelegate 프로토콜을 그대로 위임.
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // 1. Create URL
        
        if let url = URL(string: urlString) {
            // 2. Create URLSession
            
            let session = URLSession(configuration: .default)
            
            // 3. Give the session task
            
            let task = session.dataTask(with: url) { data, response, error in
                // Swift에서의 클로저 패턴
                // 에러가 났을 경우, 에러를 콘솔에 출력하고 클로저를 빠져 나감.
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                // 정상적으로 데이터를 받았다면, parseJSON 함수를 통해 받아온 JSON 데이터를 파싱.
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        // 위에서 위임 받은 WeatherManagerDelegate에 의해 WeatherManagerDelegate에 내장된
                        // didUpdateWeather 함수를 사용할 수 있음.
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        // JSON 분석기(decoder)를 선언.
        let decoder = JSONDecoder()
        // 자바스크립트의 try & catch 패턴과 유사한 do & catch 패턴을 이용함.
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temparature: temp)
            
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
   
    
}
