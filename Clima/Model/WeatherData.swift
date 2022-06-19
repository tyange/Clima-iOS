//
//  WeatherData.swift
//  Clima
//
//  Created by 유태양 on 2022/06/15.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

// API를 통해 받는 WeatherData의 구조를 선언하여 만듬.
// 아래에서 선언된 모든 프로퍼티의 이름은 받아오는 JSON 데이터의 프로퍼티 이름과 일치해야 한다.
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
