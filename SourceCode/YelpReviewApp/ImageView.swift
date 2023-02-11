//
//  ImageView.swift
//  YelpReviewApp
//
//  Created by Fernando Torres on 12/6/22.
//
//taken from https://medium.com/@mahdi.mahjoobi/image-slider-in-swiftui-59bac18ae4f4

import SwiftUI
import Kingfisher

struct ImageView: View {
    let id:String
        
        var body: some View {
            TabView {
                ForEach(savedBusinessDetails[id]?.photos ?? [], id: \.self) { item in
                    KFImage(URL(string: item)!)
                        .resizable()
                        .scaledToFill()
                }
            }
            .tabViewStyle(PageTabViewStyle())
        }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(id: "")
            .previewLayout(.fixed(width: 400, height: 300))
    }
}
