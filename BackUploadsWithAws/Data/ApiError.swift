//
//  ApiError.swift
//  BackUploadsWithAws
//
//  Created by ezen on 14/09/2023.
//

import Foundation

struct ApiError: Error {
	let message: String
	
	var object: Any? = nil
	
	init(_ message: String) {
		self.message = message
	}
	
	init(_ message: String, error: Any?) {
		self.message = message
		self.object = error
	}
}
