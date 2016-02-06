//
//  ViewController.swift
//  TrumpTime
//
//  Created by Jake Lee on 2/5/16.
//  Copyright © 2016 Samuel. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var theButton: UIButton!
    
    @IBOutlet weak var topLabel: UILabel!
    
    var pickedTime = NSDate()
    var rangeTime = 1.0
    var timer = NSTimer();
    var audio:AVAudioPlayer!
    
    
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
    
    @IBAction func myButton(sender: UIButton){
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
    
    func startTimer(){
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
        makeNotif("WAKE UP AMERICA")
    }
    
    func makeNotif(message:String) {
        let localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
        localNotification.alertBody = message
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
        //1
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        //2
        var audioPlayer:AVAudioPlayer?
        
        // 3
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("Player not available")
        }
        
        return audioPlayer
    }
    
    func playAlarm(){
        var soundName:String = "Audio/trump0";
        /*let diceRoll = Int(arc4random_uniform(10))
        if diceRoll == 0 {
            soundName = "trump0"
        }
        if diceRoll == 1 {
            soundName = "trump1"
        }
        if diceRoll == 2 {
            soundName = "trump2"
        }
        if diceRoll == 3 {
            soundName = "trump3"
        }
        if diceRoll == 4 {
            soundName = "trump4"
        }
        if diceRoll == 5 {
            soundName = "trump5"
        }
        if diceRoll == 6 {
            soundName = "trump6"
        }
        if diceRoll == 7 {
            soundName = "trump7"
        }
        if diceRoll == 8 {
            soundName = "trump8"
        }
        if diceRoll == 9 {
            soundName = "trump9"
        }*/
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSessionCategoryPlayback)
        
        if let audio = self.setupAudioPlayerWithFile(soundName, type:"wav") {
            self.audio = audio
        }
        
        audio?.numberOfLoops = -1
        audio?.prepareToPlay()
        audio?.play()
    }
    
    func stopAlarm() {
        //stop alarm sound
    }
    
    func snooze() {
        
    }

}

