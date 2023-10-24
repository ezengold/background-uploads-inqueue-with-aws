//
//  ChatFile.swift
//  BackUploadsWithAws
//
//  Created by ezen on 13/09/2023.
//

import Foundation
import UIKit

struct ChatFile: Codable, Identifiable, Equatable {

	var id: String
	var file: UploadFile
	var addedAt: Date
	var isUploaded: Bool = false
	var thumbData: Data? = nil

	static let DUMMY_IMAGE_FILE = ChatFile(
		id: "1",
		file: UploadFile(
			id: UUID().uuidString,
			s3UploadKey: "dummy.jpeg",
			fileUrl: Resources.dummyImage,
			contentType: .image
		),
		addedAt: Date()
	)
	
	static let DUMMY_VIDEO_FILE = ChatFile(
		id: "2",
		file: UploadFile(
			id: UUID().uuidString,
			s3UploadKey: "dummy.mp4",
			fileUrl: Resources.dummyVideo,
			contentType: .video
		),
		addedAt: Date(),
		thumbData: UIImage(named: "reiner")?.jpegData(compressionQuality: 1.0)
	)
	
	static let DUMMY_DOC_FILE = ChatFile(
		id: "3",
		file: UploadFile(
			id: UUID().uuidString,
			s3UploadKey: "dummy.pdf",
			fileUrl: Resources.dummyDocument,
			contentType: .file
		),
		addedAt: Date()
	)
	
	static func == (lhs: ChatFile, rhs: ChatFile) -> Bool {
		lhs.id == rhs.id
	}
}
