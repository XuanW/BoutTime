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
    var eventLabelGroup: [UILabel] = []
    
    let randomizedEvents: [Event]
    var eventsInCurentRound: [Event] = []
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
        
        getEventsForCurrentRound()
        displayEvents()
        startTimer()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getEventsForCurrentRound() -> [Event] {
        if eventsInCurentRound.isEmpty {
            for i in 0...(eventsPerRound - 1) {
                let event = randomizedEvents[roundPlayed * eventsPerRound + i]
                eventsInCurentRound.append(event)
            }
        } else {
            for i in 0...(eventsPerRound-1) {
                let event = randomizedEvents[roundPlayed * eventsPerRound + i]
                eventsInCurentRound[i] = event
            }
        }
        return eventsInCurentRound
    }
    
    func displayEvents() {
        for i in 0...(eventsPerRound - 1) {
            eventLabelGroup[i].text = eventsInCurentRound[i].description
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
            // FIXME: add codes to judge result
        }
    }
    
    
    @IBAction func moveEvent(sender: AnyObject) {
        print(sender.tag)
    }
    
    
    
    
    
    

}

