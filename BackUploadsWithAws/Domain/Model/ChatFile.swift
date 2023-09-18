//
//  ChatFile.swift
//  BackUploadsWithAws
//
//  Created by ezen on 13/09/2023.
//

import Foundation

struct ChatFile: Codable, Identifiable {
	let id: String
	var file: UploadFile
	var addedAt: Date
}
