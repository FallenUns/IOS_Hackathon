import SwiftUI

// MARK: - Login View
struct LoginView: View {
    @Binding var isPresented: Bool
    @Binding var isLoggedIn: Bool
    
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // App Title
            VStack(spacing: 8) {
                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.indigo)
                Text("Mindful")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            
            // Login Form
            VStack(spacing: 20) {
                TextField("Username", text: $username)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .textContentType(.username)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .textContentType(.password)
            }
            .padding(.horizontal, 40)
            
            // Login Button
            Button(action: {
                // In a real app, you'd perform authentication here.
                // For this demo, we'll just set isLoggedIn to true and dismiss the sheet.
                withAnimation {
                    isLoggedIn = true
                    isPresented = false
                }
            }) {
                Text("Login")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.indigo)
                    .cornerRadius(16)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            Spacer()
        }
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide constant bindings for the preview to work
        LoginView(isPresented: .constant(true), isLoggedIn: .constant(false))
    }
}
