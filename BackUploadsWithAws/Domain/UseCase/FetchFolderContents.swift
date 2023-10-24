//
//  FetchFolderContents.swift
//  BackUploadsWithAws
//
//  Created by ezen on 24/10/2023.
//

import Foundation

protocol FetchFolderContents {
	func execute(forId folderId: String) async -> Result<ChatFolder, ApiError>
}

struct FetchFolderContentsUseCase: FetchFolderContents {
	
	var api: ChatFolderApi
	
	func execute(forId folderId: String) async -> Result<ChatFolder, ApiError> {
		
		do {
			if let result = try await api.getFolder(ofId: folderId) {
				return .success(result)
			} else {
				return .failure(ApiError(
					"Unable to resolve folder contents",
					error: NSError(domain: "An error occured when resolving the folder of id : [\(folderId)]", code: 404)
				))
			}
		} catch {
			guard let error = error as? ApiError else {
				return .failure(ApiError(
					error.localizedDescription,
					error: error
				))
			}
			return .failure(error)
		}
	}
}
