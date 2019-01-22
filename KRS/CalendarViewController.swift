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
    @IBOutlet weak var newButton: UIButton!
    
    private var periodType: String = "Month"
    private var selectedDay: DayView!
    private var currentCalendar: Calendar?
    
    var afspraken: [onderhoud2]?
    var onderhouddatums = [Date?]()
    var start = 1
    var needed_date = Date() as Date?
    
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
        print("HIER")
        fetchAfspraken()
        if let currentCalendar = currentCalendar {
            datumLabel.text = CVDate(date: Date(), calendar: currentCalendar).globalDescription
        }
        calendarView.backgroundColor = .white
        
        calendarView.delegate = self
        menuView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool { return true }
    
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
        return [.red]
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: DayView) -> Bool {
        return false
    }
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        let day = dayView.date.convertedDate() //To get the Day from the Calender
        
        if onderhouddatums.contains(day)
        {
            return true
        }
        return false
    }
    
    func fetchAfspraken()
    {
        let fetch = fetchDatas()
        afspraken = fetch.onderhoudData()
        
        for onderhoud in afspraken!
        {
            let date = DateFormatter()
            date.dateFormat = "dd-MM-yyyy"
            let datum = date.date(from: onderhoud.onderhoudsdatum)
            onderhouddatums.append(datum)
        }
        
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
            toggleButton.setTitle("Week", for: .normal)
            previousButton.setTitle("Vorige Week", for: .normal)
            nextButton.setTitle("Volgende Week", for: .normal)
            calendarView.changeMode(.weekView)
        }
        else if periodType == "Week"
        {
            periodType = "Month"
            toggleButton.setTitle("Maand", for: .normal)
            previousButton.setTitle("Vorige Maand", for: .normal)
            nextButton.setTitle("Volgende Maand", for: .normal)
            calendarView.changeMode(.monthView)
        }
    }
    
    @IBAction func nextView()
    {
        calendarView.loadNextView()
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
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
        if start == 1
        {
            start = 0
        }
        else if start == 0
        {
            needed_date = dayView.date.convertedDate()
            performSegue(withIdentifier: "AfsprakenSegue2", sender: self)
        }
        
    }
    
    @IBAction func nieuweAfspraak(_ sender: Any) {
        performSegue(withIdentifier: "nieuweAfspraakSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nieuweAfspraakSegue"
        {
            print("HIER2")
            let NAVC = segue.destination as! NAViewController
            NAVC.date = needed_date
        }
        else if segue.identifier == "AfsprakenSegue2"
        {
            let AO = segue.destination as! AfsprakenOverzichtViewController
            AO.date = needed_date
        }
    }
    
    @IBAction func unwindToCalendarView(segue: UIStoryboardSegue) {
        
    }
}
