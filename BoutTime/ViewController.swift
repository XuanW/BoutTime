//
//  ViewController.swift
//  BoutTime
//
//  Created by XuanWang on 6/10/16.
//  Copyright © 2016 XuanWang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var eventLabel1: UILabel!
    @IBOutlet weak var eventLabel2: UILabel!
    @IBOutlet weak var eventLabel3: UILabel!
    @IBOutlet weak var eventLabel4: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var nextCorrectBtn: UIButton!
    @IBOutlet weak var nextWrongBtn: UIButton!
    @IBOutlet weak var instructionLabel: UILabel!
    
    var eventLabelGroup: [UILabel] = []
    
    let randomizedEvents: [Event]
    var eventsInCurrentRound: [Event] = []
    let roundsPerGame = 6
    let eventsPerRound = 4
    var roundPlayed = 0
    var score = 0
    
    var seconds = 0
    var timer = NSTimer()
    
    

    required init?(coder aDecoder: NSCoder) {
        do {
            let dictionary = try PlistConverter.dictionaryFromFile("HistoricalEvents", ofType: "plist")
            let eventListFromDict = try EventUnarchiver.eventListFromDictionary(dictionary)
            self.randomizedEvents = EventList(eventList: eventListFromDict).randomizeEventList()
        } catch let error {
            fatalError("\(error)")  // Crashes the app in the case of an error
        }
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize eventLabelGroup as an array with all event labels
        eventLabelGroup.append(eventLabel1)
        eventLabelGroup.append(eventLabel2)
        eventLabelGroup.append(eventLabel3)
        eventLabelGroup.append(eventLabel4)
        
        resetViewForNewRound()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getEventsForCurrentRound() -> [Event] {
        if eventsInCurrentRound.isEmpty {
            for i in 0...(eventsPerRound - 1) {
                let event = randomizedEvents[roundPlayed * eventsPerRound + i]
                eventsInCurrentRound.append(event)
            }
        } else {
            for i in 0...(eventsPerRound-1) {
                let event = randomizedEvents[roundPlayed * eventsPerRound + i]
                eventsInCurrentRound[i] = event
            }
        }
        return eventsInCurrentRound
    }
    
    func displayEvents() {
        for i in 0...(eventsPerRound - 1) {
            eventLabelGroup[i].text = eventsInCurrentRound[i].description
        }
    }
    
    // Set up countdown timer
    
    func startTimer() {
        seconds = 60
        timerLabel.hidden = false
        timerLabel.text = "0:\(seconds)"
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.subtractTime), userInfo: nil, repeats: true)
    }
    
    func subtractTime() {
        seconds -= 1
        timerLabel.text = "0:\(seconds)"
        
        if(seconds == 0)  {
            checkAnswer()
        }
    }
    
    // Move labels when player interacts with direction buttons
    
    @IBAction func moveEvent(sender: AnyObject) {
        let labelIndex = sender.tag/2   // labelIndex indicates which eventLabel it is inside the eventLabelGroup array.
        if (sender.tag % 2 == 1) {
            // Push current label down
            swapLabel(eventLabelGroup[labelIndex], UILabel2: eventLabelGroup[labelIndex+1])
            
        } else if (sender.tag % 2 == 0) {
            // Push current label up
            swapLabel(eventLabelGroup[labelIndex], UILabel2: eventLabelGroup[labelIndex-1])
        }
        
    }
    
    // Shake to submit answer
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        checkAnswer()
    }
    
    
    func checkAnswer() {
        timer.invalidate()
        timerLabel.hidden = true
        instructionLabel.text = "Tap events to learn more"
        roundPlayed += 1
        
        let playerAnswer = getPlayerAnswer()
        let correctAnswer = getCorrectAnswer()
        if playerAnswer == correctAnswer {
            nextCorrectBtn.hidden = false
            score += 1
            
        } else {
            nextWrongBtn.hidden = false
        }
    }
    
    // Continue with game
    
    @IBAction func nextRound() {
        if roundPlayed == roundsPerGame {
            // Game is over
        } else {
           resetViewForNewRound()
        }
    }
    
    
    
    
    // Helper Methods
    
    func resetViewForNewRound() {
        nextCorrectBtn.hidden = true
        nextWrongBtn.hidden = true
        instructionLabel.text = "Shake to complete"
        getEventsForCurrentRound()
        displayEvents()
        startTimer()
    }
    
    func swapLabel(UILabel1: UILabel, UILabel2: UILabel) ->(UILabel, UILabel) {
        var temp: String
        if var label1 = UILabel1.text, var label2 = UILabel2.text {
            temp = label1
            label1 = label2
            label2 = temp
            UILabel1.text = label1
            UILabel2.text = label2
        }
        return (UILabel1, UILabel2)
    }
    
    
    func getPlayerAnswer() -> [String] {
        var eventsInPlayerOrder: [String] = []
        for i in 0...(eventsPerRound - 1) {
            if let eventLabel = eventLabelGroup[i].text {
                eventsInPlayerOrder.append(eventLabel)
            }
        }
        return eventsInPlayerOrder
    }
    
    func getCorrectAnswer() -> [String] {
        var eventsInCorrectOrder: [String] = []
        var sortedEvents: [Event] = []
        sortedEvents = eventsInCurrentRound.sort{
            item1, item2 in
            let year1 = item1.year
            let year2 = item2.year
            return year1 < year2
        }
        
        for i in 0...(eventsPerRound - 1) {
            eventsInCorrectOrder.append(sortedEvents[i].description)
        }
        
        return eventsInCorrectOrder
    }
    
    
    
    

}

