//
//  ResultRowView.swift
//  YelpReviewApp
//
//  Created by Fernando Torres on 12/5/22.
//

import SwiftUI
import Kingfisher

struct ResultRowView: View {
    let business : Business
    
    func getDist() -> Int{
        let dist = Int(round(business.distance / 1609.34))
        return dist
    }
    
    
    var body: some View {
        HStack{
            Text(String(business.num))
            Spacer()
            KFImage(URL(string: business.imageURL)!).resizable().frame(width: 60, height: 60).cornerRadius(10)
            Spacer()
            Text(business.name).frame(width: 70, alignment: .leading)
            Spacer()
            Text(String(business.rating))
            Spacer()
            Text(String(getDist()))
        }
        .padding(.vertical)
    }
}

struct ResultRowView_Previews: PreviewProvider {
    static var previews: some View {
        ResultRowView(business: Business(num: 0, id: "", name: "", rating: 0, distance: 0, imageURL: ""))
    }
}
