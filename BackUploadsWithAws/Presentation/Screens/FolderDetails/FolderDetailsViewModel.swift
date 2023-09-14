//
//  FolderDetailsViewModel.swift
//  BackUploadsWithAws
//
//  Created by ezen on 14/09/2023.
//

import Foundation
import UIKit

class FolderDetailsViewModel: ObservableObject {
	var host: FolderDetailsViewController
	
	init(host: UIViewController) {
		guard host is FolderDetailsViewController else {
			self.host = FolderDetailsViewController()
			return
		}
		self.host = host as! FolderDetailsViewController
	}
}
