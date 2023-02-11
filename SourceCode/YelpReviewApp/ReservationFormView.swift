//
//  ReservationFormView.swift
//  YelpReviewApp
//
//  Created by Fernando Torres on 12/8/22.
//

import SwiftUI

extension View {
    func bottomtoast<Content>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View where Content: View {
        BottomToast(
            isPresented: isPresented,
            presenter: { self },
            content: content
        )
    }
}

struct ReservationFormView: View {
    let id: String
    let name: String
    
    @Environment(\.dismiss) var dismiss
    @AppStorage("reservations") var reservations: Data = Data()
    
    @State var email: String = ""
    var hours = ["10", "11", "12", "13", "14", "15", "16", "17"]
    var minutes = ["00", "15", "30", "45"]
    @State var hour = "10"
    @State var minute = "00"
    @State var selectedDate : Date = Date()
    @State var showError = false
    @State var showConfirmation = false
    
    func isEmailValid(email: String) ->Bool{
        if email.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
                
        return emailPredicate.evaluate(with: email)
    }
    
    func submitButton(){
        if(!isEmailValid(email: email)){
            showError.toggle()
            email = ""
        }else{
            showConfirmation.toggle()
            
            if self.reservations.isEmpty{
                var temp: [String:[String]] = [:]
                
                temp[id] = [name, selectedDate.formatted(date: .numeric, time: .omitted), hour, minute, email]
                guard let reservations = try? JSONEncoder().encode(temp) else { return }
                self.reservations = reservations
            }else{
                guard var decodedRes = try? JSONDecoder().decode([String:[String]].self, from: reservations) else { return }
                
                decodedRes[id] = [name, selectedDate.formatted(date: .numeric, time: .omitted), hour, minute, email]
                
                guard let reservations = try? JSONEncoder().encode(decodedRes) else { return }
                self.reservations = reservations
            }
            
            
        }
    }
    
    var body: some View {
        VStack {
            if !showConfirmation {
                VStack {
                List{
                    Section{
                        HStack{
                            Spacer()
                            Text("Resvervation Form").font(.title).fontWeight(.bold)
                            Spacer()
                        }
                    }
                    Section{
                        HStack{
                            Spacer()
                            Text(name).font(.title).fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    Section{
                        HStack{
                            Text("Email: ")
                                .foregroundColor(.gray)
                            TextField("", text: $email).textContentType(.emailAddress)
                        }.padding(.vertical)
                        HStack{
                            Spacer()
                            Text("Date/Time:")
                                .foregroundColor(.gray).fixedSize()
                            Spacer()
                            DatePicker("date", selection: $selectedDate,in: Date.now..., displayedComponents: .date).labelsHidden()
                            Spacer()
                            Picker("" , selection: $hour){
                                ForEach(hours, id: \.self){ item in
                                    Text(item)
                                }
                            }.labelsHidden().pickerStyle(.menu).buttonStyle(.bordered).accentColor(.black).frame(width: 40).clipped()
                            Spacer()
                            Text(":").frame(width: 4)
                            Spacer()
                            Picker("" , selection: $minute){
                                ForEach(minutes, id: \.self){ item in
                                    Text(item)
                                }
                            }.labelsHidden().pickerStyle(.menu).buttonStyle(.bordered).accentColor(.black).frame(width: 40).clipped()
                        }.padding(.vertical)
                        HStack{
                            Spacer()
                            Button(action: {
                                submitButton()
                            }){
                                Text("Submit")
                                    .padding(.all)
                                    .padding(.horizontal, 20)
                            }
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(15)
                            .buttonStyle(.borderless)
                            Spacer()
                        }.padding(.vertical)
                    }
                }.bottomtoast(isPresented: $showError){
                    Text("Please enter a valid email.")
                }
            }
            } else {
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Text("Congratulations!").padding().foregroundColor(.white)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Text("You have successfully made a reservation at \(name)").multilineTextAlignment(.center).padding().foregroundColor(.white)
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            dismiss()
                        }){
                            Text("Done")
                                .padding(.all)
                                .padding(.horizontal, 40)
                        }
                        .foregroundColor(.green)
                        .background(.white)
                        .cornerRadius(50)
                        .buttonStyle(.borderless)
                       Spacer()
                    }
                }.background(.green)
            }
        }
    }
}

struct ReservationFormView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationFormView(id: "", name: "")
    }
}
