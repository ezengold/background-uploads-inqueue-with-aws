//
//  Toast.swift
//  BackUploadsWithAws
//
//  Created by ezen on 14/09/2023.
//

import Foundation
import UIKit

class Toast: UIView {

	@IBOutlet weak var container: UIView!
	
	@IBOutlet weak var messageLabel: UILabel!
	
	var message: String = "" {
		didSet {
			makeView()
		}
	}
	
	var messageFont: UIFont? = nil  {
		didSet {
			makeView()
		}
	}
	
	override func awakeFromNib() {

		super.awakeFromNib()
		
		makeView()
	}
	
	func makeView() {

		let textStyle = NSMutableParagraphStyle()

		textStyle.minimumLineHeight = 20
		
		self.messageLabel.attributedText = NSAttributedString(string: self.message, attributes: [
			.paragraphStyle: textStyle,
			.font: self.messageFont ?? .appRegularFont(ofSize: 12)
		])
	}
	
	static func xibView() -> Toast? {

		let nib = UINib(nibName: "Toast", bundle: nil)
		let xibView = nib.instantiate(withOwner: self, options: nil)[0] as? Toast
		return xibView
	}
}

extension UIViewController {
	
	func toast(_ message: String, withFont font: UIFont? = nil) {

		if message.isEmpty { return }

		if let toastView = Toast.xibView() {
			toastView.messageFont = font
			toastView.message = message
			toastView.messageLabel.textAlignment = .center
			
			toastView.container.layer.shadowColor = UIColor.black.cgColor
			toastView.container.layer.shadowOpacity = 0.1
			toastView.container.layer.shadowRadius = 5
			toastView.container.layer.shadowOffset = CGSize(width: 0, height: 0)
			toastView.container.clipsToBounds = false
			
			toastView.alpha = 0.0
			
			if let mainWindow = (
				UIApplication
					.shared
					.connectedScenes.compactMap { $0 as? UIWindowScene }
					.flatMap { $0.windows }
					.last { $0.isKeyWindow }
			) {
				mainWindow.addSubview(toastView)
				
				toastView.translatesAutoresizingMaskIntoConstraints = false
				
				NSLayoutConstraint.activate([
					NSLayoutConstraint(item: toastView, attribute: .bottom, relatedBy: .equal, toItem: mainWindow, attribute: .bottom, multiplier: 1.0, constant: -50),
					NSLayoutConstraint(item: toastView, attribute: .leading, relatedBy: .equal, toItem: mainWindow, attribute: .leading, multiplier: 1.0, constant: 0),
					NSLayoutConstraint(item: toastView, attribute: .trailing, relatedBy: .equal, toItem: mainWindow, attribute: .trailing, multiplier: 1.0, constant: 0)
				])
				
				UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
					toastView.alpha = 1.0
				} completion: { _ in
					UIView.animate(withDuration: 0.1, delay: 5.0, options: .curveEaseOut, animations: {
						toastView.alpha = 0.0
					}, completion: {_ in
						toastView.removeFromSuperview()
					})
				}
			}
		}
	}
}
