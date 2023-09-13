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
	
	@Published var data: [ChatFolder] = [
		.init(id: "1", folderName: "Anime wallpapers HD", contents: []),
		.init(id: "2", folderName: "BNL Songs Record", contents: []),
	]
	
	var filteredData: [ChatFolder] {
		get { getFilteredData() }
	}
	
	init(host: UIViewController) {		
		guard host is ChatsViewController else {
			self.host = ChatsViewController()
			return
		}
		self.host = host as! ChatsViewController
	}
	
	private func getFilteredData() -> [ChatFolder] {
		let predicate = NSPredicate(format: "SELF contains[c] %@", self.keywords)
		
		if keywords.isEmpty {
			return self.data
		} else {
			return self.data.filter { predicate.evaluate(with: ($0.folderName).uppercased()) }
		}
	}
}
