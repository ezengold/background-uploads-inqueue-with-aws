//
//  ChatsViewModel.swift
//  BackUploadsWithAws
//
//  Created by ezen on 13/09/2023.
//

import Foundation
import UIKit

class ChatsViewModel: ObservableObject {

	var host: ChatsViewController
	
	// MARK: Use cases
	var fetchFoldersUseCase = FetchAllFoldersUseCase(api: ChatFolderApi.shared)
	
	@Published var data: [ChatFolder] = []
	
	init(host: UIViewController) {

		guard host is ChatsViewController else {
			self.host = ChatsViewController()
			return
		}
		self.host = host as! ChatsViewController
	}
	
	func fetchAllData() {

		self.data = fetchFoldersUseCase.execute()
	}
	
	func viewDetails(of item: ChatFolder) {

		self.host.showDetailsView(ofFolder: item)
	}
}
