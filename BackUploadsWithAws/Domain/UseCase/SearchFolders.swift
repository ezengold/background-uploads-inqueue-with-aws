//
//  SearchFolders.swift
//  BackUploadsWithAws
//
//  Created by ezen on 14/09/2023.
//

import Foundation

protocol SearchFolders {
	func execute(with keywords: String) async -> Result<[ChatFolder], ApiError>
}

struct SearchFoldersUseCase: SearchFolders {
	
	var api: ChatFolderApi
	
	func execute(with keywords: String) async -> Result<[ChatFolder], ApiError> {
		do {
			let results = try await api.getFoldersFiltered(with: keywords)
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
