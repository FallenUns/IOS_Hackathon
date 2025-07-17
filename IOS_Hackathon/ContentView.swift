import SwiftUI

struct ContentView: View {
    @State private var hasCheckedInToday = false
    @State private var checkInResponse = ""
    @State private var showingCrisisConfirm = false
    @State private var showingQuestions = false
    @State private var showingSettings = false
    @State private var showingProfile = false
    @State private var showingLogin = false // New state to control login sheet
    @State private var isLoggedIn = false // New state to track login status

    var body: some View {
        ContactList()
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Header Section with Profile and Settings
                    HeaderView(
                        onProfileTap: {
                            if isLoggedIn {
                                showingProfile = true
                            } else {
                                showingLogin = true
                            }
                        },
                        onSettingsTap: { showingSettings = true }
                    )

                    // Main Content Area
                    VStack(spacing: 24) {
                        // Primary Check-in Card
                        if !hasCheckedInToday {
                            CheckInCard(onCheckIn: {
                                showingQuestions = true
                            })
                        } else {
                            PostCheckInCard(response: checkInResponse)
                        }

                        // Detailed Mood Calendar
                        MoodCalendarView()

                        // Secondary Feature Buttons
                        SecondaryButtonsView()

                        // Extra spacing before footer
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 32)
                }
            }
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
        }
        .overlay(
            // Crisis Support Footer
            VStack {
                Spacer()
                CrisisSupport(showingConfirm: $showingCrisisConfirm)
            }
        )
        .alert("Crisis Support", isPresented: $showingCrisisConfirm) {
            Button("Call Now", role: .destructive) {
                // In a real app, this would dial emergency services
                print("Calling emergency services")
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will connect you with emergency services. Do you want to proceed?")
        }
        .sheet(isPresented: $showingQuestions) {
            QuestionsView(
                onComplete: { response in
                    hasCheckedInToday = true
                    checkInResponse = response
                    showingQuestions = false
                }
            )
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingProfile) {
            ProfileView()
        }
        .sheet(isPresented: $showingLogin) { // Sheet for the LoginView
            LoginView(isPresented: $showingLogin, isLoggedIn: $isLoggedIn)
        }
    }
}

// ... (The rest of ContentView.swift remains the same)
struct HeaderView: View {
    let onProfileTap: () -> Void
    let onSettingsTap: () -> Void

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        default: return "Good evening"
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
                HStack(spacing: 12) {
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

struct CheckInCard: View {
    let onCheckIn: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Text("How are you feeling today?")
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

struct PostCheckInCard: View {
    let response: String

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.green)
                Text("Thank you for checking in today")
                    .font(.title3)
                    .fontWeight(.medium)
            }
            VStack(alignment: .leading, spacing: 12) {
                Text("You mentioned feeling a bit low. Here's a short breathing exercise from the Resource Hub that might help.")
                    .font(.body)
                    .foregroundColor(.secondary)
                Button(action: { /* Navigate */ }) {
                    HStack {
                        Image(systemName: "leaf.fill")
                        Text("Try Breathing Exercise").fontWeight(.medium)
                    }
                    .font(.subheadline)
                    .foregroundColor(.green)
                }
            }
            .padding(.top, 8)
        }
        .padding(32)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.green.opacity(0.05)))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.green.opacity(0.1), lineWidth: 1))
    }
}

// NEW: This view displays the weekly calendar grid directly.
struct MoodCalendarView: View {
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
        VStack(spacing: 16) {
            // Header for the calendar component
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Mood Calendar")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
                Spacer()
            }

            // Weekly Calendar Grid
            VStack(spacing: 8) {
                // Days of week headers
                HStack {
                    ForEach(dayAbbreviations, id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }

                // Date numbers and mood indicators
                HStack {
                    ForEach(Array(weekDates.enumerated()), id: \.offset) { index, date in
                        VStack(spacing: 8) {
                            Text("\(calendar.component(.day, from: date))")
                                .font(.caption)
                                .fontWeight(calendar.isDateInToday(date) ? .bold : .regular)
                                .foregroundColor(calendar.isDateInToday(date) ? .primary : .secondary)

                            // Example mood data for past days
                            if index < 4 {
                                Circle()
                                    .fill(moodBackgroundColor(for: index))
                                    .frame(width: 32, height: 32)
                                    .overlay(Text(moodEmoji(for: index)).font(.system(size: 14)))
                            } else {
                                // Empty space for future days
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

    private func moodBackgroundColor(for index: Int) -> Color {
        switch index {
        case 0: return .yellow.opacity(0.3)
        case 1: return .blue.opacity(0.3)
        case 2: return .gray.opacity(0.3)
        case 3: return .yellow.opacity(0.3)
        case 4: return .orange.opacity(0.3)
        default: return .clear
        }
    }

    private func moodEmoji(for index: Int) -> String {
        ["😊", "😢", "😐", "😊", "", "", ""][index]
    }
}

struct SecondaryButtonsView: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                SecondaryButton(icon: "calendar", title: "My Support Plan", subtitle: "Medications & appointments", color: .purple, action: {})
                SecondaryButton(icon: "book", title: "Log Book", subtitle: "Log your activity", color: .orange, action: {})
            }
            HStack(spacing: 16) {
                SecondaryButton(icon: "location", title: "Near Me", subtitle: "Clinics and Pharmacy", color: .cyan, action: {})
                SecondaryButton(icon: "phone", title: "Contacts", subtitle: "Person and Supervisor", color: .green, action: {})
            }
                
            HStack(spacing: 16) {
                SecondaryButton(icon:"person.3", title: "Community", subtitle: "Connect to others", color:
                    .black, action: {})
            }
        }
    }
}

struct SecondaryButton: View {
    let icon: String, title: String, subtitle: String, color: Color, action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon).font(.title2).foregroundColor(color)
                VStack(spacing: 4) {
                    Text(title).font(.headline).fontWeight(.medium)
                    Text(subtitle).font(.caption).foregroundColor(.secondary)
                }
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, minHeight: 120)
            .background(RoundedRectangle(cornerRadius: 16).fill(color.opacity(0.05)))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(color.opacity(0.1), lineWidth: 1))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CrisisSupport: View {
    @Binding var showingConfirm: Bool

    var body: some View {
        VStack(spacing: 0) {
            Rectangle().fill(Color.gray.opacity(0.2)).frame(height: 1)
            Button(action: { showingConfirm = true }) {
                HStack {
                    Image(systemName: "phone.fill").font(.title3)
                    Text("Need help now?").font(.headline).fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.red.opacity(0.1))
                .foregroundColor(.red)
            }
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - Sheet Views
struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            // Content for settings
            Text("Settings View").navigationTitle("Settings").navigationBarItems(trailing: Button("Done") { presentationMode.wrappedValue.dismiss() })
        }
    }
}

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            // Content for profile
            Text("Profile View").navigationTitle("Profile").navigationBarItems(trailing: Button("Done") { presentationMode.wrappedValue.dismiss() })
        }
    }
}

struct QuestionsView: View {
    let onComplete: (String) -> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                Text("This is where your questions would go.").padding()
                Spacer()
                Button("Complete Check-in") { onComplete("feeling better") }
                    .font(.headline).foregroundColor(.white).frame(maxWidth: .infinity, minHeight: 50).background(Color.blue).cornerRadius(10).padding()
            }
            .navigationTitle("Check-in")
            .navigationBarItems(leading: Button("Cancel") { presentationMode.wrappedValue.dismiss() })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
