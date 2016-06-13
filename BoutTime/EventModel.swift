//
//  EventModel.swift
//  BoutTime
//
//  Created by XuanWang on 6/12/16.
//  Copyright © 2016 XuanWang. All rights reserved.
//

import Foundation
import GameKit

struct Event {
    let description: String
    let year: Int
    let url: String
}

class EventList {
    var eventList: [Event] = []
    
    init (eventList: [Event]) {
        self.eventList = eventList
    }
    
    func randomizeEventList() -> [Event] {
        let randomSequence = getRandomSequence(eventList.count)
        var randomizedEventList: [Event] = []
        for index in randomSequence {
            randomizedEventList.append(eventList[index])
        }
        return randomizedEventList
    }
}


// Error Types

enum SourceListError: ErrorType {
    case InvalidSource
    case ConversionError
    case InvalidValue
}


// Helper Classes

class PlistConverter {
    class func dictionaryFromFile(resource: String, ofType type: String) throws -> [String : AnyObject] {
        guard let path = NSBundle.mainBundle().pathForResource(resource, ofType: type) else {
            throw SourceListError.InvalidSource
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path), let castDictionary = dictionary as? [String: AnyObject] else {
            throw SourceListError.ConversionError
        }
        
        return castDictionary
    }
}

class EventUnarchiver {
    class func eventListFromDictionary(dictionary: [String: AnyObject]) throws -> [Event] {
        var eventListFromDict: [Event] = []
        for (_, value) in dictionary {
            if let itemDict = value as? [String : AnyObject], let description = itemDict["description"] as? String, let year = itemDict["year"] as? Int, let url = itemDict["url"] as? String {
                let event = Event(description: description, year: year, url: url)
                eventListFromDict.append(event)
            } else {
                throw SourceListError.InvalidValue
            }
        }
        return eventListFromDict
    }
}

//Generate an array of non-repeating random number

func getRandomSequence(count: Int) ->[Int] {
    var nums:[Int] = []
    for i in 1...count {
        nums.append(i-1)
    }
    
    var randomNum:[Int] = []
    while nums.count > 0 {
        let arrayKey = GKRandomSource.sharedRandom().nextIntWithUpperBound(nums.count)
        randomNum.append(nums[arrayKey])
        nums.removeAtIndex(arrayKey)
    }
    
    return randomNum
}