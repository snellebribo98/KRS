//
//  CalendarViewController.swift
//  KRS
//
//  Created by Wessel Mel on 21/01/2019.
//  Copyright © 2019 Wessel Mel. All rights reserved.
//

import UIKit
import CVCalendar

class CalendarViewController: UIViewController, CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var datumLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var vandaagButton: UIButton!
    
    private var periodType: String = "Month"
    private var selectedDay: DayView!
    private var currentCalendar: Calendar?
    
    override func awakeFromNib() {
        currentCalendar = Calendar(identifier: .gregorian)
        currentCalendar?.locale = Locale(identifier: "nl_NL")
        if let timeZone = TimeZone(identifier: "CET")
        {
            currentCalendar?.timeZone = timeZone
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentCalendar = currentCalendar {
            datumLabel.text = CVDate(date: Date(), calendar: currentCalendar).globalDescription
        }
        
        calendarView.delegate = self
        menuView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    func firstWeekday() -> Weekday {
        return .monday
    }
    
    @IBAction func todayMonthView()
    {
        calendarView.toggleCurrentDayView()
    }
    
    @IBAction func toggleWeekMonthView()
    {
        if periodType == "Month"
        {
            periodType = "Week"
            calendarView.changeMode(.weekView)
        }
        else if periodType == "Week"
        {
            periodType = "Month"
            calendarView.changeMode(.monthView)
        }
    }
    
    @IBAction func nextView()
    {
        calendarView.loadNextView()
        presentedDateUpdated(<#T##date: CVDate##CVDate#>)
    }

    @IBAction func previousView()
    {
        calendarView.loadPreviousView()
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        if datumLabel.text != date.globalDescription {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = datumLabel.textColor
            updatedMonthLabel.font = datumLabel.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.datumLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            
            UIView.animate(withDuration: 0.35, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.datumLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.datumLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                self.datumLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity
                
            }) { _ in
                self.datumLabel.frame = updatedMonthLabel.frame
                self.datumLabel.text = updatedMonthLabel.text
                self.datumLabel.transform = CGAffineTransform.identity
                self.datumLabel.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.datumLabel)
        }
    }
}
