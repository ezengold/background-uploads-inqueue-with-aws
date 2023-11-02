//
//  AssetsPreviewViewModel.swift
//  BackUploadsWithAws
//
//  Created by ezen on 18/09/2023.
//

import Foundation
import UIKit
import YPImagePicker

class AssetsPreviewViewModel: ObservableObject {
	
	var host: AssetsPreviewViewController
	
	@Published var isFilePreview: Bool = false
	
	@Published var items = [PreviewElement]()

	@Published var currentItem: PreviewElement?
	
	init(host: UIViewController, withItems previewItems: [(FileType, Any)]) {

		guard host is AssetsPreviewViewController else {
			self.host = AssetsPreviewViewController()
			return
		}

		self.host = host as! AssetsPreviewViewController
		
		self.items = self.formatItems(using: previewItems)
		self.currentItem = self.items[0]
		self.isFilePreview = self.items[0].type == .file
	}
	
	private func formatItems(using itemsToUse: [(FileType, Any)]) -> [PreviewElement] {
		
		return itemsToUse.map({ (itemType, itemData) in
			
			switch itemType {
			case .image:
				guard let data = itemData as? YPMediaItem else {
					return PreviewElement(type: .image, imageData: nil)
				}
				switch data {
				case .photo(let photoData):
					return PreviewElement(type: .image, imageData: photoData)
				default:
					return PreviewElement(type: .image, imageData: nil)
				}

			case .video:
				guard let data = itemData as? YPMediaItem else {
					return PreviewElement(type: .video, videoData: nil)
				}
				switch data {
				case .video(let videoData):
					return PreviewElement(type: .video, videoData: videoData)
				default:
					return PreviewElement(type: .video, videoData: nil)
				}

			case .file:
				guard let data = itemData as? URL else {
					return PreviewElement(type: .file, fileData: nil)
				}
				return PreviewElement(type: .file, fileData: data)
			}
		})
	}
	
	func viewFully(item: PreviewElement) {
		self.currentItem = item
	}
	
	func handleSubmit() {
		self.host.onFinish?(self.items)
		self.host.dismiss(animated: true)
	}
}
