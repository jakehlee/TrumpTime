//
//  ViewController.swift
//  TrumpTime
//
//  Created by Jake Lee on 2/5/16.
//  Copyright © 2016 Samuel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var theButton: UIButton!
    
    @IBOutlet weak var topLabel: UILabel!
    
    var pickedTime = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        datePicker.datePickerMode = UIDatePickerMode.Time
        let currentDate = NSDate()
        datePicker.date = currentDate
        print("Check1")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func myDateView(sender: UIDatePicker) {
        setTime(datePicker.date)
        print("TIME TRIGGERED" )
    }
    
    @IBAction func myButton(sender: UIButton) {
        print("BUTTON TRIGGERED" )
        startTimer()
    }
    
    func dateToString(aDate:NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        let theDateFormat = NSDateFormatterStyle.NoStyle
        let theTimeFormat = NSDateFormatterStyle.ShortStyle
        
        dateFormatter.dateStyle = theDateFormat
        dateFormatter.timeStyle = theTimeFormat
        
        return dateFormatter.stringFromDate(pickedTime)
    }
    
    func setTime(date:NSDate){
        //set the alarm time
        pickedTime = date
    }
    
    func startTimer() {
        //start the timer
    }
    
    func playAlarm() {
        //play alarm sound
    }
    
    func stopAlarm() {
        //stop alarm sound
    }
    
    func snooze() {
        
    }

}

