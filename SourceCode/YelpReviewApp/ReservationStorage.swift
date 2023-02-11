//
//  ReservationStorage.swift
//  YelpReviewApp
//
//  Created by Fernando Torres on 12/8/22.
//

import SwiftUI

struct ReservationStorage: View {
    let display: Bool
    
    @AppStorage("reservations") var reservations: Data = Data()
    
    func getRes() -> [String:[String]]{
        guard let decodedRes = try? JSONDecoder().decode([String:[String]].self, from: reservations) else { return [:]}
        return decodedRes
    }
    
    func setRes(res: [String:[String]]) -> Data{
        guard let reservations = try? JSONEncoder().encode(res) else {return Data()}
        
        return reservations
    }
    
    func delete(at offsets: IndexSet) {
        
        var res = getRes()
        print(res)
        
        let keys = res.keys.sorted()
        
        let i = offsets.first! as Int
        
        if res.count == 1{
            res.removeAll()
            print(res)
            self.reservations = Data()
        }else{
            res.removeValue(forKey: keys[i])
            print(res)
            self.reservations = setRes(res: res)
        }
    }
    
    
    var body: some View {
        if(display){
            
            let res = getRes()
            
            NavigationStack{
                
                if(res.isEmpty){
                    VStack {
                        Spacer()
                        Text("No Reservations").font(.subheadline).bold().foregroundColor(.red)
                        Spacer()
                    }
                }else{
                    
                    List{
                        ForEach(res.keys.sorted(), id: \.self){ item in
                            HStack{
                                Text(res[item]![0]).frame(width: 70, alignment: .leading)
                                Spacer()
                                Text(res[item]![1])
                                Spacer()
                                Text("\(res[item]![2]):\(res[item]![3])")
                                Spacer()
                                Text(res[item]![4])
                            }.font(.footnote)
                        }.onDelete(perform: delete)
                    }
                }
                
            }.navigationTitle("Your Reservations")
            }
        }
    }


struct ReservationStorage_Previews: PreviewProvider {
    static var previews: some View {
        ReservationStorage(display: true)
    }
}
