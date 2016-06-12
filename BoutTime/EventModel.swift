//
//  EventModel.swift
//  BoutTime
//
//  Created by XuanWang on 6/12/16.
//  Copyright © 2016 XuanWang. All rights reserved.
//

import Foundation

struct Event {
    let description: String
    let year: Int
    let url: String
}

struct EventList {
    var eventList: [Event] = []
    
    //FIXME: add randomizer
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
        var eventList: [Event] = []
        for (key, value) in dictionary {
            if let itemDict = value as? [String : AnyObject], let description = itemDict["description"] as? String, let year = itemDict["year"] as? Int, let url = itemDict["url"] as? String {
                let event = Event(description: description, year: year, url: url)
                eventList.append(event)
            } else {
                throw SourceListError.InvalidValue
            }
        }
        return eventList
    }
}