//
//  Navigations.swift
//  BackUploadsWithAws
//
//  Created by ezen on 14/09/2023.
//

import Foundation
import UIKit

extension UIViewController {
	
	func showOngoingUploads() {
		lazy var vc = OngoingsViewController()
		vc.view.backgroundColor = .white
		vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
		vc.navigationItem.backBarButtonItem?.tintColor = .appPrincipal
		self.navigationController?.pushViewController(vc, animated: true)
	}
}
