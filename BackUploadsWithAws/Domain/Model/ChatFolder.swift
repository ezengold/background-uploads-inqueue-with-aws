//
//  ChatFolder.swift
//  BackUploadsWithAws
//
//  Created by ezen on 12/09/2023.
//

import Foundation

struct ChatFolder: Codable, Identifiable {
	let id: String
	var contents: [ChatFile]
}
