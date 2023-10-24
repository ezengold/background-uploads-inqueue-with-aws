//
//  ChatFolder.swift
//  BackUploadsWithAws
//
//  Created by ezen on 12/09/2023.
//

import Foundation

struct ChatFolder: Codable, Identifiable, Equatable {
	let id: String
	let folderName: String
	var contents: [ChatFile]
	
	func getLastestChangeDate() -> Date? {
		
		guard !self.contents.isEmpty else {
			return nil
		}
		
		return self.contents.reduce(Date()) { lastDate, currentFile in
			return currentFile.addedAt > lastDate ? currentFile.addedAt : lastDate
		}
	}
	
	static let DUMMY_FOLDER = ChatFolder(id: "1", folderName: "Dummy Folder", contents: [])
	
	static func == (lhs: ChatFolder, rhs: ChatFolder) -> Bool {
		lhs.id == rhs.id
	}
}
