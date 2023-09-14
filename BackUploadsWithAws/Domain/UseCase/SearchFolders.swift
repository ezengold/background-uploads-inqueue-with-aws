//
//  SearchFolders.swift
//  BackUploadsWithAws
//
//  Created by ezen on 14/09/2023.
//

import Foundation

protocol SearchFolders {
	func execute(with keywords: String) -> [ChatFolder]
}

struct SearchFoldersUseCase: SearchFolders {
	
	var api: ChatFolderApi
	
	func execute(with keywords: String) -> [ChatFolder] {

		return api.getFoldersFiltered(with: keywords)
	}
}
