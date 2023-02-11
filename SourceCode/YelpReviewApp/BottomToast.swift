//
//  BottomToast.swift
//  YelpReviewApp
//
//  Created by Fernando Torres on 12/8/22.
//

import SwiftUI

struct BottomToast<Presenting, Content>: View where Presenting: View, Content: View {
    @Binding var isPresented: Bool
    let presenter: () -> Presenting
    let content: () -> Content
    let delay: TimeInterval = 2

    var body: some View {
        if self.isPresented {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                withAnimation {
                    self.isPresented = false
                }
            }
        }

        return GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                self.presenter()

                ZStack {
                    RoundedRectangle(cornerSize: .init(width: 20, height: 20))
                        .fill(Color.gray)

                    self.content()
                } //ZStack (inner)
                .frame(width: geometry.size.width / 1.75, height: geometry.size.height / 10)
                .opacity(self.isPresented ? 1 : 0)
            }
        }
    }
}
