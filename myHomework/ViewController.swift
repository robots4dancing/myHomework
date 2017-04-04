//
//  ViewController.swift
//  myHomework
//
//  Created by Valerie Greer on 4/3/17.
//  Copyright © 2017 Shane Empie. All rights reserved.
//

import UIKit
import Parse
import EventKit

class ViewController: UIViewController {
    
    let eventStore = EKEventStore()
    var dateFormat = DateFormatter()
    var schoolEventArray = [SchoolEvent]()
    
    @IBOutlet var schoolEventTableView  :UITableView?
    
    //MARK: - Interactivity Methods
    
    @IBAction func fetchSchoolEventsPressed(button: UIBarButtonItem) {
        fetchSchoolEvents()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueEdit" {
            let indexPath = schoolEventTableView?.indexPathForSelectedRow!
            let currentSchoolEvent = schoolEventArray[(indexPath?.row)!]
            let destVC = segue.destination as! DetailViewController
            destVC.currentSchoolEvent = currentSchoolEvent
            schoolEventTableView?.deselectRow(at: indexPath!, animated: true)
        }
    }
    
    //MARK: - Parse Methods

    func fetchSchoolEvents() {
        let query = PFQuery(className: "SchoolEvent")
        query.limit = 1000
        query.order(byDescending: "schoolEventDueDate")
        query.findObjectsInBackground { (results, error) in
            if let err = error {
                print("Got error \(err.localizedDescription)")
            } else {
                self.schoolEventArray = results as! [SchoolEvent]
                print("Count: \(self.schoolEventArray.count)")
                print("\(self.schoolEventArray[0].schoolEventName)")
                self.schoolEventTableView?.reloadData()
            }
        }
    }
    
    //MARK: - Permission Methods
    
    func requestAccessToEKType(type: EKEntityType) {
        eventStore.requestAccess(to: type) { (accessGranted, error) -> Void in
            if accessGranted {
                print("Granted \(type.rawValue)")
            } else {
                print("Not Granted")
            }
        }
        
    }
    
    func checkEKAuthorizationStatus(type: EKEntityType) {
        let status = EKEventStore.authorizationStatus(for: type)
        switch status {
        case .notDetermined:
            print("Not Determined")
            requestAccessToEKType(type: type)
        case .authorized:
            print("Authorized")
        case .restricted, .denied:
            print("Restricted/Denied")
        }
    }
    
    //MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        checkEKAuthorizationStatus(type: .reminder)
        checkEKAuthorizationStatus(type: .event)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchSchoolEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schoolEventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SchoolEventTableViewCell
        let currentSchoolEvent = schoolEventArray[indexPath.row]
        self.dateFormat.dateFormat = "MM/dd/yy h:mm a"
        self.dateFormat.amSymbol = "AM"
        self.dateFormat.pmSymbol = "PM"
        self.dateFormat.timeZone = TimeZone(abbreviation: "EST")
        let dateDue = currentSchoolEvent.schoolEventDueDate
        let dateDueString = self.dateFormat.string(from: dateDue!)
        let dateReminder = currentSchoolEvent.schoolEventReminderDate
        let dateReminderString = self.dateFormat.string(from: dateReminder!)
        cell.schoolEventNameLabel?.text = currentSchoolEvent.schoolEventName
        cell.schoolEventDueDateLabel?.text = dateDueString
        cell.schoolEventReminderDateLabel?.text = dateReminderString
        if currentSchoolEvent.schoolEventStatus {
            
            cell.schoolEventStatus?.text = "Completed"
        } else {
            
            cell.schoolEventStatus?.text = "Not Completed"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("About to Delete")
            let schoolEventToDelete = schoolEventArray[indexPath.row]
            schoolEventToDelete.deleteInBackground(block: { (sucess, error) in
                print("Deleted")
                self.fetchSchoolEvents()
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
    
}

