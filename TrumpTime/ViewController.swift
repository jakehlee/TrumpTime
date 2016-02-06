//
//  ViewController.swift
//  TrumpTime
//
//  Created by Jake Lee on 2/5/16.
//  Copyright © 2016 Samuel. All rights reserved.
//

import UIKit

import Social
import AVFoundation
import CoreMotion
import Social

class ViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var theButton: UIButton!
    
    @IBOutlet weak var topLabel: UILabel!
    
    var pickedTime = NSDate()
    var rangeTime = 1.0
    var timer = NSTimer()
    var audio:AVAudioPlayer!
    var accelerationWait = 3.0
    var accTimer = NSTimer()
    var soundName:String = "Audio/trump0"
    var snoozeFlag = false
    var angry:Bool = false
    var hasSnoozed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png"))
        // Do any additional setup after loading the view, typically from a nib.
        datePicker.datePickerMode = UIDatePickerMode.Time
        let currentDate = NSDate()
        datePicker.date = currentDate
        setLabel("TRUMP TIME")
        
        if let audio = self.setupAudioPlayerWithFile(soundName, type:"wav") {
            self.audio = audio
        }
        datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        print("Check1")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    @IBAction func myDateView(sender: UIDatePicker) {
        setTime(datePicker.date)
        print("TIME TRIGGERED" )
    }
    
    @IBAction func myButton(sender: UIButton){
        if(theButton.currentTitle == "Set Time"){
            print("BUTTON TRIGGERED" )
            startTimer()
            fadeOutPicker()
        }else if(theButton.currentTitle == "Shut up"){
            stopAlarm()
        }
        
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
        theButton.setTitle("Shut up" ,forState: UIControlState.Normal)
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
        setLabel("WAKE UP AMERICA")
        playAlarm()
        makeNotif("WAKE UP AMERICA")
        beginSnooze()
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
        let diceRoll = Int(arc4random_uniform(5))
        if diceRoll == 0 {
        soundName = "Audio/trump0"
        }
        if diceRoll == 1 {
        soundName = "Audio/trump1"
        }
        if diceRoll == 2 {
        soundName = "Audio/trump2"
        }
        if diceRoll == 3 {
        soundName = "Audio/trump3"
        }
        if diceRoll == 4 {
        soundName = "Audio/trump4"
        }
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
        if(hasSnoozed){
            hasSnoozed = false
            checkFB()
        }else{
            self.fadeInPicker()
            if(self.audio.playing){
                self.audio.stop()
            }
            self.timer.invalidate()
            self.setLabel("TRUMP TIME")
            self.setTime(self.datePicker.date)
            self.theButton.setTitle("Set Time" ,forState: UIControlState.Normal)
        }
    }
    
    func checkFB(){
        if(SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)) {
            let socialController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            socialController.setInitialText("Hello World!")
            self.presentViewController(socialController, animated: true, completion: nil)
            socialController.completionHandler = { (result:SLComposeViewControllerResult) -> Void in
                switch result {
                case SLComposeViewControllerResult.Cancelled:
                    
                    print("Cancelled") // Never gets called
                    let delay = 3 * Double(NSEC_PER_SEC)
                    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(time, dispatch_get_main_queue()) {
                        // After 2 seconds this line will be executed
                        self.checkFB()
                    }
                    
                    break
                case SLComposeViewControllerResult.Done:
                    print("Done")
                    self.fadeInPicker()
                    if(self.audio.playing){
                        self.audio.stop()
                    }
                    self.timer.invalidate()
                    self.setLabel("TRUMP TIME")
                    self.setTime(self.datePicker.date)
                    self.theButton.setTitle("Set Time" ,forState: UIControlState.Normal)
                    break
                }
            }
            
        }
    }
    
    func beginSnooze() {
        snoozeFlag = true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if(motion == .MotionShake && snoozeFlag == true){
            print("SNOOZE")
            hasSnoozed = true
            snoozeFlag = false
            rangeTime = 3
            audio.stop()
            startTimer()
        }
    }
    
    func fadeOutPicker() {
        // Fade the picker out
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.datePicker.alpha = 0.0
            }, completion: nil)
    }
    
    func fadeInPicker() {
        // Fade the picker out
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.datePicker.alpha = 1.0
            }, completion: nil)
    }
}


