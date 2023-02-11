//
//  UIView+Extension.swift
//  YelpReviewApp
//
//  Created by Fernando Torres on 12/5/22.
//

import UIKit

//code taken from https://pspdfkit.com/blog/2022/presenting-popovers-on-iphone-with-swiftui/
extension UIView {
    func closestVC() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let vc = responder as? UIViewController {
                return vc
            }
            responder = responder?.next
        }
        return nil
    }
}
