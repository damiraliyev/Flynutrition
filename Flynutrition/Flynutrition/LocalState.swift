//
//  LocalState.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 19.12.2022.
//

import Foundation

public class LocalState {
    private enum Keys: String {
        case hasLoaded
        case day
        case month
        case weight
        case mode
    }

    public static var hasLoaded: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.hasLoaded.rawValue)
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: Keys.hasLoaded.rawValue)
        }
    }
    
    public static var day: Int {
        get {
            return UserDefaults.standard.integer(forKey: Keys.day.rawValue)
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: Keys.day.rawValue)
        }
    }
    
    public static var month: Int {
        get {
            return UserDefaults.standard.integer(forKey: Keys.month.rawValue)
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: Keys.month.rawValue)
        }
    }
    
    public static var weight: Double {
        get {
            if UserDefaults.standard.double(forKey: Keys.weight.rawValue) == 0 {
                UserDefaults.standard.set(70, forKey: Keys.weight.rawValue)
                return 70
            } else {
                return UserDefaults.standard.double(forKey: Keys.weight.rawValue)
            }
            
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: Keys.weight.rawValue)
        }
    }
    
    public static var mode: Int {
        get {
            return UserDefaults.standard.integer(forKey: Keys.mode.rawValue)
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: Keys.mode.rawValue)
        }
    }
    
}

