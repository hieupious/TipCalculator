//
//  ViewController.swift
//  TipCalculator
//
//  Created by Hoang Trung Hieu on 2/1/16.
//  Copyright © 2016 Hoang Trung Hieu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipAmount: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var tipPercentSlider: UISlider!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet var dataView: UIView!
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var tipPercentDefault: Int!
    var tipPercentMin: Int!
    var tipPercentMax: Int!
    var sliderStep: Int!
    var currencyFormatter: NSNumberFormatter = NSNumberFormatter()
    let MIN_CONST = 10
    let MAX_CONST = 50
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("enterBackground:"), name:UIApplicationDidEnterBackgroundNotification, object: nil)
        self.billField.becomeFirstResponder()
        // Do any additional setup after loading the view, typically from a nib.
        let time = userDefaults.objectForKey("terminatedTime")
        let bill = userDefaults.objectForKey("billAmount")
        if(time != nil && bill != nil) {
            let timeTerminated = time as! NSDate
            let billText = bill as! String
            if(timeTerminated.timeIntervalSinceNow < 600 && billText != "") {
                billField.text = billText
                displayTipAndTotal()
                setValue()
            } else {
                self.tipAmount.alpha = 0
                self.totalAmount.alpha = 0
                self.resultView.alpha = 0
                self.tipPercentSlider.alpha = 0
                self.tipPercentLabel.alpha = 0
            }
        } else {
            self.tipAmount.alpha = 0
            self.totalAmount.alpha = 0
            self.resultView.alpha = 0
            self.tipPercentSlider.alpha = 0
            self.tipPercentLabel.alpha = 0
        }

        
    }
    
    func enterBackground(notification: NSNotification) {
        userDefaults.setObject(billField.text, forKey: "billAmount")
        let date = NSDate()
        userDefaults.setObject(date, forKey: "terminatedTime")
        userDefaults.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.currencyFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        billField.placeholder = currencyFormatter.currencySymbol
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        initializeData()
        assignValue()
        displayTipAndTotal()
        setValue()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    

    @IBAction func OnEditingChanged(sender: AnyObject) {
        displayTipAndTotal()
        setValue()
        
    }
    
    func setValue() {
        let billAmount = NSString(string: billField.text!).doubleValue
        let tipPercentValue = tipPercentSlider.value
        let tip = (billAmount) * Double(tipPercentValue / 100)
        let total = billAmount + tip
        tipAmount.text = String(format: "\(currencyFormatter.currencySymbol)%.0f", tip)
        totalAmount.text = String(format: "\(currencyFormatter.currencySymbol)%.0f", total)
        billField.placeholder = currencyFormatter.currencySymbol
        tipPercentLabel.text = getTipPercentValue()
    }
    
    @IBAction func TipPercentChanged(sender: UISlider!) {
        let roundedValue = round(sender.value / Float(sliderStep)) * Float(sliderStep)
        sender.value = roundedValue
        setValue()
        
    }
    
    func sliderValueChanged(sender:UISlider!){
        let roundedValue = round(sender.value / Float(sliderStep)) * Float(sliderStep)
        sender.value = roundedValue
    }
    
    func displayTipAndTotal() {
        if((billField.text) != "") {
            UIView.animateWithDuration(0.5, animations: {
                if (self.resultView.alpha == 0) {
                    self.resultView.center.y -= self.view.bounds.height
                }
                
                if(self.tipPercentSlider.alpha == 0 || self.tipPercentLabel.alpha == 0) {
                    self.tipPercentSlider.alpha = 1
                    self.tipPercentLabel.alpha = 1
                }

                self.tipAmount.alpha = 1
                self.totalAmount.alpha = 1
                self.resultView.alpha = 1
            })
        } else {
            UIView.animateWithDuration(0.5, animations: {
                self.tipAmount.alpha = 0
                self.totalAmount.alpha = 0
                self.resultView.alpha = 0
            })
        }
    }
    
    func getTipPercentValue() -> String {
        return String(format: "%.0f %%", tipPercentSlider.value)
    }
    
    func initializeData() {
        // load persistent values
        tipPercentDefault = userDefaults.integerForKey("tipPercentDefault")
        if (tipPercentDefault == 0) {
            tipPercentDefault = 20
            userDefaults.setInteger(tipPercentDefault, forKey: "tipPercentDefault")
        }
        tipPercentMin = userDefaults.integerForKey("tipPercentMin")
        if(tipPercentMin == 0) {
            tipPercentMin = MIN_CONST
            userDefaults.setInteger(tipPercentMin, forKey: "tipPercentMin")
        }
        tipPercentMax = userDefaults.integerForKey("tipPercentMax")
        if(tipPercentMax == 0) {
            tipPercentMax = MAX_CONST
            userDefaults.setInteger(tipPercentMax, forKey: "tipPercentMax")
        }
        sliderStep = userDefaults.integerForKey("sliderStep")
        if(sliderStep == 0) {
            sliderStep = 2
            userDefaults.setInteger(sliderStep, forKey: "sliderStep")
        }
        userDefaults.synchronize()
    }
    
    func assignValue() {
        tipPercentSlider.value = Float(tipPercentDefault!)
        tipPercentSlider.minimumValue = Float(tipPercentMin!)
        tipPercentSlider.maximumValue = Float(tipPercentMax!)
    }
    
}

