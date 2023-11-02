//
//  FetchAllFolders.swift
//  BackUploadsWithAws
//
//  Created by ezen on 15/09/2023.
//

import Foundation

protocol FetchAllFolders {
	
	func execute() -> [ChatFolder]
}

struct FetchAllFoldersUseCase: FetchAllFolders {
	
	var api: ChatFolderApi
	
	func execute() -> [ChatFolder] {

		return api.getAllFolders()
	}
}
