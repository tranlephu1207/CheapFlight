//
//  Extensions.swift
//  FlightTicketTracking
//
//  Created by lephu on 7/18/16.
//  Copyright © 2016 lephu. All rights reserved.
//

import Foundation

typealias CompletionHandler = (success:Bool) -> Void

extension NSDate {
    func getCurrentYearMonthDay() -> (year:Int, month:Int, day:Int, weekday:Int) {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year, .Weekday], fromDate: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let weekday = components.weekday
        
        print(year)
        print(month)
        print(day)
        print(weekday)
        return (year, month, day, weekday)
    }

    func convertDateFormater(date: String) -> NSDate
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let date = dateFormatter.dateFromString(date)
        return date!
    }
    
    func convertDateFormatter(year:Int, month:Int, day:Int) -> NSDate
    {
        let dateFormatter = NSDateFormatter()
        var dateString = String(year) + "-"
        if month < 10 {
            dateString += "0" + String(month)
        } else {
            dateString += String(month)
        }

        if day < 10 {
            dateString += "-0" + String(day)
        } else {
            dateString += "-" + String(day)
        }
        print(dateString)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let date = dateFormatter.dateFromString(dateString)
        return date!
    }
    
    func getNumOfDaysInMonth(year:Int, month:Int) -> Int {
        let dateComponents = NSDateComponents()
        dateComponents.year = year
        dateComponents.month = month
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateFromComponents(dateComponents)!
        
        let range = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: date)
        let numOfDays = range.length
        return numOfDays
    }
}