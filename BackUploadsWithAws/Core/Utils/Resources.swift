//
//  Resources.swift
//  BackUploadsWithAws
//
//  Created by ezen on 18/09/2023.
//

import Foundation

struct Resources {
	
	static let dummyVideo = Bundle.main.url(forResource: "dummy", withExtension: "mp4")!
	
	static let dummyDocument = Bundle.main.url(forResource: "dummy", withExtension: "pdf")!
	
	static let dummyFolders = Bundle.main.url(forResource: "folders", withExtension: "json")
}
