//
//  OngoingsViewModel.swift
//  BackUploadsWithAws
//
//  Created by ezen on 14/09/2023.
//

import Foundation
import UIKit
import SwiftUI

class OngoingsViewModel: ObservableObject {

	var host: OngoingsViewController
	
	init(host: UIViewController) {

		guard host is OngoingsViewController else {
			self.host = OngoingsViewController()
			return
		}
		self.host = host as! OngoingsViewController
	}
}
