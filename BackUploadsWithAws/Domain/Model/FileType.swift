//
//  FileType.swift
//  BackUploadsWithAws
//
//  Created by ezen on 13/09/2023.
//

import Foundation
import UIKit

enum FileType: String, Codable {
	case image, video, file
	
	var icon: UIImage {
		switch self {
		case .image:
			return UIImage(named: "image-icon")!
		case .video:
			return UIImage(named: "video-icon")!
		case .file:
			return UIImage(named: "file-icon")!
		}
	}
	
	func contentTypeOf(fileWithExtension ext: String) -> String {
		switch self {
		case .image:
			return "image/\(ext)"
		case .video:
			return "video/\(ext)"
		case .file:
			return "binary/octet-stream"
		}
	}
}
