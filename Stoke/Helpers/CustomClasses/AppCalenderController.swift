//
//  AppCalenderController.swift
//  Stoke
//
//  Created by Admin on 09/04/21.
//

import Foundation

struct  EventCalendar : CustomStringConvertible{
    
    var date:Date
    var toShowDate:String
    var timestamp:Double
    init(d:Date) {
        date = d
        if Calendar.current.isDateInToday(d){
            toShowDate = "Today"
        }else{
            let weekDay = d.toString(dateFormat: "EEE")
            let calendarDate = d.toString(dateFormat: "M/dd")
            toShowDate = weekDay + " " + calendarDate
        }
        timestamp = d.timeIntervalSince1970/1000
    }
    var description: String {
        return "Date -\(date) \n toShowDate - \(toShowDate) \n timestamp - \(timestamp)"
    }
    
}


class AppCalendar{
    
    static let shared = AppCalendar()
    private init(){}
    
    var oneWeek:[EventCalendar]{
        var dataSource = [EventCalendar]()
        dataSource.append(EventCalendar(d: Date().startOfDay))
        for i in 1...6{
            let d = Date().returnNextDate(counter: i)
            dataSource.append(EventCalendar(d: d))
        }
        return dataSource
    }
    
}



extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    func returnNextDate(counter:Int) -> Date{
        var components = DateComponents()
        components.day = counter
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
}
