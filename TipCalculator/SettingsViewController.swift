//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by Hoang Trung Hieu on 2/9/16.
//  Copyright © 2016 Hoang Trung Hieu. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var settingsTableView: UITableView!
    
    var tipPercentDefault: Int = 0
    var tipPercentMin: Int = 0
    var tipPercentMax: Int = 0
    var sliderStep: Int = 0
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let MIN_CONST = 10
    let MAX_CONST = 50
    
    let textCellIdentifier = "UITableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set for tableView
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        self.settingsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: textCellIdentifier)
        loadData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return 3
        } else if (section == 1) {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // initial uitalbeviewcell
        //let cell:UITableViewCell = self.settingsTableView.dequeueReusableCellWithIdentifier(textCellIdentifier)! as UITableViewCell
        let cell:UITableViewCell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: textCellIdentifier)
        // create textfield and set properties for each cell
        let textField:UITextField = UITextField.init(frame: cell.frame)
        print(cell.frame)
        textField.adjustsFontSizeToFitWidth = true
        
        textField.textAlignment = NSTextAlignment.Right
        textField.keyboardType = UIKeyboardType.NumberPad
        textField.delegate = self
        cell.addSubview(textField)
        if(indexPath.section == 0) {
            textField.placeholder = "%"
            switch (indexPath.row) {
            case 0:
                cell.textLabel?.text = "Default"
                textField.text = "\(tipPercentDefault)"
                textField.addTarget(self, action: "tipPercentDefaultEditing:", forControlEvents: UIControlEvents.EditingDidEnd)
                break
            case 1:
                cell.textLabel?.text = "Minimum"
                textField.text = "\(tipPercentMin)"
                textField.addTarget(self, action: "tipPercentMinEditing:", forControlEvents: UIControlEvents.EditingDidEnd)
                break
            case 2:
                cell.textLabel?.text = "Maximum"
                textField.text = "\(tipPercentMax)"
                textField.addTarget(self, action: "tipPercentMaxEditing:", forControlEvents: UIControlEvents.EditingDidEnd)
                break
            default: break
                
            }
        } else if (indexPath.section == 1) {
            cell.textLabel?.text = "Step"
            textField.text = "\(sliderStep)"
            textField.addTarget(self, action: "sliderStepEditing:", forControlEvents: UIControlEvents.EditingDidEnd)
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Tip Percentage"
        }
        else if (section == 1) {
            return "Slider"
        } else {
            return ""
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tipPercentDefaultEditing(textField: UITextField) {
        let value = Int(textField.text!)
        if (value == nil) {
            textField.text = "\(tipPercentDefault)"
        } else {
            validateInputValue("default", value: value!)
        }

        
    }
    
    func tipPercentMinEditing(textField: UITextField) {
        let value = Int(textField.text!)
        if(value == nil) {
            textField.text = "\(tipPercentMin)"
        } else {
            validateInputValue("min", value: value!)
        }
    }
    
    func tipPercentMaxEditing(textField: UITextField) {
        let value = Int(textField.text!)
        if(value == nil) {
            textField.text = "\(tipPercentMax)"
        } else {
            validateInputValue("max", value: value!)
        }
    }
    
    func sliderStepEditing(textField: UITextField) {
        let value = Int(textField.text!)
        if(value == nil) {
            textField.text = "\(sliderStep)"
        } else {
            validateInputValue("step", value: value!)
        }
    }
    
    func validateInputValue(inputType: String, var value: Int) {
        if(inputType == "default") {
            if(value > tipPercentMax) {
                value = tipPercentMax
            } else if (value < tipPercentMin) {
                value = tipPercentMin
            }
            tipPercentDefault = value
        } else if(inputType == "min") {
            if (value > tipPercentDefault) {
                value = tipPercentDefault
            }
            if (value > tipPercentMax - 10) {
                value = tipPercentMax - 10
            }
            
            if(value < MIN_CONST) {
                value = MIN_CONST
            }
            tipPercentMin = value
        } else if(inputType == "max") {
            if(value < tipPercentDefault) {
                value = tipPercentDefault
            }
            if(value < tipPercentMin + 10) {
                value = tipPercentMin + 10
            }
            if(value > MAX_CONST) {
                value = MAX_CONST
            }
            tipPercentMax = value
        } else if(inputType == "step") {
            if(value < 1) {
                value = 1
            }
            if(value > 5) {
                value = 5
            }
            sliderStep = value
        }
        saveData()
        settingsTableView.reloadData()
    }
    
    func loadData() {
        // load persistent values
        tipPercentDefault = userDefaults.integerForKey("tipPercentDefault")
        tipPercentMin = userDefaults.integerForKey("tipPercentMin")
        tipPercentMax = userDefaults.integerForKey("tipPercentMax")
        sliderStep = userDefaults.integerForKey("sliderStep")
    }
    
    func saveData() {
        userDefaults.setInteger(tipPercentDefault, forKey: "tipPercentDefault")
        userDefaults.setInteger(tipPercentMin, forKey: "tipPercentMin")
        userDefaults.setInteger(tipPercentMax, forKey: "tipPercentMax")
        userDefaults.setInteger(sliderStep, forKey: "sliderStep")
        userDefaults.synchronize()
    }
    
}
