import SwiftUI

struct ContentView: View {
    // MARK: - State Properties
    
    @State private var hasCheckedInToday = false
    @State private var checkInResponse = ""
    @State private var showingCrisisConfirm = false
    @State private var showingQuestions = false
    @State private var showingSettings = false
    @State private var showingProfile = false
    
    // ADDED: State to track if the check-in result is concerning.
    @State private var isResultConcerning = false
    @State private var dailyMood: Int? = nil // ADDED: To capture mood from QuestionsView
    @State private var moodHistory: [Date: Int] = [:] // ADDED: To store mood history

    @Binding var isLoggedIn: Bool
    @Binding var userName: String
    @Binding var gamificationViewModel: GamificationViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.1), .clear]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // The main scrollable content of the home screen.
                ScrollView {
                    VStack(spacing: 0) {
                        HeaderView(
                            userName: userName,
                            isLoggedIn: isLoggedIn,
                            onProfileTap: { showingProfile = true },
                            onSettingsTap: { showingSettings = true },
                            onCrisisTap: { showingCrisisConfirm = true }
                        )
                        
                        VStack(spacing: 24) {
                            StatsHeaderView(viewModel: gamificationViewModel)
                            
                            if !hasCheckedInToday {
                                CheckInCard(onCheckIn: {
                                    showingQuestions = true
                                })
                            } else {
                                // MODIFIED: Pass the 'isConcerning' state to the card.
                                PostCheckInCard(response: checkInResponse, isConcerning: isResultConcerning)
                            }
                            
                            MoodCalendarView(moodHistory: $moodHistory) // MODIFIED: Pass mood history
                            
                            Spacer(minLength: 40)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 32)
                    }
                }
                .navigationBarHidden(true)
                .navigationDestination(isPresented: $showingQuestions) {
                    QuestionsView(
                        moodScore: $dailyMood, // MODIFIED: Pass binding for mood
                        // MODIFIED: The handler now accepts the score.
                        onComplete: { response, score in
                            hasCheckedInToday = true
                            checkInResponse = response
                            gamificationViewModel.completeDailyCheckIn(response: response, score: score)
                            
                            if let mood = dailyMood {
                                moodHistory[Calendar.current.startOfDay(for: Date())] = mood
                            }


                            // ADDED: Logic to determine if the result is concerning.
                            if score > 10 { // Threshold for "concerning" answers
                                self.isResultConcerning = true
                            } else {
                                self.isResultConcerning = false
                            }
                            
                            showingQuestions = false
                        },
                        onCancel: {
                            showingQuestions = false
                        }
                    )
                }
            }
            .alert("Crisis Support", isPresented: $showingCrisisConfirm) {
                Button("Call 000", role: .destructive) { callEmergencyServices() }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will connect you with emergency services. Do you want to proceed?")
            }
            .sheet(isPresented: $showingSettings) { SettingsView() }
            .sheet(isPresented: $showingProfile) { ProfileView() }
        }
    }
    
    private func callEmergencyServices() {
        guard let url = URL(string: "tel://000") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Child Views

// MODIFIED: The HeaderView now includes a crisis button.
struct HeaderView: View {
    let userName: String
    let isLoggedIn: Bool
    let onProfileTap: () -> Void
    let onSettingsTap: () -> Void
    let onCrisisTap: () -> Void
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        var baseGreeting: String
        switch hour {
        case 5..<12: baseGreeting = "Good morning"
        case 12..<17: baseGreeting = "Good afternoon"
        default: baseGreeting = "Good evening"
        }
        
        if isLoggedIn && !userName.trimmingCharacters(in: .whitespaces).isEmpty {
            return "\(baseGreeting), \(userName)"
        } else {
            return baseGreeting
        }
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM yyyy"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(greeting)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(dateString)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                HStack(spacing: 16) {
                    // ADDED: Crisis button
                    Button(action: onCrisisTap) {
                        Image(systemName: "phone.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                    
                    Button(action: onProfileTap) {
                        Image(systemName: "person.circle").font(.title2)
                    }
                    Button(action: onSettingsTap) {
                        Image(systemName: "gearshape").font(.title2)
                    }
                }
                .foregroundColor(.primary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}

struct StatsHeaderView: View {
    let viewModel: GamificationViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.headline)
                    .foregroundColor(.yellow)
                Text("\(viewModel.auraPoints) Aura")
                    .font(.headline)
                    .fontWeight(.medium)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background(Color.yellow.opacity(0.1))
            .cornerRadius(12)
            
            HStack(spacing: 8) {
                Image(systemName: "flame.fill")
                    .font(.headline)
                    .foregroundColor(.orange)
                Text("\(viewModel.dailyStreak) Day Streak")
                    .font(.headline)
                    .fontWeight(.medium)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)
            
            Spacer()
        }
    }
}

struct CheckInCard: View {
    let onCheckIn: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text("How are you feeling today? 😊")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            
            Button(action: onCheckIn) {
                Text("Start Check-in")
                    .font(.headline)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.blue.opacity(0.3), lineWidth: 1))
            }
        }
        .padding(32)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.blue.opacity(0.05)))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.blue.opacity(0.1), lineWidth: 1))
    }
}

// MODIFIED: This view is now more dynamic.
struct PostCheckInCard: View {
    let response: String
    let isConcerning: Bool
    @State private var showingContactList = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: isConcerning ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(isConcerning ? .orange : .green)
                Text(isConcerning ? "Thank You for Sharing" : "Thank You for Checking In")
                    .font(.title3)
                    .fontWeight(.medium)
            }
            VStack(alignment: .leading, spacing: 12) {
                Text(response)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                // ADDED: Conditional button to show contacts.
                if isConcerning {
                    Button(action: { showingContactList = true }) {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text("Contact Your Support Team").fontWeight(.medium)
                        }
                        .font(.subheadline)
                        .foregroundColor(.red)
                    }
                } else {
                    Button(action: { /* Navigate */ }) {
                        HStack {
                            Image(systemName: "leaf.fill")
                            Text("Try Breathing Exercise").fontWeight(.medium)
                        }
                        .font(.subheadline)
                        .foregroundColor(.green)
                    }
                }
            }
            .padding(.top, 8)
        }
        .padding(32)
        .background(RoundedRectangle(cornerRadius: 20).fill(isConcerning ? Color.orange.opacity(0.05) : Color.green.opacity(0.05)))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(isConcerning ? Color.orange.opacity(0.1) : Color.green.opacity(0.1), lineWidth: 1))
        // ADDED: Sheet to present the ContactList view.
        .sheet(isPresented: $showingContactList) {
            ContactList()
        }
    }
}
struct MoodCalendarView: View {
    @Binding var moodHistory: [Date: Int] // MODIFIED: Use mood history
    private let calendar = Calendar.current
    private let today = Date()
    
    private var weekDates: [Date] {
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        return (0..<7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek)
        }
    }
    
    private let dayAbbreviations = ["M", "T", "W", "T", "F", "S", "S"]
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Mood Calendar")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
                Spacer()
            }
            
            VStack(spacing: 8) {
                HStack {
                    ForEach(dayAbbreviations, id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                HStack {
                    ForEach(Array(weekDates.enumerated()), id: \.offset) { index, date in
                        VStack(spacing: 8) {
                            Text("\(calendar.component(.day, from: date))")
                                .font(.caption)
                                .fontWeight(calendar.isDateInToday(date) ? .bold : .regular)
                                .foregroundColor(calendar.isDateInToday(date) ? .primary : .secondary)
                            
                            if let moodScore = moodHistory[calendar.startOfDay(for: date)] {
                                Circle()
                                    .fill(moodBackgroundColor(for: moodScore))
                                    .frame(width: 32, height: 32)
                                    .overlay(Text(moodEmoji(for: moodScore)).font(.system(size: 14)))
                            } else {
                                Circle().fill(Color.clear).frame(width: 32, height: 32)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(calendar.isDateInToday(date) ? Color.indigo : Color.clear, lineWidth: 2)
                        )
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.indigo.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.indigo.opacity(0.1), lineWidth: 1)
        )
    }
    
    private func moodBackgroundColor(for score: Int) -> Color {
        switch score {
        case 0: return .yellow.opacity(0.3) // Good
        case 1: return .blue.opacity(0.3)   // Okay
        case 2: return .gray.opacity(0.3)    // Low
        default: return .clear
        }
    }
    
    private func moodEmoji(for score: Int) -> String {
        switch score {
        case 0: return "😊"
        case 1: return "😐"
        case 2: return "😔"
        default: return ""
        }
    }
}

// REMOVED: The old CrisisSupport view is no longer needed here,
// as the button has been moved into the HeaderView.

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var notificationsEnabled = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notifications")) {
                    Toggle("Enable Daily Reminders", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { _, newValue in
                            if newValue {
                                NotificationManager.shared.scheduleDailyReminder(at: Date())
                            } else {
                                NotificationManager.shared.cancelNotifications()
                            }
                        }
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Done") { dismiss() })
            .onAppear {
                UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                    DispatchQueue.main.async {
                        notificationsEnabled = !requests.isEmpty
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // The preview is updated to reflect the removal of the 'showingLogin' binding.
        ContentView(
            isLoggedIn: .constant(true),
            userName: .constant("John"),
            gamificationViewModel: .constant(GamificationViewModel())
        )
    }
}
