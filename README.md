import Foundation

  class Store: ObservableObject {
    
    @Published var selectedUnit: TemperatureUnit = .kelvin
    @Published var weatherList: [WeatherViewModel] = [WeatherViewModel]()
    @Published var lastCity : String?
    public init(){
        selectedUnit = UserDefaults.standard.unit
    }
    func addWeather(_ weather: WeatherViewModel) {
        weatherList.append(weather)
        lastCity = weather.city
    }
    
}
