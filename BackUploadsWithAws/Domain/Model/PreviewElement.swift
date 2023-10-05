//
//  PreviewElement.swift
//  BackUploadsWithAws
//
//  Created by ezen on 19/09/2023.
//

import Foundation
import YPImagePicker

struct PreviewElement: Identifiable, Equatable {
	
	let id: String = UUID().uuidString
	var type: FileType
	var imageData: YPMediaPhoto?
	var videoData: YPMediaVideo?
	var fileData: URL?
	
	static func == (lhs: PreviewElement, rhs: PreviewElement) -> Bool {
		lhs.id == rhs.id
	}
}
