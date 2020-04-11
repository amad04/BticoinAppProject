import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coninManager = CoinManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coninManager.delegate = self
    }
   

}

extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    //Number of tabel/component
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
    // read the number of rows and assaign to the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          
           return coninManager.currencyArray.count
       }
       
    //ask for the title for the row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return coninManager.currencyArray[row]
       }
    //this will get called every time when user select the picker, when that happeens it will record the row number that was selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           let selectedCurrency = coninManager.currencyArray[row]
           coninManager.getCoinPrice(for: selectedCurrency)
           
       }
}

extension ViewController : CoinManagerDelegate {
    func didUpdateCoinPrice(price: String, currency: String) {
        
        DispatchQueue.main.async {
        
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
            
        }
    }
    
    func didFailWithError(error: Error) {
        print (error)
    }
    
    
}

