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
    }

    public static var hasLoaded: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.hasLoaded.rawValue)
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: Keys.hasLoaded.rawValue)
        }
    }
}

