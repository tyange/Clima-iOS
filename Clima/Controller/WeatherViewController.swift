//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

// UI와 관련된 프로토콜 외에도
// WeatherManager에서 별도로 정의한 WeatherMangaerDelegate 프로토콜도 채택.
class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        weatherManager.delegate = self
        searchTextField.delegate = self
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type Something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
    
    // 위에서 채택된 WeatherMangerDelegate 프로토콜에 의해,
    // didUpdateWeather 함수는 외부에서 사용할 수 있음.
    
    // 네트워킹(API 호출 등)을 통해 받아온 데이터를 이용하여 UI를 업데이트 할 경우,
    // 네트워크 요청 이후, IOS의 메인 스레드는 네트워크 요청에 대한 기다림 없이 그대로 UI를 업데이트 하려고 시도하기 때문에
    // Javascript의 async-await 패턴과 비슷한 코드 서술이 필요함.
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        // 네트워크 요청에 대한 응답이 올 때까지 메인 스레드를 대기하도록 함.
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temparatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

