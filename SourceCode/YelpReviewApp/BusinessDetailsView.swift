//
//  BusinessDetails.swift
//  YelpReviewApp
//
//  Created by Fernando Torres on 12/5/22.
//

import SwiftUI
import SwiftyJSON
import Kingfisher
import Alamofire

extension View {
    func toast<Content>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View where Content: View {
        BottomToast(
            isPresented: isPresented,
            presenter: { self },
            content: content
        )
    }
}

struct BusinessDetailsView: View {
    let id: String
    let showDetails : Bool
    
    @State var showSheet = false
    @State var showCancelToast = false
    @AppStorage("reservations") var reservations: Data = Data()
    
    func getRes() -> [String:[String]]{
        guard let decodedRes = try? JSONDecoder().decode([String:[String]].self, from: reservations) else { return [:]}
        return decodedRes
    }
    
    func setRes(res: [String:[String]]) -> Data{
        guard let reservations = try? JSONEncoder().encode(res) else {return Data()}
        
        return reservations
    }
    
    func makeCatStr() -> String{
        var str = ""
        let count = savedBusinessDetails[id]?.categories.count ?? 5
        for i in 0..<count{
            if(i==count-1){
                str = str + (savedBusinessDetails[id]?.categories[i] ?? "")
            }else{
                str = str + (savedBusinessDetails[id]?.categories[i] ?? "") + " | "
            }
        }
        
        return str
    }
    
    func cancelRes(){
        showCancelToast.toggle()
        var res = getRes()
        
        if res.count == 1{
            res.removeAll()
            self.reservations = Data()
        }else{
            res.removeValue(forKey: id)
            
            self.reservations = setRes(res: res)
        }
    }
    
    var body: some View {
        VStack {
            if showDetails {
                VStack {
                    HStack{
                        Spacer()
                        Text(savedBusinessDetails[id]?.name ?? "").font(.title).bold().fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }.padding(.vertical, 40.0)
                    
                    HStack{
                        Text("Address").font(.headline).fontWeight(.semibold)
                        Spacer()
                        Text("Category").font(.headline).fontWeight(.semibold)
                    }.padding(.horizontal)
                    HStack{
                        VStack(alignment: .leading){
                            Text(savedBusinessDetails[id]?.address[0] ?? "").font(.subheadline).foregroundColor(.gray).fixedSize()
                            Text(savedBusinessDetails[id]?.address[1] ?? "").font(.subheadline).foregroundColor(.gray).fixedSize()
                        }
                        Spacer()
                        
                        HStack {
                            Text(makeCatStr()).font(.subheadline).foregroundColor(.gray).fixedSize(horizontal: false, vertical: true)
                        }
                    }.padding([.leading, .bottom, .trailing])
                    
                    HStack{
                        Text("Phone").font(.headline).fontWeight(.semibold)
                        Spacer()
                        Text("Price Range").font(.headline).fontWeight(.semibold)
                    }.padding(.horizontal)
                    HStack{
                        Text(savedBusinessDetails[id]?.phone ?? "").font(.subheadline).foregroundColor(.gray)
                        Spacer()
                        Text(savedBusinessDetails[id]?.price ?? "").font(.subheadline).foregroundColor(.gray)
                    }.padding([.leading, .bottom, .trailing])
                    
                    HStack{
                        Text("Status").font(.headline).fontWeight(.semibold)
                        Spacer()
                        Text("Visit Yelp for more").font(.headline).fontWeight(.semibold)
                    }.padding(.horizontal)
                    HStack{
                        if ((savedBusinessDetails[id]?.status! ?? false)) {
                            Text("Open Now").font(.subheadline).foregroundColor(.green)
                        } else {
                            Text("Closed").font(.subheadline).foregroundColor(.red)
                        }
                        Spacer()
                        if(savedBusinessDetails[id]?.url!.isEmpty ?? false){
                            Text("N/A").font(.subheadline).foregroundColor(.accentColor)
                        }else{
                            Link("Business Link", destination: URL(string: savedBusinessDetails[id]?.url ?? "https://www.google.com")!)
                        }
                        
                    }.padding(.horizontal)
                    
                    HStack{
                        Spacer()
                        if !getRes().contains{$0.key == id} {
                            Button(action:{
                                showSheet.toggle()
                            }){
                                Text("Reserve Now")
                                    .padding(.all)
                                    .padding(.horizontal, 1)
                            }
                            .foregroundColor(.white)
                            .background(.red)
                            .cornerRadius(15)
                            .buttonStyle(.borderless)
                            .sheet(isPresented: $showSheet) {
                                ReservationFormView(id: id, name: savedBusinessDetails[id]?.name ?? "")
                        }
                        } else {
                            Button(action:{
                                cancelRes()
                            }){
                                Text("Cancel Reservation")
                                    .padding(.all)
                                    .padding(.horizontal, 1)
                            }
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(15)
                            .buttonStyle(.borderless)
                        }
                        Spacer()
                    }
                    
                    HStack{
                        Spacer()
                        Text("Share on:").fontWeight(.bold).font(.subheadline)
                        Link(destination: URL(string: "https://www.facebook.com/sharer/sharer.php?u=\(savedBusinessDetails[id]?.url! ?? "")")!) {
                            Image("FacebookImage").resizable().frame(width:30, height:30)
                        }
                        
                        Link(destination:URL(string: "https://twitter.com/intent/tweet?url=\(savedBusinessDetails[id]?.url! ?? "")")!) {
                            Image("TwitterImage").resizable().frame(width:30, height:30)
                        }
                        Spacer()
                    }
                    
                    HStack{
                        ImageView(id: id)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)).frame(width: 300, height: 250)
                    }
               }.toast(isPresented: $showCancelToast){
                   Text("Your reservation is cancelled.")
               }
               .padding(.bottom, 800.0)
                
                
            } else {
                EmptyView()
            }
        }
    }
}

struct BusinessDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessDetailsView(id: "", showDetails: true)
    }
}
