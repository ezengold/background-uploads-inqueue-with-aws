//
//  S3Keys.swift
//  BackUploadsWithAws
//
//  Created by ezen on 12/09/2023.
//

import Foundation

/**
 Hold AWS keys
 Never use static values. Always fetch the keys at runtime. Maybe when app lauches in AppDelegate
 */
struct S3Keys {
	static let shared = S3Keys()
	
	var accessKey: String = ""
	
	var secretKey: String = ""
	
	var s3Bucket: String = ""
	
	mutating func fetchKeys() {
		// TODO: Make request to fetch AWS credentials here and assign 'em to the shared instance
		self.accessKey = ""
		self.secretKey = ""
		self.s3Bucket = ""
	}
}
