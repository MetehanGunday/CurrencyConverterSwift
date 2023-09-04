import SwiftUI

struct ContentView: View {
    @State var fromCurrency: String = ""
    @State var toCurrency: String = ""
    @State var amount: String = ""
    @State var result: String = ""
    @State var loading: Bool = false
    @State var apiKey: String = ""
    
    var body: some View {
        TextField("API Key", text: $apiKey)
            .textFieldStyle(.roundedBorder)
            .padding()
        HStack() {
            Picker(selection: $fromCurrency, label: Text("Picker")) {
                Text("Euro").tag("EUR")
                Text("Turkish Liras").tag("TRY")
                Text("United States Dollar").tag("USD")
            }.cornerRadius(20) /// make the background rounded
             .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 1))
            Spacer()
            Picker(selection: $toCurrency, label: Text("Picker")){
                Text("Euro").tag("EUR")
                Text("Turkish Liras").tag("TRY")
                Text("United States Dollar").tag("USD")
            }
            .cornerRadius(20) /// make the background rounded
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 1)
            )
            Spacer()
        }
        .padding()
        TextField("Amount", text: $amount)
            .textFieldStyle(.roundedBorder)
            .padding()
        
        Text($result.wrappedValue)
        
        Button(action: {
            loading = true
            let headers = [
                "X-RapidAPI-Key": $apiKey.wrappedValue,
                "X-RapidAPI-Host": "currency-exchange.p.rapidapi.com"
            ]
            
            let url = URL(string: "https://currency-exchange.p.rapidapi.com/exchange?from=\($fromCurrency.wrappedValue)&to=\($toCurrency.wrappedValue)&q=\($amount.wrappedValue)")!
            var request = URLRequest(url: url)
            
            let session = URLSession(configuration: .default)
            
            headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }
            
            session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                guard let data = data else { return }
                let output = String(data: data, encoding: .utf8)
                let db = Double(output ?? "0")
                result = output ?? "Hesap"
                loading = false
            }.resume()
        }, label: {
            if loading {
                ProgressView()
            } else {
            Text("Hesapla")
            }
            
        }).buttonStyle(.bordered)
        
        

    }
}
