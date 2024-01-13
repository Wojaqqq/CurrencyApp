//
//  ConverterView.swift
//  CurrencyApp
//
//  Created by Guest User on 15/11/2022.
//

import SwiftUI
import UIKit
import CoreData
	


struct ExchangeRates: Codable {
let rates: [String: Double]
}

struct MyVariables {
    static var ammount_global = 0
    static var result_global = -5
}

struct ConverterView: View {
    
    func country() -> () {
        var countryCode = NSLocale.current.language.region?.identifier
        countryCode = countryCode!
        if countryCode == "US"{
            input_currency = "USD"
        } else if countryCode == "PL"{
            input_currency = "PLN"
        } else {
            input_currency = "PLN"
        }
    }
    
    				
    @State private var ammount:Double = 0
    @State private var ammount_converted:Double = 0
    @State private var rate:Double = 0
    @State private var output_currency =  "EUR"
    @State private var input_currency = "PLN"
    
    let curs = ["USD", "AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG", "AZN", "BAM", "BBD", "BDT", "BGN", "BHD", "BIF", "BMD", "BND", "BOB", "BRL", "BSD", "BTN", "BWP", "BYN", "BZD", "CAD", "CDF", "CHF", "CLP", "CNY", "COP", "CRC", "CUP", "CVE", "CZK", "DJF", "DKK", "DOP", "DZD", "EGP", "ERN", "ETB", "EUR", "FJD", "FKP", "FOK", "GBP", "GEL", "GGP", "GHS", "GIP", "GMD", "GNF", "GTQ", "GYD", "HKD", "HNL", "HRK", "HTG", "HUF", "IDR", "ILS", "IMP", "INR", "IQD", "IRR", "ISK", "JEP", "JMD", "JOD", "JPY", "KES", "KGS", "KHR", "KID", "KMF", "KRW", "KWD", "KYD", "KZT", "LAK", "LBP", "LKR", "LRD", "LSL", "LYD", "MAD", "MDL", "MGA", "MKD", "MMK", "MNT", "MOP", "MRU", "MUR", "MVR", "MWK", "MXN", "MYR", "MZN", "NAD", "NGN", "NIO", "NOK", "NPR", "NZD", "OMR", "PAB", "PEN", "PGK", "PHP", "PKR", "PLN", "PYG", "QAR", "RON", "RSD", "RUB", "RWF", "SAR", "SBD", "SCR", "SDG", "SEK", "SGD", "SHP", "SLE", "SLL", "SOS", "SRD", "SSP", "STN", "SYP", "SZL", "THB", "TJS", "TMT", "TND", "TOP", "TRY", "TTD", "TVD", "TWD", "TZS", "UAH", "UGX", "UYU", "UZS", "VES", "VND", "VUV", "WST", "XAF", "XCD", "XDR", "XOF", "XPF", "YER", "ZAR", "ZMW", "ZW"]
    
    func convert(entry_curr:String = "PLN", exit_curr:String = "EUR") -> Void {
        fetchJson(key: entry_curr, completion: { rates in
            let rate: Double = rates.rates[exit_curr]!
            self.rate = rate
            self.ammount_converted = self.rate * self.ammount
//            DataManager.shared.saveString1(string: entry_curr)
//            DataManager.shared.saveString1(string: exit_curr)
        })
    }
    
    func handle_convert() {
        convert(entry_curr: self.input_currency, exit_curr: self.output_currency)
        
    }

    var body: some View {
        VStack {
            VStack {
                Text("Enter ammount:")
                
                HStack {
                    TextField("", value: $ammount, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                }
                HStack {
                    Text("Enter input currency:")
                    Picker("Input currency", selection: $input_currency) {
                        ForEach(curs, id: \.self) {
                            Text($0)
                        }
                    }
                    
                }
                HStack {
                    Text("Enter output currency:")
                    Picker("Output currency", selection: $output_currency) {
                        ForEach(curs, id: \.self) {
                            Text($0)
                        }
                    }
                }
                Spacer()
                Button(action: {handle_convert()},
                       label: {Text("Convert").fontWeight(.heavy).foregroundColor(Color.white).padding().background(Color.blue).cornerRadius(15)}
                )
                Spacer()
                VStack {
                    Text("Result:")
                    	
                    TextField("", value: $ammount_converted, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .padding()

                }
                Spacer()
                
            }
        }.onAppear{self.country()}
    }
    
    struct ConverterViewPreviews: PreviewProvider {
        static var previews: some View {
            ConverterView()
            
        }
    }
    
    func fetchJson(key: String = "PLN", completion: @escaping (ExchangeRates) -> ()) {
        guard let url = URL(string: "https://open.er-api.com/v6/latest/\(String(describing: key))") else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let safeData = data else {return}
            
            do {
                let results = try JSONDecoder().decode(ExchangeRates.self, from: safeData)
                completion(results)
            } catch {
                print(error)
            }
            
        }.resume()
    }
}
	
