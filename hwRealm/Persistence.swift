//
//  Persistence.swift
//  hwRealm
//
//  Created by Марина Селезнева on 21.09.2020.
//

import Foundation

class Persistence {
    static let shared = Persistence()
    
    private let kUserNameKey = "Persistence.kUserNameKey"
    private let kUserSurnameKey = "Persistence.kUserSurnameKey"
    
    var userName: String? {
        set { UserDefaults.standard.set(newValue, forKey: kUserNameKey) }
        get { UserDefaults.standard.string(forKey: kUserNameKey) }
    }
    
    var userSurname: String? {
        set { UserDefaults.standard.set(newValue, forKey: kUserSurnameKey) }
        get { UserDefaults.standard.string(forKey: kUserSurnameKey) }
    }
}
