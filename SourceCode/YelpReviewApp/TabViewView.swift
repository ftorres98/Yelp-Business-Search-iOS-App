//
//  TabView.swift
//  YelpReviewApp
//
//  Created by Fernando Torres on 12/8/22.
//

import SwiftUI

struct TabViewView: View {
    let id: String
    let display: Bool
    
    var body: some View {
        if(display){
            TabView{
                BusinessDetailsView(id: id, showDetails: true)
                    .tabItem {
                        Label("Business Detail", systemImage: "text.bubble")
                    }
                MapView(id: id, lat: savedBusinessDetails[id]?.coordinates[0]! ?? 40.75773, lng: savedBusinessDetails[id]?.coordinates[1]! ?? -73.985708)
                    .tabItem {
                        Label("Map Location", systemImage: "location.fill")
                    }
                ReviewView(id: id, willGetReviews: true)
                    .tabItem {
                        Label("Reviews", systemImage: "message.fill")
                    }
            }
        }
    }
}

struct TabViewView_Previews: PreviewProvider {
    static var previews: some View {
        TabViewView(id: "", display: true)
    }
}
