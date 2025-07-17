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



struct ContactList: View {
    @State private var contacts: [Contact] = [
        Contact(name: "John Doe", phone: "0400 999 999", role: "Local Doctor"),
        Contact(name: "Kim Jia", phone: "0400 999 999", role: "Psychiatrist"),
        Contact(name: "Lina Lin", phone: "0400 999 999", role: "Family")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            Text("Who can you Contact?")
                .font(.title2)
                .bold()
                .foregroundColor(.black)
                .padding(.horizontal)
            
            List {
                ForEach(sortedContactIndices(), id: \.self) { index in
                    ContactCard(contact: $contacts[index])
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
            }
            .listStyle(PlainListStyle())

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
                .padding()
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

