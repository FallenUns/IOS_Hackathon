import SwiftUI

/// A placeholder view for the new "Community" tab.
struct CommunityView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.3.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            Text("Community Hub")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Connect with others, share experiences, and find support.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle("Community")
    }
}

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView()
    }
}
