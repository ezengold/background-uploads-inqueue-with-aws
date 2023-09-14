//
//  Constants.swift
//  BackUploadsWithAws
//
//  Created by ezen on 12/09/2023.
//

import Foundation

struct Constants {
	static let ROOT_IDENTIFIER = "\(Bundle.main.bundleIdentifier ?? "")"
	
	static let UPLOAD_TEMP_PATH: String = "uploads"
	static let UPLOAD_QUEUE_PREFS_STATE_KEY: String = "\(ROOT_IDENTIFIER).UPLOAD_QUEUE_PREFS_STATE_KEY"
	
	static let FOLDERS_HAS_BEEN_SAVED_ONCE: String = "\(ROOT_IDENTIFIER).FOLDERS_HAS_BEEN_SAVED_ONCE"
	static let FOLDERS_SAVED: String = "\(ROOT_IDENTIFIER).FOLDERS_SAVED"
}
