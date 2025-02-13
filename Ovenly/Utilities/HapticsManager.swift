//
//  HapticsManager.swift
//  Ovenly
//
//  Created by Jessica Parsons on 2/10/25.
//

import SwiftUI

final class HapticsManager {
    static let shared = HapticsManager()

    private init() {} // Prevents external initialization

    private let mediumHaptics = UIImpactFeedbackGenerator(style: .medium)
    private let lightHaptics = UIImpactFeedbackGenerator(style: .light)
    private let heavyHaptics = UIImpactFeedbackGenerator(style: .heavy)

    func triggerMediumImpact() {
        //mediumHaptics.prepare()
        mediumHaptics.impactOccurred()
    }

    func triggerLightImpact() {
        //lightHaptics.prepare()
        lightHaptics.impactOccurred()
    }

    func triggerHeavyImpact() {
        //heavyHaptics.prepare()
        heavyHaptics.impactOccurred()
    }
}
