//
//  Playable.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 22/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation
import CoreGraphics

protocol Playable: class {
    var isAffectedByGravity: Bool { get set }
    var size: CGSize { get set }
}
