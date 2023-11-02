//
//  OngoingsViewModel.swift
//  BackUploadsWithAws
//
//  Created by ezen on 14/09/2023.
//

import Foundation
import UIKit
import SwiftUI

class OngoingsViewModel: ObservableObject {

	var host: OngoingsViewController
	
	@Published var data: [ChatFile] = []
	
	// MARK: Use cases
	var deleteFileUseCase = DeleteAnUploadFileUseCase(api: ChatFolderApi.shared)
	
	init(host: UIViewController) {

		guard host is OngoingsViewController else {
			self.host = OngoingsViewController()
			return
		}
		self.host = host as! OngoingsViewController
	}
	
	func setFiles(withData ongoingUploads: [UploadFile]) {
		let allFiles = ChatFolderApi.ALL_DATA.flatMap({ $0.contents })
		
		var temp = [ChatFile]()

		for fl in ongoingUploads {
			if let index = allFiles.firstIndex(where: { $0.file == fl }) {
				var file = allFiles[index]
				file.file = fl
				temp.append(file)
			}
		}
		
		self.data = temp
	}
	
	func handleRefreshFile(_ file: ChatFile) {
		
		UploadService.shared.uploadThisFile(file.file.id)
	}
	
	func handleDeleteFile(_ file: ChatFile) {
		
		self.host.alert(
			message: "Do you really want to delete this file ?",
			buttons: [
				.init(title: "No", style: .cancel),
				.init(title: "Yes", style: .destructive, action: { _ in
					
					do {
						try self.deleteFileUseCase.execute(forFileId: file.file.id)
						UploadService.shared.removeFromQueue(file.file.id)
						NotificationCenter.default.post(name: .refreshChats, object: nil)
					} catch {
						self.host.toast(error.localizedDescription)
					}
				})
			]
		)
	}
}
