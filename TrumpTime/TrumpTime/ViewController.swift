//
//  ViewController.swift
//  TrumpTime
//
//  Created by Jake Lee on 2/5/16.
//  Copyright © 2016 Samuel. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var theButton: UIButton!
    
    @IBOutlet weak var topLabel: UILabel!
    
    var pickedTime = NSDate()
    var rangeTime = 1.0
    var accelerationWait = 3.0
    var timer = NSTimer()
    var accTimer = NSTimer()
    
    
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
    
    func setLabel(aString:String) {
        topLabel.text = aString
    }
    
    //not using this right now
    func stringFromDate(aDate:NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        let theDateFormat = NSDateFormatterStyle.NoStyle
        let theTimeFormat = NSDateFormatterStyle.ShortStyle
        
        dateFormatter.dateStyle = theDateFormat
        dateFormatter.timeStyle = theTimeFormat
        
        return dateFormatter.stringFromDate(pickedTime)
    }
    
    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func setTime(date:NSDate){
        //set the alarm time
        pickedTime = date
        rangeTime = date.timeIntervalSinceNow       //in seconds
        print(rangeTime)
    }
    
    func startTimer() {
        if(rangeTime < 0){
            rangeTime = 86400 + rangeTime
        }
        print(rangeTime)
        //this timer runs checkTimer every 1 second
        timer = NSTimer.scheduledTimerWithTimeInterval(1,
            target: self,
            selector: "checkTimer:",
            userInfo: nil,
            repeats: true)
        
    }
    
    func checkTimer(timer:NSTimer){
        //print("checking!")
        rangeTime = rangeTime - 1
        setLabel(stringFromTimeInterval(rangeTime))
        
        //once we run out of time, end timer
        if(rangeTime < 0){
            timer.invalidate()
            timerEnded()
        }
    }
    
    func timerEnded(){
        setLabel("TIME OVER")
        playAlarm()
        
    }
    
    func playAlarm() {
        //play alarm sound
    }
    
    func stopAlarm() {
        //stop alarm sound
    }
    
    func snoozeAlarm() {
        
        let manager = CMMotionManager()
        let int_time = 0.01
        if manager.accelerometerAvailable{
            manager.accelerometerUpdateInterval = int_time
            manager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()){ data,error in
                self.accTimer = NSTimer.scheduledTimerWithTimeInterval(0.5,
                    target: self,
                    selector: "waitTime:",
                    userInfo: nil,
                    repeats: true)
            }
        
        }

    }

    func waitTime(accTimer:NSTimer, data:CMAccelerometerData){
        if data.acceleration.x > 0.1 && data.acceleration.y > 0.1 {
            accelerationWait = accelerationWait - 1
        }else{
            accelerationWait = 3
        }
        if(accelerationWait < 0){
            accTimer.invalidate()
            timerEnded()
            print("HOLY SHIT THIS WORKS")
        }
    }
}
