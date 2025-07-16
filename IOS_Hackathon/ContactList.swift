//
//  ContactList.swift
//  IOS_Hackathon
//
//  Created by Yuki Gunawardena on 16/7/2025.
//

import SwiftUI

struct ContactList: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 50){
            Text("Who can you Contact?").font(.title2).bold().foregroundColor(.black).padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 20){
                
                Button{
                } label: {
                    HStack(){
                        Image(systemName: "person.crop.circle").resizable().frame(width: 40, height: 40)
                        VStack{
                            Text("John Doe").foregroundColor(.black).bold()
                            Text("0400 999 999").foregroundColor(.black)
                            Text("Local Doctor").foregroundColor(.black)
                            
                        }
                        HStack(){
                            Image(systemName: "phone.fill").foregroundColor(.green)
                            Image(systemName: "message.fill").foregroundColor(.orange)
                        }
                        
                    }
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 3)
                    )
                }
                
                
                Button{
                } label: {
                    HStack{
                        Image(systemName: "person.crop.circle").resizable().frame(width: 40, height: 40)
                        VStack{
                            Text("Kim Jia").foregroundColor(.black).bold()
                            Text("0400 999 999").foregroundColor(.black)
                            Text("Psychiatrist").foregroundColor(.black)
                            
                        }
                        HStack(){
                            Image(systemName: "phone.fill").foregroundColor(.green)
                            Image(systemName: "message.fill").foregroundColor(.orange)
                        }
                        
                        
                        
                    }
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 3)
                    )
                    
                }
                
                Button{
                } label: {
                    HStack{
                        Image(systemName: "person.crop.circle").resizable().frame(width: 40, height: 40)
                        VStack{
                            Text("Lina Lin").foregroundColor(.black).bold()
                            Text("0400 999 999").foregroundColor(.black)
                            Text("Family").foregroundColor(.black)
                            
                        }
                        HStack(){
                            Image(systemName: "phone.fill").foregroundColor(.green)
                            Image(systemName: "message.fill").foregroundColor(.orange)
                        }
                        
                        
                        
                    }
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 3)
                    )
                    
                }
                Spacer()
                
                
                HStack(alignment: .bottom,spacing:20) {

                    
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
                    .padding(.leading,200)
                }
                Spacer()
                

            
        
                
                
            }
        }
    }
}

#Preview {
    ContactList()
}

