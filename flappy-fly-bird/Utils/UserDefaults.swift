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
    
    func playableCharacter(for setting: Setting) -> PlayableCharacter? {
        guard let rawPlayableCharacter = self.string(forKey: setting.rawValue) else {
            return nil
        }
        return PlayableCharacter(rawValue: rawPlayableCharacter)
    }
    
    func set(_ playableCharacter: PlayableCharacter, for setting: Setting) {
        set(playableCharacter.rawValue, forKey: setting.rawValue)
    }
    
    func set(difficultyLevel level: Difficulty) {
        set(level.rawValue, forKey: Setting.difficulty.rawValue)
    }
    
    func getDifficultyLevel() -> Difficulty {
        let value = double(forKey: Setting.difficulty.rawValue)
        return Difficulty(rawValue: value) ?? .medium
    }
}


enum Setting: String {

    // MARK: - Cases

    case bestScore
    case lastScore
    case isSoundOn
    case character
    case difficulty
    
    // MARK: - Methods
    
    static func regusterDefaults() {
        UserDefaults.standard.register(defaults: [
            Setting.bestScore.rawValue: 0,
            Setting.lastScore.rawValue: 0,
            Setting.isSoundOn.rawValue: true,
            Setting.character.rawValue: PlayableCharacter.bird.rawValue,
            Setting.difficulty.rawValue: Difficulty.medium.rawValue
            ])
    }
}

enum Difficulty: Double {
    case easy = 4.0
    case medium = 3.5
    case hard = 3.0
}

enum PlayableCharacter: String {
    case bird = "bird"
    case gamecat = "gameCat"
    case jazzCat = "jazzCat"
    case lifelopeCat = "lifelopeCat"
    case coinCat = "coinCat"
    case hipCat = "hipCat"
}

extension PlayableCharacter {
    func getAssetName() -> String {
        switch self {
        case .bird:
            return "Bird Right"
        case .coinCat:
            return "animated-nyancoin"
        case .gamecat:
            return "animated-gamecat-nyan"
        case .hipCat:
            return "animated-nyan-hip"
        case .jazzCat:
            return "animated-jazz-nyan"
        case .lifelopeCat:
            return "animated-lifealope-nyan"
        }
    }
}
