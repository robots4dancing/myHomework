//
//  schoolEvent.swift
//  myHomework
//
//  Created by Valerie Greer on 4/3/17.
//  Copyright © 2017 Shane Empie. All rights reserved.
//

import Foundation
import Parse

class SchoolEvent: PFObject, PFSubclassing {
    
    @NSManaged var schoolEventName          :String?
    @NSManaged var schoolEventDescription   :String?
    @NSManaged var schoolEventDueDate       :Date?
    @NSManaged var schoolEventReminderDate  :Date?
    @NSManaged var schoolEventStatus        :Bool
    
    convenience init(eventName: String, eventDescription: String, eventDueDate: Date, eventReminderDate: Date, eventStatus: Bool) {
        self.init()
        
        schoolEventName = eventName
        schoolEventDescription = eventDescription
        schoolEventDueDate = eventDueDate
        schoolEventReminderDate = eventReminderDate
        schoolEventStatus = eventStatus
        
    }
    
    static func parseClassName() -> String {
        
        return "SchoolEvent"
        
    }

}
