//
//  OHDLocationManager.swift
//  OhHappyDay
//
//  Created by Armin Mehinovic on 12/28/16.
//  Copyright © 2016 Armin Mehinovic. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    var latitude: Double!
    var longitude: Double!
}

