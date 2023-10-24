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
	
	@Published var isLoading: Bool = true
	
	// MARK: Use cases
	var fetchFoldersUseCase = FetchAllFoldersUseCase(api: ChatFolderApi.shared)

	var searchFoldersUseCase = SearchFoldersUseCase(api: ChatFolderApi.shared)
	
	@Published var keywords: String = "" {
		didSet { filterData() }
	}
	
	@Published var data: [ChatFolder] = []
	
	init(host: UIViewController) {

		guard host is ChatsViewController else {
			self.host = ChatsViewController()
			return
		}
		self.host = host as! ChatsViewController
	}
	
	func fetchAllData() {
		DispatchQueue.main.async {
			self.isLoading = true
		}

		Task {
			let result = await fetchFoldersUseCase.execute()
			
			DispatchQueue.main.async {
				self.isLoading = false
			}

			switch result {
			case .success(let matches):
				DispatchQueue.main.async {
					self.data = matches
				}
				
			case .failure(let error):
				DispatchQueue.main.async {
					self.host.toast(error.message)
					self.data = []
				}
			}
		}
	}
	
	private func filterData() {

		self.data = searchFoldersUseCase.execute(with: self.keywords)
	}
	
	func viewDetails(of item: ChatFolder) {

		self.host.showDetailsView(ofFolder: item)
	}
}
