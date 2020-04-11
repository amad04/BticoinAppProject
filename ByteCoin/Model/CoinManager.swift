import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoinPrice (price : String, currency : String)
    
    func didFailWithError(error : Error)
    
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "DD079C4D-733D-499F-92CC-B04C9A47E7FC"
    
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate : CoinManagerDelegate?

    func getCoinPrice(for currency : String) {
       // print (currency)
        let finalUrl = "\(baseURL)/\(currency)?apikey=\(apiKey)"
       // print (finalUrl)
        performRequest(with: finalUrl, currency: currency)
        
    }
    
    func performRequest(with urlString : String, currency : String) {
        
        if let url = URL(string: urlString){
        
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, urlResponse, error) in
                if (error != nil){
                    
                }
                
                if let safeData = data {
                   // var backToString = String(data: safeData, encoding: String.Encoding.utf8) as String?

                   // print ("SafeData" , backToString)
                    if let bitcoinPrice = self.parseJson(safeData) {
                        print (bitcoinPrice)
                        let priceToString = String(format: "%.1f", bitcoinPrice)
                        
                        self.delegate?.didUpdateCoinPrice(price: priceToString, currency: currency)
                    }
                }
            }
            task.resume()
        
        }
        
    }
    
    func parseJson (_ data : Data) -> Double?{
        let decoder = JSONDecoder()
            
            do {
                let decodeData = try decoder.decode(CoinData.self, from: data)
                let lastPrice = decodeData.rate
               
             //   let bitCoin = BitCoinData(rate: lastPrice)
                
                return lastPrice
               
            }
            catch {
                delegate?.didFailWithError(error: error)
                return 0.0
            }
        
    }
    
}
