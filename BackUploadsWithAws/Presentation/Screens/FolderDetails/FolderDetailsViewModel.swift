//
//  FolderDetailsViewModel.swift
//  BackUploadsWithAws
//
//  Created by ezen on 14/09/2023.
//

import Foundation
import UIKit

class FolderDetailsViewModel: ObservableObject {

	var host: FolderDetailsViewController
	
	@Published var folder: ChatFolder
	
	// MARK: Use cases
	var updateFolderUseCase = UpdateFolderContentsUseCase(api: ChatFolderApi.shared)
	
	init(host: UIViewController, withFolder: ChatFolder) {

		self.folder = withFolder

		guard host is FolderDetailsViewController else {
			self.host = FolderDetailsViewController()
			return
		}

		self.host = host as! FolderDetailsViewController
	}
	
	func startUploads(ofItems items: [PreviewElement]) {
		
		var updatedFolderContents = self.folder.contents

		var filesToUpload = [UploadFile]()
		
		for item in items {
			
			var uploadFile: UploadFile
			
			switch item.type {
				
			case .image:
				let finalFileName = "\(item.id).jpeg"
				
				// It's important to fetch a permanent Url because the document directory can change at any time.
				// So we should access the file relatively
				
				if let image = item.imageData?.image, let fileUrl = UploadService.getPermanentUrl(image, usingName: finalFileName) {
					uploadFile = UploadFile(
						id: item.id,
						s3UploadKey: finalFileName,
						fileUrl: fileUrl,
						contentType: .image,
						expiresAt: Calendar.current.date(byAdding: .day, value: 1, to: Date())
					)
				} else {
					// Will never be called, but user should see the file in queue with error mentionned on it, in case this happen
					uploadFile = UploadFile(
						id: item.id,
						s3UploadKey: finalFileName,
						fileUrl: item.imageData?.url,
						contentType: .image,
						expiresAt: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
						status: .error,
						error: "Invalid image"
					)
				}

			case .video:
				let sourceUrl = item.videoData!.url
				let finalFileName = "\(item.id).\(sourceUrl.pathExtension)"
				if let fileUrl = UploadService.getPermanentUrl(sourceUrl, usingName: finalFileName) {
					uploadFile = UploadFile(
						id: item.id,
						s3UploadKey: finalFileName,
						fileUrl: fileUrl,
						contentType: .video,
						expiresAt: Calendar.current.date(byAdding: .day, value: 1, to: Date())
					)
				} else {
					uploadFile = UploadFile(
						id: item.id,
						s3UploadKey: finalFileName,
						fileUrl: item.videoData?.url,
						contentType: .video,
						expiresAt: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
						status: .error,
						error: "Invalid video"
					)
				}

			case .file:
				let sourceUrl = item.fileData!
				let finalFileName = "\(item.id).\(sourceUrl.pathExtension)"
				if let fileUrl = UploadService.getPermanentUrl(sourceUrl, usingName: finalFileName) {
					uploadFile = UploadFile(
						id: item.id,
						s3UploadKey: finalFileName,
						fileUrl: fileUrl,
						contentType: .file,
						expiresAt: Calendar.current.date(byAdding: .day, value: 1, to: Date())
					)
				} else {
					uploadFile = UploadFile(
						id: item.id,
						s3UploadKey: finalFileName,
						fileUrl: item.fileData,
						contentType: .file,
						expiresAt: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
						status: .error,
						error: "Invalid file"
					)
				}
			}
			
			filesToUpload.append(uploadFile)

			updatedFolderContents.append(ChatFile(
				id: item.id,
				file: uploadFile,
				addedAt: Date(),
				thumbData: item.type == .video ? (item.videoData?.thumbnail.jpegData(compressionQuality: 1.0)) : nil
			))
		}
		
		UploadService.shared.addMultipleUploadOperations(filesToUpload)
		self.folder.contents = updatedFolderContents
		
		self.updateFolder()
	}
	
	func updateFolder() {
		Task(priority: .high) {
			do {
				try await updateFolderUseCase.execute(forFolder: self.folder)
			} catch {
				await self.host.toast(error.localizedDescription)
			}
		}
	}
}
