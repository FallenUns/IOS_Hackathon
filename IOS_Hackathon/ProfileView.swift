import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isCarerModeEnabled") private var isCarerModeEnabled: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Mode")) {
                    Toggle("Enable Carer/Supervisor Mode", isOn: $isCarerModeEnabled)
                }
            }
            .navigationTitle("Profile")
            .navigationBarItems(trailing: Button("Done") { dismiss() })
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
