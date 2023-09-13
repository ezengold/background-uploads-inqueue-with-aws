//
//  Extensions.swift
//  BackUploadsWithAws
//
//  Created by ezen on 12/09/2023.
//

import Foundation
import UIKit
import SwiftUI

extension Double {
	
	func toPercentage() -> Double {
		let divisor = pow(10.0, Double(2))
		return (self * divisor).rounded() / divisor
	}
}

extension UIViewController {
	
	func hideKeyboardWhenTappedAround() {
		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard)))
	}
	
	@objc func hideKeyboard() {
		view.endEditing(true)
	}
}

extension Font {
	static func appRegularFont(ofSize: CGFloat) -> Font {
		return Font.custom("OpenSans-Regular", size: ofSize)
	}
	
	static func appBoldFont(ofSize: CGFloat) -> Font {
		return Font.custom("OpenSans-Bold", size: ofSize)
	}
	
	static func appSemiBoldFont(ofSize: CGFloat) -> Font {
		return Font.custom("OpenSans-SemiBold", size: ofSize)
	}
}

extension UIFont {
	static func appRegularFont(ofSize: CGFloat) -> UIFont {
		return UIFont(name: "OpenSans-Regular", size: ofSize) ?? .systemFont(ofSize: ofSize, weight: .regular)
	}
	
	static func appBoldFont(ofSize: CGFloat) -> UIFont {
		return UIFont(name: "OpenSans-Bold", size: ofSize) ?? .systemFont(ofSize: ofSize, weight: .bold)
	}
	
	static func appSemiBoldFont(ofSize: CGFloat) -> UIFont {
		return UIFont(name: "OpenSans-SemiBold", size: ofSize) ?? .systemFont(ofSize: ofSize, weight: .semibold)
	}
}

extension Color {
	static let appPrincipal: Color = Color("AccentColor")
	static let appDarkGray: Color = Color(red: 63/255, green: 63/255, blue: 63/255)
}

extension UIColor {
	static let appPrincipal: UIColor = UIColor(named: "AccentColor") ?? .init(red: 0.251, green: 0.482, blue: 1.0, alpha: 1.0)
}
