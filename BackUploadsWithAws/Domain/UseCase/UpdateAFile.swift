//
//  UpdateAFile.swift
//  BackUploadsWithAws
//
//  Created by ezen on 24/10/2023.
//

import Foundation

protocol UpdateAFile {
	func execute(forFile: UploadFile) throws
	func execute(forFile: UploadFile, shouldUpdateStatus: Bool) throws
}

struct UpdateAFileUseCase: UpdateAFile {
	
	var api: ChatFolderApi
	
	func execute(forFile file: UploadFile) throws {
		try api.updateFile(ofId: file.id, with: file)
	}
	
	func execute(forFile file: UploadFile, shouldUpdateStatus: Bool) throws {
		try api.updateFile(ofId: file.id, with: file, shouldUpdateStatus: shouldUpdateStatus)
	}
}
