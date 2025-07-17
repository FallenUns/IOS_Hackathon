import SwiftUI

struct MainTabView: View {
    // MARK: - State
    @AppStorage("isCarerModeEnabled") private var isCarerModeEnabled: Bool = false
    @State private var isLoggedIn = true
    @State private var userName = "Hannah"
    @State private var gamificationViewModel = GamificationViewModel()
    
    // MARK: - Body
    
    var body: some View {
        if isCarerModeEnabled {
            CarerDashboardView(gamificationViewModel: $gamificationViewModel)
        } else {
            TabView {
                // Tab 1: Home Screen
                ContentView(
                    isLoggedIn: $isLoggedIn,
                    userName: $userName,
                    gamificationViewModel: $gamificationViewModel
                )
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                
                // Tab 2: Near Me Screen
                NavigationStack {
                    NearMeView()
                }
                .tabItem {
                    Label("Near Me", systemImage: "location.fill")
                }
                
                // Tab 3: Logbook Screen
                NavigationStack {
                    LogbookView(viewModel: gamificationViewModel)
                }
                .tabItem {
                    Label("Logbook", systemImage: "book.fill")
                }
                
                // Tab 4: Community Screen
                NavigationStack {
                    CommunityView()
                }
                .tabItem {
                    Label("Community", systemImage: "person.3.fill")
                }
                
                // ADDED: Tab 5: Contact List Screen
                NavigationStack {
                    ContactList()
                }
                .tabItem {
                    Label("Contact", systemImage: "person.crop.circle.fill")
                }
            }
        }
    }
}

// MARK: - Preview
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
