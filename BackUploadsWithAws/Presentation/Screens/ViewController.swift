//
//  ViewController.swift
//  BackUploadsWithAws
//
//  Created by ezen on 28/07/2024.
//

import UIKit

class ViewController: UIViewController {
	
	var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let textStyle = NSMutableParagraphStyle()
		textStyle.minimumLineHeight = 25
		label.attributedText = NSAttributedString(string: "Lorem ipsum", attributes: [.paragraphStyle: textStyle])
		
		NotificationCenter.default.post(
			name: Notification.Name("Lorem Ipsum"),
			object: nil
		)
    }
}
