//
//  S3Keys.swift
//  BackUploadsWithAws
//
//  Created by ezen on 12/09/2023.
//

import Foundation
import AWSCore

/**
 Hold AWS keys
 Never use static values. Always fetch the keys at runtime. Maybe when app lauches in AppDelegate
 */
class S3Keys {
	static let shared = S3Keys()
	
	var accessKey: String = ""
	
	var secretKey: String = ""
	
	var s3Bucket: String = ""
	
	func fetchKeysAndInitialize() {
		// TODO: Make request to fetch AWS credentials here and assign 'em to the shared instance
		self.accessKey = ""
		self.secretKey = ""
		self.s3Bucket = ""
		
		let provider = AWSStaticCredentialsProvider(accessKey: self.accessKey, secretKey: self.secretKey)
		let configs = AWSServiceConfiguration(region: .EUWest3, credentialsProvider: provider)
		
		AWSServiceManager.default().defaultServiceConfiguration = configs
	}
}
