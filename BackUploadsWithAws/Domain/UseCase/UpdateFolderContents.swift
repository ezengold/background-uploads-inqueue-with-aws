//
//  UpdateFolderContents.swift
//  BackUploadsWithAws
//
//  Created by ezen on 16/10/2023.
//

import Foundation

protocol UpdateFolderContents {
	
	func execute(forFolder: ChatFolder) throws
}

struct UpdateFolderContentsUseCase: UpdateFolderContents {
	
	var api: ChatFolderApi
	
	func execute(forFolder folder: ChatFolder) throws {

		try api.updateFolder(ofId: folder.id, with: folder)
	}
}
