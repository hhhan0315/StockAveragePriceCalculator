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
    
    @objc func currentPriceEdit() {
        guard let commaRemovedPrice = currentPriceField.text?.replacingOccurrences(of: ",", with: "") else { return }
        
        guard let currentPrice = Int(commaRemovedPrice) else {
            userDefaults.set(0, forKey: "currentPrice")
            currentTotalPriceField.text = .none
            currentPercentField.text = .none
            checkFinalField()
            return
        }
        
        userDefaults.set(currentPrice, forKey: "currentPrice")
        
        checkCurrentField()
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
        
        checkCurrentField()
        checkFinalField()
    }
    
    @objc func addPriceEdit() {
        guard let commaRemovedPrice = addPriceField.text?.replacingOccurrences(of: ",", with: "") else { return }
        
        guard let addPrice = Int(commaRemovedPrice) else {
            userDefaults.set(0, forKey: "addPrice")
            addTotalPriceField.text = .none
            currentPercentField.text = .none
            checkFinalField()
            return
        }
        
        userDefaults.set(addPrice, forKey: "addPrice")

        checkAddField()
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
        
        checkAddField()
        checkFinalField()
    }
    
    func makeCommaString(num: Double) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        let formatString = numberFormatter.string(from: NSNumber(value: num))
        return formatString
    }
    
    func checkCurrentField() {
        let currentPrice = userDefaults.integer(forKey: "currentPrice")
        let currentAmount = userDefaults.integer(forKey: "currentAmount")
        
        if currentPrice == 0 || currentAmount == 0 {
            currentTotalPriceField.text = .none
        } else {
            userDefaults.set(currentPrice * currentAmount, forKey: "currentSum")
            let currentSum = userDefaults.integer(forKey: "currentSum")
            currentTotalPriceField.text = makeCommaString(num: Double(currentSum))
        }
    }
    
    func checkAddField() {
        let addPrice = userDefaults.integer(forKey: "addPrice")
        let addAmount = userDefaults.integer(forKey: "addAmount")
        
        if addPrice == 0 || addAmount == 0 {
            addTotalPriceField.text = .none
        } else {
            userDefaults.set(addPrice * addAmount, forKey: "addSum")
            let addSum = userDefaults.integer(forKey: "addSum")
            addTotalPriceField.text = makeCommaString(num: Double(addSum))
        }
    }
    
    func checkFinalField() {
        let currentPrice = userDefaults.integer(forKey: "currentPrice")
        let currentAmount = userDefaults.integer(forKey: "currentAmount")
        let addPrice = userDefaults.integer(forKey: "addPrice")
        let addAmount = userDefaults.integer(forKey: "addAmount")
        
        if currentPrice == 0 || addPrice == 0 || currentAmount == 0 || addAmount == 0 {
            finalPriceField.text = .none
            finalAmountField.text = .none
            finalTotalPriceField.text = .none
            finalPercentField.text = .none
        } else {
            let currentSum = userDefaults.integer(forKey: "currentSum")
            let addSum = userDefaults.integer(forKey: "addSum")
            let average = (currentSum + addSum) / (currentAmount + addAmount)
            let percent = ((Double(addPrice) / Double(average)) - 1) * 100
            finalTotalPriceField.text = makeCommaString(num: Double(currentSum + addSum))
            finalAmountField.text = makeCommaString(num: Double(currentAmount + addAmount))
            finalPriceField.text = makeCommaString(num: Double(average))
            finalPercentField.text = makeCommaString(num: percent)
            // ㅋ
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
    
    @IBAction func touchResetButton(_ sender: UIBarButtonItem) {
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
        
        guard let commaRemovedText = textField.text?.replacingOccurrences(of: ",", with: "") else {
            return false
        }
        
        var combinedText = commaRemovedText + string
        
        // backspace 입력받았을 때
        if string.isEmpty {
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
        
        let formatString = numberFormatter.string(from: formatNumber)
        textField.text = formatString
        textField.sendActions(for: .editingChanged)
        return false
    }
}

extension UITextField {
    
    func addButton() {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        
        let up = UIBarButtonItem(image: UIImage(systemName: "chevron.up"), style: .plain, target: self, action: nil)
        let down = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: nil)
//        let up = UIBarButtonItem(image: UIImage(systemName: "chevron.up"), style: .plain, target: self, action: #selector(goToPrevField))
//        let down = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(goToNextField))
        
        toolbar.items = [up, down]
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
    
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
}
