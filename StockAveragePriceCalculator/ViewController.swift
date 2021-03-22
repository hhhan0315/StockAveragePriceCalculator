//
//  ViewController.swift
//  StockAveragePriceCalculator
//
//  Created by 한승래 on 2021/03/05.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var finalPriceField: UITextField!
    @IBOutlet weak var finalAmountField: UITextField!
    @IBOutlet weak var finalTotalPriceField: UITextField!
    @IBOutlet weak var finalPercentField: UITextField!
    
    @IBOutlet weak var currentPriceField: UITextField!
    @IBOutlet weak var currentAmountField: UITextField!
    @IBOutlet weak var currentTotalPriceField: UITextField!
    @IBOutlet weak var currentPercentField: UITextField!
    
    @IBOutlet weak var addPriceField: UITextField!
    @IBOutlet weak var addAmountField: UITextField!
    @IBOutlet weak var addTotalPriceField: UITextField!
    
    private let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextField()
        userDefaultsClear()
        
        currentPriceField.addTarget(self, action: #selector(currentPriceEdit), for: .editingChanged)
        currentAmountField.addTarget(self, action: #selector(currentAmountEdit), for: .editingChanged)
        addPriceField.addTarget(self, action: #selector(addPriceEdit), for: .editingChanged)
        addAmountField.addTarget(self, action: #selector(addAmountEdit), for: .editingChanged)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setTextField() {
        currentPriceField.delegate = self
        currentAmountField.delegate = self
        addPriceField.delegate = self
        addAmountField.delegate = self
        
//        currentPriceField.keyboardType = .
        
//        currentPriceField.tag = 1
//        currentAmountField.tag = 2
//        addPriceField.tag = 3
//        addAmountField.tag = 4
        
//        currentPriceField.addButton()
//        currentAmountField.addButton()
//        addPriceField.addButton()
//        addAmountField.addButton()
    }
    
    func userDefaultsClear() {
        userDefaults.set(0, forKey: "currentPrice")
        userDefaults.set(0, forKey: "currentAmount")
        userDefaults.set(0, forKey: "addPrice")
        userDefaults.set(0, forKey: "addAmount")
        userDefaults.set(0, forKey: "currentSum")
        userDefaults.set(0, forKey: "addSum")
    }
    
    func makeCommaString(num: Double) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        let formatString = numberFormatter.string(from: NSNumber(value: num))
        return formatString
    }
    
    @objc func currentPriceEdit() {
        guard let commaRemovedPrice = currentPriceField.text?.replacingOccurrences(of: ",", with: "") else { return }
        
        guard let currentPrice = Double(commaRemovedPrice) else {
            userDefaults.set(0, forKey: "currentPrice")
            currentTotalPriceField.text = .none
            currentPercentField.text = .none
            checkFinalField()
            return
        }
        
        userDefaults.set(currentPrice, forKey: "currentPrice")
        
        checkCurrentTotalField()
        checkCurrentPercentField()
        checkFinalField()
    }
    
    @objc func currentAmountEdit() {
        guard let commaRemovedAmount = currentAmountField.text?.replacingOccurrences(of: ",", with: "") else { return }
        
        guard let currentAmount = Int(commaRemovedAmount) else {
            userDefaults.set(0, forKey: "currentAmount")
            currentTotalPriceField.text = .none
            checkFinalField()
            return
        }
        
        userDefaults.set(currentAmount, forKey: "currentAmount")
        
        checkCurrentTotalField()
        checkFinalField()
    }
    
    @objc func addPriceEdit() {
        guard let commaRemovedPrice = addPriceField.text?.replacingOccurrences(of: ",", with: "") else { return }
        
        guard let addPrice = Double(commaRemovedPrice) else {
            userDefaults.set(0, forKey: "addPrice")
            addTotalPriceField.text = .none
            currentPercentField.text = .none
            checkFinalField()
            return
        }
        
        userDefaults.set(addPrice, forKey: "addPrice")

        checkAddTotalField()
        checkCurrentPercentField()
        checkFinalField()
    }
    
    @objc func addAmountEdit() {
        guard let commaRemovedAmount = addAmountField.text?.replacingOccurrences(of: ",", with: "") else { return }
        
        guard let addAmount = Int(commaRemovedAmount) else {
            userDefaults.set(0, forKey: "addAmount")
            addTotalPriceField.text = .none
            checkFinalField()
            return
        }
        
        userDefaults.set(addAmount, forKey: "addAmount")
        
        checkAddTotalField()
        checkFinalField()
    }
    
    func checkCurrentTotalField() {
        let currentPrice = userDefaults.double(forKey: "currentPrice")
        let currentAmount = userDefaults.double(forKey: "currentAmount")
        
        if currentPrice == 0 || currentAmount == 0 {
            currentTotalPriceField.text = .none
        } else {
            let currentSum = currentPrice * currentAmount
            userDefaults.set(currentSum, forKey: "currentSum")
            currentTotalPriceField.text = makeCommaString(num: Double(currentSum))
        }
    }
    
    func checkAddTotalField() {
        let addPrice = userDefaults.double(forKey: "addPrice")
        let addAmount = userDefaults.double(forKey: "addAmount")
        
        if addPrice == 0 || addAmount == 0 {
            addTotalPriceField.text = .none
        } else {
            let addSum = addPrice * addAmount
            userDefaults.set(addSum, forKey: "addSum")
            addTotalPriceField.text = makeCommaString(num: Double(addSum))
        }
    }
    
    func checkFinalField() {
        let currentPrice = userDefaults.double(forKey: "currentPrice")
        let currentAmount = userDefaults.double(forKey: "currentAmount")
        let addPrice = userDefaults.double(forKey: "addPrice")
        let addAmount = userDefaults.double(forKey: "addAmount")
        
        if currentPrice == 0 || addPrice == 0 || currentAmount == 0 || addAmount == 0 {
            finalPriceField.text = .none
            finalAmountField.text = .none
            finalTotalPriceField.text = .none
            finalPercentField.text = .none
        } else {
            let currentSum = userDefaults.double(forKey: "currentSum")
            let addSum = userDefaults.double(forKey: "addSum")
            let average = (currentSum + addSum) / (currentAmount + addAmount)
            let percent = ((Double(addPrice) / Double(average)) - 1) * 100
            finalTotalPriceField.text = makeCommaString(num: Double(currentSum + addSum))
            finalAmountField.text = makeCommaString(num: Double(currentAmount + addAmount))
            finalPriceField.text = makeCommaString(num: Double(average))
            finalPercentField.text = makeCommaString(num: percent)
        }
    }
    
    func checkCurrentPercentField() {
        let currentPrice = userDefaults.double(forKey: "currentPrice")
        let addPrice = userDefaults.double(forKey: "addPrice")
        
        if currentPrice == 0 || addPrice == 0 {
            currentPercentField.text = .none
        } else {
            let percent = ((addPrice / currentPrice) - 1) * 100
            currentPercentField.text = makeCommaString(num: percent)
        }
    }
    
    @IBAction func touchClearButton(_ sender: UIBarButtonItem) {
        self.userDefaultsClear()
        finalPriceField.text = .none
        finalAmountField.text = .none
        finalTotalPriceField.text = .none
        finalPercentField.text = .none
        currentPriceField.text = .none
        currentAmountField.text = .none
        currentTotalPriceField.text = .none
        currentPercentField.text = .none
        addPriceField.text = .none
        addAmountField.text = .none
        addTotalPriceField.text = .none
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 3
        
        guard let commaRemovedText = textField.text?.replacingOccurrences(of: ",", with: "") else {
            return false
        }
        
        var combinedText = commaRemovedText + string
        
        // backspace 입력받았을 때
        if string.isEmpty || combinedText.count > 9 {
            // 마지막 하나만 남았을 경우
            if combinedText.count == 1 {
                textField.text = .none
                textField.sendActions(for: .editingChanged)
                return false
            }
            
            let lastIndex = combinedText.index(combinedText.endIndex, offsetBy: -1)
            combinedText = String(combinedText[..<lastIndex])
        }
        
        guard let formatNumber = numberFormatter.number(from: combinedText) else {
            return false
        }
        
        guard var formatString = numberFormatter.string(from: formatNumber) else {
            return false
        }
        
        if string == "." {
            if !(formatString.contains(".")) {
                formatString.append(".")
            }
        }
        textField.text = formatString
        textField.sendActions(for: .editingChanged)
        return false
    }
}

//extension UITextField {
//
//    func addButton() {
//        let toolbar = UIToolbar()
//        toolbar.barStyle = .default
//
//        let up = UIBarButtonItem(image: UIImage(systemName: "chevron.up"), style: .plain, target: self, action: nil)
//        let down = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: nil)
//        let up = UIBarButtonItem(image: UIImage(systemName: "chevron.up"), style: .plain, target: self, action: #selector(goToPrevField))
//        let down = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(goToNextField))
        
//        toolbar.items = [up, down]
//        toolbar.sizeToFit()
//        self.inputAccessoryView = toolbar
//    }
    
//    @objc func goToPrevField() {
//        self.resignFirstResponder()
//        let prevFieldTag = self.tag - 1
//        print(prevFieldTag)
//        if let prevField = self.superview?.superview?.viewWithTag(prevFieldTag) as? UITextField  {
//            prevField.becomeFirstResponder()
//            print("y")
//        } else {
//            self.becomeFirstResponder()
//            print("n")
//        }
//    }
//
//    @objc func goToNextField() {
//        self.resignFirstResponder()
//        let nextFieldTag = self.tag + 1
//        print(nextFieldTag)
//        if let nextField = self.superview?.viewWithTag(nextFieldTag) as? UITextField {
//            nextField.becomeFirstResponder()
//            print("y")
//        } else {
//            self.becomeFirstResponder()
//            print("n")
//        }
//    }
//}
