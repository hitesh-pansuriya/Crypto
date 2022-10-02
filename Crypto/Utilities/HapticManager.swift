//
//  HapticManager.swift
//  Crypto
//
//  Created by PC on 29/09/22.
//

import Foundation
import SwiftUI

class HapticManager {

    static private let generator = UINotificationFeedbackGenerator()

    static func notification(type: UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }

}
