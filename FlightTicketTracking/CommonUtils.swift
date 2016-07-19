//
//  CommonUtils.swift
//  FlightTicketTracking
//
//  Created by lephu on 7/18/16.
//  Copyright © 2016 lephu. All rights reserved.
//

import Foundation

struct Day {
    var day:Int
    var weekDay:Int
    init(aDay:Int, aWeekDay:Int) {
        self.day = aDay
        self.weekDay = aWeekDay
    }
}