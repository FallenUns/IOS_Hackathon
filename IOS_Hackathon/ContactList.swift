//
//  ContactList.swift
//  IOS_Hackathon
//
//  Created by Yuki Gunawardena on 16/7/2025.
//
import SwiftUI
struct Contact: Identifiable{
    let id = UUID()
    let name: String
    let phone: String
    let role: String
    var isFavorite: Bool = false
}
struct ContactCard: View {
    @Binding var contact: Contact
    
    enum AlertType: Identifiable, Equatable {
        case callNum, message
        var id: Self { self }
    }
    @State private var activeAlert: AlertType? = nil
    
    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.black)
            VStack(alignment: .leading) {
                Text(contact.name).bold().foregroundColor(.black)
                Text(contact.phone).foregroundColor(.black)
                Text(contact.role).foregroundColor(.black)
            }
            Spacer()
            // ⭐ Favorite
            Button {
                contact.isFavorite.toggle()
            } label: {
                Image(systemName: contact.isFavorite ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
            .buttonStyle(PlainButtonStyle())
            // 📞 Call
            Button {
                activeAlert = .callNum
            } label: {
                Image(systemName: "phone.fill").foregroundColor(.green)
            }
            // 💬 Message
            Button {
                activeAlert = .message
            } label: {
                Image(systemName: "message.fill").foregroundColor(.orange)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.2))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.blue, lineWidth: 3))
        .contentShape(Rectangle())
        .alert(item: $activeAlert) { alertType in
            switch alertType {
            case .callNum:
                return Alert(
                    title: Text("Call \(contact.name)?"),
                    message: Text("Are you sure you want to call \(contact.name)?"),
                    primaryButton: .destructive(Text("Yes")),
                    secondaryButton: .cancel()
                )
            case .message:
                return Alert(
                    title: Text("Message \(contact.name)?"),
                    message: Text("Are you sure you want to message \(contact.name)?"),
                    primaryButton: .destructive(Text("Yes")),
                    secondaryButton: .cancel()
                )
            }
        }
    }
}
struct EmergencyContactCard: View {
    @State private var showAlert = false
    var body: some View {
        HStack {
            Image(systemName: "light.beacon.min")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.black)
            Spacer()
            VStack(alignment: .leading) {
                Text("EMERGENCY").bold().foregroundColor(.black)
                Text("000").foregroundColor(.black)
                Text("Emergency Services").foregroundColor(.black)
            }
            Spacer()
            // 📞 Call Button
            Button {
                showAlert = true
            } label: {
                Image(systemName: "phone.fill")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color.red.opacity(0.6))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.red, lineWidth: 3))
        .contentShape(Rectangle())
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Call 000?"),
                message: Text("Are you sure you want to call Emergency Services?"),
                primaryButton: .destructive(Text("Yes")),
                secondaryButton: .cancel()
            )
        }
    }
}
struct WebCard: View {
    var body: some View {
        HStack {
            Image(systemName: "light.beacon.min")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.black)
            VStack(alignment: .leading) {
                Text("BetterHelp").bold().foregroundColor(.black)
                Text("https://www.betterhelp.com").foregroundColor(.black)
                Text("For online therapy and support").foregroundColor(.black)
            }
            
            Spacer();
        }
        
        
        .padding()
        .background(Color.blue.opacity(0.2))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.blue, lineWidth: 3))
        .contentShape(Rectangle())
    }
}
struct ContactList: View {
    @State private var contacts: [Contact] = [
        Contact(name: "John Doe", phone: "0400 999 999", role: "Local Doctor"),
        Contact(name: "Kim Jia", phone: "0400 999 999", role: "Psychiatrist"),
        Contact(name: "Lina Lin", phone: "0400 999 999", role: "Family")
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Who can you Contact?")
                    .font(.title)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.horizontal)
                
                Text("My Support Network").bold()
                    .foregroundColor(.gray)
                    .font(.title3)
                    .padding(.horizontal)
                
                VStack {
                    ForEach(sortedContactIndices(), id: \.self) { index in
                        ContactCard(contact: $contacts[index])
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                    .padding(.vertical, 8)
                }
                .padding(.horizontal)
                
                VStack(spacing: 8) {
                    HStack {
                        Spacer()
                        Button(action: {
                            // Add contact action
                        }) {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .background(Color.green)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .padding(.trailing)
                    }
                    Divider()
                        .frame(height: 0.2)
                        .background(Color.gray)
                        .padding(.horizontal, 30)
                    
                    Text("General support & Councelling").bold()
                        .foregroundColor(.gray)
                        .font(.title3)
                        .padding(.horizontal)
                    Spacer()
                    
                    ContactCard(contact: .constant(Contact(
                        name: "Beyond Blue",
                        phone: "1300 22 4636",
                        role: "For support with depression, anxiety, and related disorders.",
                        isFavorite: true
                    )))
                    .padding(.horizontal)
                    Spacer()
                    
                    
                    ContactCard(contact: .constant(Contact(
                        name: "Suicide Call Back Service",
                        phone: "1300 659 467",
                        role: "24/7 support for suicidal thoughts",
                        isFavorite: true
                    )))
                    .padding(.horizontal)
                    Spacer()
                    
                    
                    WebCard()
                        .padding(.horizontal)
                    Spacer()
                    
                    
                    Divider()
                        .frame(height: 0.2)
                        .background(Color.gray)
                        .padding(.horizontal, 30)
                    
                    Text("Emergency Contact").bold()
                        .foregroundColor(.red)
                        .font(.title3)
                    Spacer()
                    
                    EmergencyContactCard()
                        .padding(.horizontal)
                    
                    
                }
                
            }
        }
        }
        
        // 🔁 This returns the sorted indices based on isFavorite
        private func sortedContactIndices() -> [Int] {
            contacts.indices.sorted {
                contacts[$0].isFavorite && !contacts[$1].isFavorite
            }
        }
}
#Preview {
    ContactList()
}
