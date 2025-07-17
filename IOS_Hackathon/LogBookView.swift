import SwiftUI

// MARK: - Gamification Logic (ViewModel)
// We'll put this in the same file for simplicity, but it could be moved.
// @Observable is a modern way to make a class that SwiftUI views can watch for changes.
struct CheckInEntry: Identifiable {
    let id = UUID()
    let date: Date
    let response: String
    let score: Int // Storing the score for potential future use
}

// MARK: - Gamification Logic (ViewModel)
@Observable
class GamificationViewModel {
    var auraPoints = 0
    var dailyStreak = 0
    
    // ADDED: An array to store the history of check-ins.
    var checkInHistory: [CheckInEntry] = []
    
    var plantStage: Int {
        switch dailyStreak {
        case 0...2: return 1
        case 3...6: return 2
        case 7...13: return 3
        case 14...: return 4
        default: return 1
        }
    }
    
    var plantDescription: String {
        switch plantStage {
        case 1: return "Your journey has just begun. Keep nurturing your plant!"
        case 2: return "It's growing! Consistency is helping it thrive."
        case 3: return "Look at it go! You're building a strong, healthy habit."
        case 4: return "It's in full bloom! A beautiful reflection of your dedication."
        default: return "Your plant is waiting for you."
        }
    }
    
    func completeDailyCheckIn(response: String, score: Int) {
        auraPoints += 10
        dailyStreak += 1
        
        // ADDED: Creates a new entry and adds it to the history.
        let newEntry = CheckInEntry(date: Date(), response: response, score: score)
        checkInHistory.insert(newEntry, at: 0) // Add to the top of the list
        
        print("Check-in complete! Aura Points: \(auraPoints), Streak: \(dailyStreak)")
    }
}


// MARK: - Logbook View
struct LogbookView: View {
    @State var viewModel: GamificationViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header
                VStack {
                    Text("Your Sanctuary")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("A space that grows with you.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Plant Display Card
                VStack(spacing: 24) {
                    Image(systemName: plantImageName(for: viewModel.plantStage))
                        .font(.system(size: 120))
                        .foregroundColor(plantColor(for: viewModel.plantStage))
                        .padding()
                        .background(plantColor(for: viewModel.plantStage).opacity(0.1))
                        .clipShape(Circle())
                    
                    Text(viewModel.plantDescription)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(32)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color(.secondarySystemBackground)))
                
                // Stats Grid
                VStack(spacing: 16) {
                    Text("Your Progress")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 16) {
                        StatCard(title: "Aura Points", value: "\(viewModel.auraPoints)", icon: "sparkles", color: .yellow)
                        StatCard(title: "Daily Streak", value: "\(viewModel.dailyStreak)", icon: "flame.fill", color: .orange)
                    }
                }
                
                // ADDED: History Section
                VStack(spacing: 16) {
                    Text("Check-in History")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if viewModel.checkInHistory.isEmpty {
                        Text("You haven't checked in yet. Complete your first check-in to see your history here.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else {
                        ForEach(viewModel.checkInHistory) { entry in
                            HistoryRow(entry: entry)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .navigationTitle("Log Book")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func plantImageName(for stage: Int) -> String {
        switch stage {
        case 1: return "leaf.fill"
        case 2: return "camera.macro"
        case 3: return "tree.fill"
        case 4: return "camera.macro.circle.fill"
        default: return "leaf.fill"
        }
    }
    
    private func plantColor(for stage: Int) -> Color {
        switch stage {
        case 1: return .green
        case 2: return .teal
        case 3: return .green
        case 4: return .pink
        default: return .gray
        }
    }
}
// A reusable view for displaying stats like points and streaks.
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            Spacer()
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
    }
}

struct HistoryRow: View {
    let entry: CheckInEntry
    
    private static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(Self.dateFormatter.string(from: entry.date))
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(entry.response)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

// MARK: - Preview
struct LogbookView_Previews: PreviewProvider {
    static var previews: some View {
        let previewViewModel = GamificationViewModel()
        previewViewModel.auraPoints = 125
        previewViewModel.dailyStreak = 8
        // Add some dummy history for the preview
        previewViewModel.checkInHistory = [
            CheckInEntry(date: Date().addingTimeInterval(-86400), response: "Feeling pretty good today!", score: 3),
            CheckInEntry(date: Date().addingTimeInterval(-172800), response: "A bit tired, but hanging in there.", score: 7)
        ]
        
        return NavigationView {
            LogbookView(viewModel: previewViewModel)
        }
    }
}
