//
//  FetchAllFolders.swift
//  BackUploadsWithAws
//
//  Created by ezen on 15/09/2023.
//

import Foundation

protocol FetchAllFolders {
	func execute() async -> Result<[ChatFolder], ApiError>
}

struct FetchAllFoldersUseCase: FetchAllFolders {
	
	var api: ChatFolderApi
	
	func execute() async -> Result<[ChatFolder], ApiError> {

		do {
			let results = try await api.getAllFolders()
			return .success(results)
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
