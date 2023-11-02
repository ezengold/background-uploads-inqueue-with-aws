//
//  UploadFile.swift
//  BackUploadsWithAws
//
//  Created by ezen on 12/09/2023.
//

import Foundation

struct UploadFile: Codable, Equatable {
	
	var id: String
	
	var s3UploadKey: String
	
	/**
	 URL of the file to inside directory `UploadService.UPLOAD_TEMP_PATH`
	 */
	var fileUrl: URL?
	
	var contentType: FileType
	
	var expiresAt: Date?
	
	var progress: Double = 0.0
	
	var status: TaskStatus = .pending
	
	/**
	 Link to the file from AWS after the upload is successfully completed
	 */
	var publicUrl: String = ""
	
	var error: String?
	
	func getFileName() -> String {
		return "\(id).\(fileUrl?.pathExtension ?? "")"
	}
	
	func isExpired() -> Bool {
		guard let expiryDate = self.expiresAt else {
			return true
		}
		return expiryDate < Date()
	}
	
	/**
	 The URL of the file has to be refetch relatively from Document directory because the runtine `documentDirectory` value can change
	 */
	func getActualUrl() -> URL? {
		let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
		let dirFolderUrl = documentsDirectoryURL.appendingPathComponent(UploadService.UPLOAD_TEMP_PATH)
		let actualURL = dirFolderUrl.appendingPathComponent(self.getFileName())

		return actualURL
	}
	
	static func == (lhs: UploadFile, rhs: UploadFile) -> Bool {
		lhs.id == rhs.id
	}
}
