import SwiftUI

// A reusable view for displaying a question and its options.
struct QuestionDisplayView: View {
    let question: String
    let options: [(text: String, points: Int)]
    let onAnswer: (Int) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text(question)
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            ForEach(options, id: \.text) { option in
                Button(action: { onAnswer(option.points) }) {
                    Text(option.text)
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
        }
    }
}

// A reusable primary button style.
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.vertical, 16)
            .frame(maxWidth: 150)
            .background(Color.blue)
            .cornerRadius(16)
    }
}

// The main view for the check-in process.
struct QuestionsView: View {
    // MODIFIED: The onComplete handler now returns the final message and the score.
    let onComplete: (String, Int) -> Void
    let onCancel: () -> Void

    // State for managing the question flow
    @State private var step = 1
    @State private var score = 0
    @State private var showQuote = false
    @State private var currentQuote = ""

    // Computed property to determine the final result message
    private var resultMessage: String {
        if score <= 5 {
            return "It's great to see you're doing well. Keep up the positive momentum!"
        } else if score <= 10 {
            return "Thanks for sharing. Remember to be kind to yourself. Small steps can make a big difference."
        } else {
            return "It seems like you are going through a difficult time. Please consider contacting your support network or a crisis line."
        }
    }

    var body: some View {
        VStack(spacing: 30) {
            if step <= 7 {
                Text("Questions \(step) of 7")
                    .font(.headline)
                    .foregroundColor(.gray)
            }

            if showQuote {
                VStack(spacing: 30) {
                    Text(currentQuote)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding()
                    Button("Continue") {
                        showQuote = false
                        if step < 7 {
                            step += 1
                        } else {
                            // MODIFIED: Pass the final score back on completion.
                            onComplete(resultMessage, score)
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            } else {
                switch step {
                case 1:
                    QuestionDisplayView(question: "How would you describe your mood today?", options: [
                        ("Good 😊", 0),
                        ("Okay 😐", 1),
                        ("Low 😔", 2)
                    ]) { handleAnswer(points: $0, step: 1) }
                case 2:
                    QuestionDisplayView(question: "How did you sleep last night?", options: [
                        ("Slept well 😴", 0),
                        ("Some trouble 😕", 1),
                        ("Poor sleep 😟", 2)
                    ]) { handleAnswer(points: $0, step: 2) }
                case 3:
                    QuestionDisplayView(question: "Your interest in daily activities?", options: [
                        ("Same as usual 😊", 0),
                        ("Somewhat less 😐", 1),
                        ("Little interest 😔", 2)
                    ]) { handleAnswer(points: $0, step: 3) }
                case 4:
                    QuestionDisplayView(question: "How’s your energy today?", options: [
                        ("Good 💪", 0),
                        ("Low 😕", 1),
                        ("Very low 😣", 2)
                    ]) { handleAnswer(points: $0, step: 4) }
                case 5:
                    QuestionDisplayView(question: "Had any troubling thoughts?", options: [
                        ("No 😊", 0),
                        ("A few 🤔", 1),
                        ("Often 🚨", 2)
                    ]) { handleAnswer(points: $0, step: 5) }
                case 6:
                    QuestionDisplayView(question: "Eating habits?", options: [
                        ("Normal 🍽️", 0),
                        ("Changed a bit 😕", 1),
                        ("Significantly changed 😟", 2)
                    ]) { handleAnswer(points: $0, step: 6) }
                case 7:
                    QuestionDisplayView(question: "Withdrawn from socialising?", options: [
                        ("No, I’m social 🙂", 0),
                        ("Somewhat withdrawn 🤔", 1),
                        ("Very withdrawn 😔", 2)
                    ]) { handleAnswer(points: $0, step: 7) }
                default:
                     VStack {
                        Text("Check-in Complete!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("You've earned points toward your Aura.")
                            .font(.headline)
                        Button("Finish") {
                            // MODIFIED: Pass the final score back on completion.
                            onComplete(resultMessage, score)
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .animation(.easeInOut, value: step)
        .navigationTitle("Daily Check-in")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    onCancel()
                }
            }
        }
    }

    func handleAnswer(points: Int, step: Int) {
        score += points
        currentQuote = quote(for: points, at: step)
        showQuote = true
    }

    func quote(for points: Int, at step: Int) -> String {
        if points == 0 {
            return ["Great to hear! Keep it up! 🎉", "You're doing well – nice job! 🌟"].randomElement() ?? "Well done!"
        } else if points == 1 {
            return ["Thanks for sharing – every day is a new chance.", "You're doing your best and that matters."]
                .randomElement() ?? "Stay steady."
        } else {
            return ["It’s okay to not feel okay. We're here for you.", "Tough days happen. You're not alone."].randomElement() ?? "Keep going."
        }
    }
}

struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            QuestionsView(onComplete: { _, _ in }, onCancel: {})
        }
    }
}
