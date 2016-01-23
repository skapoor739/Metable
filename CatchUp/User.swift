//
//  User.swift
//  CatchUp
//
//  Created by Shivam Kapur on 15/01/16.
//  Copyright © 2016 Shivam Kapur. All rights reserved.
//

import Foundation

class User {
    private var _email:String!
    private var _username:String!
    private var _firstName:String!
    private var _lastName:String!
    private var _profileImage:NSData?
    
    var email:String {
        get {
            return _email
        }
    }
    
    var username:String {
        get {
           return _username
        }
    }
    
    var firstName:String {
        get {
            return _firstName
        }
    }
    
    var lastName:String {
        get {
            return _lastName
        }
    }
    
    var profileImage:NSData {
        get {
            return _profileImage!
        }
        
    }
    
    init(email:String,username:String) {
        self._email = email
        self._username = username
    }
    

    
    
}