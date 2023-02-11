//
//  View+Modifiers.swift
//  YelpReviewApp
//
//  Created by Fernando Torres on 12/5/22.
//

import SwiftUI

//code taken from https://pspdfkit.com/blog/2022/presenting-popovers-on-iphone-with-swiftui/
extension View {
    public func alwaysPopover<Content>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        self.modifier(AlwaysPopoverModifier(isPresented: isPresented, contentBlock: content))
    }
}
