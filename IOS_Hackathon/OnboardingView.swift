import SwiftUI

// A single onboarding page view.
struct OnboardingPageView: View {
    let imageName: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: imageName)
                .font(.system(size: 100))
                .foregroundColor(.blue)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(Circle())
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
            
            Text(subtitle)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 40)
    }
}

// The main onboarding view with multiple pages.
struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    
    @State private var wantsReminders = true
    @State private var reminderTime = Date()
    @State private var tabSelection = 0
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.blue.opacity(0.1)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                // TabView for the paged content
                TabView(selection: $tabSelection) {
                    // Page 1: Welcome
                    OnboardingPageView(
                        imageName: "figure.mind.and.body",
                        title: "Welcome to Mindful",
                        subtitle: "Your personal space for reflection, growth, and building positive habits."
                    )
                    .tag(0)
                    
                    // Page 2: Explain Sanctuary
                    OnboardingPageView(
                        imageName: "leaf.fill",
                        title: "Grow Your Sanctuary",
                        subtitle: "Each time you check in, you'll nurture a digital plant that grows along with you."
                    )
                    .tag(1)
                    
                    // Page 3: Notifications
                    VStack(spacing: 30) {
                        OnboardingPageView(
                            imageName: "bell.fill",
                            title: "Stay Consistent",
                            subtitle: "A gentle daily reminder can help you build a lasting mindfulness habit."
                        )
                        
                        VStack(spacing: 15) {
                            Toggle("Enable Daily Reminders", isOn: $wantsReminders.animation())
                                .tint(.blue)
                                .fontWeight(.semibold)
                            
                            if wantsReminders {
                                DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(.compact)
                            }
                        }
                        .padding()
                        .background(.regularMaterial)
                        .cornerRadius(20)
                        .padding(.horizontal, 40)
                    }
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                // Continue Button
                Button(action: handleNext) {
                    Text(tabSelection == 2 ? "Get Started" : "Continue")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.blue)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
        }
    }
    
    func handleNext() {
        withAnimation {
            if tabSelection < 2 {
                tabSelection += 1
            } else {
                completeOnboarding()
            }
        }
    }
    
    func completeOnboarding() {
        if wantsReminders {
            NotificationManager.shared.requestAuthorization { granted in
                if granted {
                    NotificationManager.shared.scheduleDailyReminder(at: reminderTime)
                }
                hasCompletedOnboarding = true
            }
        } else {
            hasCompletedOnboarding = true
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
