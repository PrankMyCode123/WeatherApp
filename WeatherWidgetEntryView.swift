//
//  WeatherWidgetEntryView.swift
//  midApp
//
//  Created by Phương An on 12/11/2024.
//
import SwiftUI
import WidgetKit
struct WeatherWidgetEntryView: View {
    var entry: Widget_Provider.Entry
    @EnvironmentObject var store: Store
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                Text(entry.weather.city)
                    .fontWeight(.bold)
                
                HStack {
                    Image(systemName: "sunrise")
                    Text(entry.weather.sunrise.formatAsString())
                }
                .font(.footnote)
                .foregroundColor(.gray)
            }
            Spacer()
            
            // Display weather icon
            if let iconURL = URL(string: Constants.Urls.weatherURLAsStringByIcon(icon: entry.weather.icon)) {
                AsyncImage(url: iconURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                } placeholder: {
                    ProgressView()
                }
            }
            
            // Display temperature with selected unit
            Text("\(Int(entry.weather.temperature))\(String(store.selectedUnit.displayText.prefix(1)))")
                .font(.headline)
        }
        .padding()
        .background(Color(red: 0.913, green: 0.934, blue: 0.981))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}
