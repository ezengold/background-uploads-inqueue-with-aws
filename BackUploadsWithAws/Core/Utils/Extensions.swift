//
//  Extensions.swift
//  BackUploadsWithAws
//
//  Created by ezen on 12/09/2023.
//

import Foundation
import UIKit
import SwiftUI

struct AlertButton {
	var title: String
	var style: UIAlertAction.Style = .default
	var action: ((UIAlertAction) -> Void)?
	
	static let OKAY = AlertButton(title: "Okay")
}

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
	
	@objc 
	func hideKeyboard() {
		view.endEditing(true)
	}
	
	func alert(withTitle alertTitle: String = "", message: String, buttons: [AlertButton] = [.OKAY], style: UIAlertController.Style = .alert) {
		let alertCtrl = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
		
		for button in buttons {
			alertCtrl.addAction(UIAlertAction(title: button.title, style: button.style, handler: button.action))
		}
		
		present(alertCtrl, animated: true)
	}
}

extension UIView {

	@IBInspectable var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		
		set {
			layer.cornerRadius = newValue
			layer.masksToBounds = newValue > 0
		}
	}
	
	@IBInspectable var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		
		set {
			layer.borderWidth = newValue
		}
	}
	
	@IBInspectable var borderColor: UIColor? {
		get {
			return UIColor(cgColor: layer.borderColor!)
		}
		
		set {
			layer.borderColor = newValue?.cgColor
		}
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
	static let appFileBack: Color = Color(red: 141/255, green: 149/255, blue: 166/255)
}

extension UIColor {
	
	static let appPrincipal: UIColor = UIColor(named: "AccentColor") ?? .init(red: 0.251, green: 0.482, blue: 1.0, alpha: 1.0)
}

extension Date {

	func toFormat(_ format: String) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		return dateFormatter.string(from: self)
	}
}
