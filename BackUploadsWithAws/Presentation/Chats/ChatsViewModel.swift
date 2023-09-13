//
//  ChatsViewModel.swift
//  BackUploadsWithAws
//
//  Created by ezen on 13/09/2023.
//

import Foundation
import UIKit
import SwiftUI

class ChatsViewModel: ObservableObject {
	var host: ChatsViewController
	
	@Published var keywords: String = ""
	
	init(host: UIViewController) {		
		guard host is ChatsViewController else {
			self.host = ChatsViewController()
			return
		}
		self.host = host as! ChatsViewController
	}
}
