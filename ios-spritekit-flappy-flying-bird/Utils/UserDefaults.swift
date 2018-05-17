//
//  UserDefaults.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 17/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import UIKit

extension UserDefaults {
    
    // MARK: - Methods
    
    func integer(for setting: Setting) -> Int {
        return self.integer(forKey: setting.rawValue)
    }
    
    func set(_ int: Int, for setting: Setting) {
        set(int, forKey: setting.rawValue)
    }
    
    func bool(for setting: Setting) -> Bool {
        return bool(forKey: setting.rawValue)
    }
    
    func set(_ bool: Bool, for setting: Setting) {
        set(bool, forKey: setting.rawValue)
    }
}


enum Setting: String {

    // MARK: - Cases

    case bestScore
    case lastScore
    case isSoundOn
    
    // MARK: - Methods
    
    static func regusterDefaults() {
        UserDefaults.standard.register(defaults: [
            Setting.bestScore.rawValue: 0,
            Setting.lastScore.rawValue: 0,
            Setting.isSoundOn.rawValue: true
            ])
    }
}
