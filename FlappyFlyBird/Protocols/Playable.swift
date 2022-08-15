//
//  Playable.swift
//  FlappyFlyBird
//
//  Created by Astemir Eleev on 22/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation
import CoreGraphics

protocol Playable: AnyObject {
    var isAffectedByGravity: Bool { get set }
    var size: CGSize { get set }
}
