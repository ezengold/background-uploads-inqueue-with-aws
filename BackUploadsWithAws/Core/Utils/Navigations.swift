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
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	func showDetailsView(ofFolder folder: ChatFolder) {
		lazy var vc = FolderDetailsViewController()
		vc.folder = folder
		vc.view.backgroundColor = .white
		self.navigationController?.pushViewController(vc, animated: true)
	}
}
