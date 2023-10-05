//
//  UploadFile.swift
//  BackUploadsWithAws
//
//  Created by ezen on 12/09/2023.
//

import Foundation

struct UploadFile: Codable {
	
	var id: String
	
	var s3UploadKey: String
	
	var fileUrl: URL?
	
	var contentType: FileType
	
	var expiresAt: Date?
	
	var progress: Double = 0.0
	
	var status: TaskStatus = .pending
	
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
	
	func getActualUrl() -> URL? {
		let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
		let dirFolderUrl = documentsDirectoryURL.appendingPathComponent(Constants.UPLOAD_TEMP_PATH)
		let actualURL = dirFolderUrl.appendingPathComponent(self.getFileName())
		
		return actualURL
	}
}
