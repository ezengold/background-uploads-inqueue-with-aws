//
//  DeleteAnUploadFile.swift
//  BackUploadsWithAws
//
//  Created by ezen on 02/11/2023.
//

import Foundation

protocol DeleteAnUploadFile {

	func execute(forFileId: String) throws
}

struct DeleteAnUploadFileUseCase: DeleteAnUploadFile {

	var api: ChatFolderApi
	
	func execute(forFileId: String) throws {

		try api.deleteFile(ofId: forFileId)
	}
}
