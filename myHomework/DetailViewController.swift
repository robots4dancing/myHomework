//
//  DetailViewController.swift
//  myHomework
//
//  Created by Valerie Greer on 4/3/17.
//  Copyright © 2017 Shane Empie. All rights reserved.
//

import UIKit
import EventKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var schoolEventNameTextField          :UITextField?
    @IBOutlet weak var schoolEventReminderDatePicker     :UIDatePicker?
    @IBOutlet weak var schoolEventDueDateDatePicker      :UIDatePicker?
    @IBOutlet weak var schoolEventDescriptionTextView    :UITextView?
    @IBOutlet weak var schoolEventStatusSwitch           :UISwitch?
    
    let eventStore = EKEventStore()
    var currentSchoolEvent  :SchoolEvent?
    
    //MARK: - Display Methods
    
    func display(schoolEvent: SchoolEvent) {
        schoolEventNameTextField?.text = schoolEvent.schoolEventName
        schoolEventReminderDatePicker?.date = schoolEvent.schoolEventReminderDate!
        schoolEventDueDateDatePicker?.date = schoolEvent.schoolEventDueDate!
        schoolEventDescriptionTextView?.text = schoolEvent.schoolEventDescription
        schoolEventStatusSwitch?.isOn = schoolEvent.schoolEventStatus
    }
    
    //MARK: - Reminder Methods
    
    func createReminder() {
        let reminder = EKReminder(eventStore: eventStore)
        reminder.calendar = eventStore.defaultCalendarForNewReminders()
        reminder.title = currentSchoolEvent!.schoolEventName! + " Reminder"
        let alarm = EKAlarm(absoluteDate: currentSchoolEvent!.schoolEventReminderDate!)
        reminder.addAlarm(alarm)
        do {
            try eventStore.save(reminder, commit: true)
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Calendar Methods
    
    func createCaendarEvent() {
        let calEvent = EKEvent(eventStore: eventStore)
        calEvent.calendar = eventStore.defaultCalendarForNewEvents
        calEvent.title = currentSchoolEvent!.schoolEventName!
        calEvent.startDate = currentSchoolEvent!.schoolEventDueDate!
        calEvent.endDate = currentSchoolEvent!.schoolEventDueDate!
        do {
            try eventStore.save(calEvent, span: .thisEvent, commit: true)
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Interactivity Methods
    
    @IBAction func saveButtonPressed(button: UIBarButtonItem) {
        save(schoolEvent: currentSchoolEvent!)
    }
    
    //MARK: - Parse Methods
    
    func save(schoolEvent: SchoolEvent) {
        currentSchoolEvent?.schoolEventName = schoolEventNameTextField?.text
        currentSchoolEvent?.schoolEventReminderDate = schoolEventReminderDatePicker?.date
        currentSchoolEvent?.schoolEventDueDate = schoolEventDueDateDatePicker?.date
        currentSchoolEvent?.schoolEventDescription = schoolEventDescriptionTextView?.text
        currentSchoolEvent?.schoolEventStatus = schoolEventStatusSwitch!.isOn
        createReminder()
        createCaendarEvent()
        schoolEvent.saveInBackground { (success, error) in
            print("Object Saved")
        }
    }
    
    //MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        schoolEventStatusSwitch?.isOn = false
        if let schoolEvent = currentSchoolEvent {
            display(schoolEvent: schoolEvent)
        } else {
            currentSchoolEvent = SchoolEvent()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
