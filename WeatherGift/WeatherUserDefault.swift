//
//  WeatherUserDefault.swift
//  WeatherGift
//
//  Created by William Farley on 4/17/17.
//  Copyright © 2017 William Farley. All rights reserved.
//

import Foundation

class WeatherUserDefault: NSObject, NSCoding {
    var name = ""
    var coordinates = ""
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        coordinates = aDecoder.decodeObject(forKey: "coordinates") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(coordinates, forKey: "coordinates")
    }
    
}
