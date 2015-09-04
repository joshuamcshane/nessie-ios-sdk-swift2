//
//  Address.swift
//  Nessie-iOS-Wrapper
//
//  Created by Mecklenburg, William on 5/5/15.
//  Copyright (c) 2015 Nessie. All rights reserved.
//

import Foundation

public class Address:NSObject {
    public let streetNumber:String
    public let streetName:String
    public let city:String
    public let state:String
    public let zipCode:String
    
    internal init(data:Dictionary<String,AnyObject>) {
        streetName = data["street_name"] as! String
        streetNumber = data["street_number"]as! String
        city = data["city"] as! String
        state = data["state"] as! String
        zipCode = data["zip"] as! String
    }
    
    public init(streetName:String, streetNumber:String, city:String, state:String, zipCode:String) {
        self.streetName = streetName
        self.streetNumber = streetNumber
        self.city = city
        self.state = state
        self.zipCode = zipCode
    }
    
    internal func toDict() -> Dictionary<String,AnyObject> {
        var dict = ["street_name":streetName,"street_number":streetNumber,"state":state, "city":city, "zip":zipCode]
        return dict
    }
}