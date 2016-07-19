//
//  File.swift
//  FlightTicketTracking
//
//  Created by lephu on 7/18/16.
//  Copyright © 2016 lephu. All rights reserved.
//

import Foundation

//Mark: Titles
let January = "january"
let February = "february"
let March = "march"
let April = "april"
let May = "may"
let June = "june"
let July = "july"
let August = "august"
let September = "september"
let October = "october"
let November = "november"
let December = "december"

class LocalizableString: NSObject {
    func getString(local:String)->String
    {
        let preferredLanguage = NSLocale.preferredLanguages()[0] as String
        //        print(preferredLanguage)
        let path = NSBundle.mainBundle().pathForResource(preferredLanguage, ofType: "lproj")
        if path == nil || path?.isEmpty == true {
            return NSLocalizedString(local, comment: "")
        }
        else
        {
            let bundle = NSBundle(path: path!)
            let string = bundle?.localizedStringForKey(local, value: nil, table: nil)
            return string!
        }
        
    }
}