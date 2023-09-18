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
	
	var folder: ChatFolder
	
	init(host: UIViewController, withFolder: ChatFolder) {

		self.folder = withFolder

		guard host is FolderDetailsViewController else {
			self.host = FolderDetailsViewController()
			return
		}

		self.host = host as! FolderDetailsViewController
	}
}
