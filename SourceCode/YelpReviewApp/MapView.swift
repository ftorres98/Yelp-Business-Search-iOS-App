//
//  MapView.swift
//  YelpReviewApp
//
//  Created by Fernando Torres on 12/8/22.
//

import SwiftUI
import MapKit
   
struct AnnotatedItem: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    var id: String
    var lat: Double
    var lng: Double
    @State private var coor : MKCoordinateRegion
    var location : [AnnotatedItem] = []
    
    init(id: String, lat: Double, lng: Double) {
        self.id = id
        self.lat = lat
        self.lng = lng
        
        self.coor = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        location = [AnnotatedItem(name: "Times Square", coordinate: .init(latitude: self.lat, longitude: self.lng))]
    }
    
    var body: some View {
        Map(coordinateRegion: $coor, annotationItems: location){
            item in MapMarker(coordinate: item.coordinate)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(id: "", lat: 40.75773, lng: -73.985708)
    }
}
