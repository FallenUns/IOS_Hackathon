import SwiftUI

struct QuestionInputView: View {
    @Environment(\.dismiss) var dismiss
    @State private var question: String = ""
    @State private var options: [String] = ["", ""]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Question")) {
                    TextField("Enter your question", text: $question)
                }

                Section(header: Text("Options")) {
                    ForEach(0..<options.count, id: \.self) { index in
                        TextField("Option \(index + 1)", text: $options[index])
                    }
                    Button(action: {
                        options.append("")
                    }) {
                        Label("Add Option", systemImage: "plus")
                    }
                }

                Section {
                    Button(action: {
                        // Save question logic here
                        dismiss()
                    }) {
                        Text("Save Question")
                    }
                }
            }
            .navigationTitle("Add Question")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
}

struct QuestionInputView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionInputView()
    }
}
