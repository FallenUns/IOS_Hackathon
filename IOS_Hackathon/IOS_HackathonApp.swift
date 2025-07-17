//
//  IOS_HackathonApp.swift
//  IOS_Hackathon
//
//  Created by Patrick Adrianus on 16/7/2025.
//

import SwiftUI

@main
struct IOS_HackathonApp: App {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    
    var body: some Scene {
        WindowGroup {
            // If onboarding is complete, show the new MainTabView.
            // Otherwise, show the OnboardingView.
            if hasCompletedOnboarding {
                // MODIFIED: The root view of the app is now MainTabView.
                MainTabView()
            } else {
                OnboardingView()
            }
        }
    }
}
