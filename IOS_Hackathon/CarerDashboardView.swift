import SwiftUI

struct CarerDashboardView: View {
    @Binding var gamificationViewModel: GamificationViewModel
    @State private var showingQuestionInput = false
    @State private var showingProfile = false // To show the profile sheet


    var body: some View {
        NavigationView {
            ZStack{
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.1), .clear]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        HStack {
                            Text("Carer Dashboard")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Spacer()
                            Button(action: { showingProfile = true }) {
                                Image(systemName: "person.circle")
                                    .font(.largeTitle)
                            }
                        }
                        .padding(.bottom)
                        
                        // Summary Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Patient's Progress")
                                .font(.title2)
                                .fontWeight(.semibold)
                            StatsHeaderView(viewModel: gamificationViewModel)
                        }
                        
                        // Logbook Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Check-in History")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            if gamificationViewModel.checkInHistory.isEmpty {
                                Text("No check-ins have been logged yet.")
                                    .foregroundColor(.secondary)
                            } else {
                                ForEach(gamificationViewModel.checkInHistory) { entry in
                                    HistoryRow(entry: entry)
                                }
                            }
                        }
                        
                        // Actions Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Carer Actions")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Button(action: {
                                // Action to manually input data
                            }) {
                                Text("Manually Input Patient Data")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(12)
                            }
                            
                            Button(action: {
                                showingQuestionInput = true
                            }) {
                                Text("Manage Questions")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green.opacity(0.1))
                                    .foregroundColor(.green)
                                    .cornerRadius(12)
                            }
                        }
                        
                    }
                    .padding()
                }
                .navigationTitle("Dashboard")
                .navigationBarHidden(true)
                .sheet(isPresented: $showingQuestionInput) {
                    QuestionInputView()
                }
            }
        }
    }
}

struct CarerDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = GamificationViewModel()
        viewModel.checkInHistory = [
            CheckInEntry(date: Date(), response: "Feeling good", score: 2),
            CheckInEntry(date: Date().addingTimeInterval(-86400), response: "A bit down", score: 8)
        ]
        return CarerDashboardView(gamificationViewModel: .constant(viewModel))
    }
}
