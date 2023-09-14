//
//  ChatFolderApi.swift
//  BackUploadsWithAws
//
//  Created by ezen on 14/09/2023.
//

import Foundation

struct ChatFolderApi {
	static let shared = ChatFolderApi()
	
	func getAllFolders() async throws -> [ChatFolder] {
		guard let url = Bundle.main.url(forResource: "folders", withExtension: "json") else {
			throw ApiError("Resource not found", error: NSError(domain: "Unable to resolve [folders.json]", code: 404))
		}
		
		guard let jsonData = try? Data(contentsOf: url) else {
			throw ApiError("Request error occured", error: NSError(domain: "Unable to fetch content of [folders.json]", code: 400))
		}
		
		do {
			let foldersList = try JSONDecoder().decode([ChatFolder].self, from: jsonData)
			
			return foldersList
		} catch {
			throw ApiError(error.localizedDescription, error: error)
		}
	}
	
	func getFoldersFiltered(with keywords: String) async throws -> [ChatFolder] {
		
		do {
			let allFolders = try await getAllFolders()
			
			let predicate = NSPredicate(format: "SELF contains[c] %@", keywords)

			if keywords.isEmpty {
				return allFolders
			} else {
				return allFolders.filter { predicate.evaluate(with: ($0.folderName).uppercased()) }
			}
		} catch {
			throw error
		}
	}
	
	func getFolder(ofId: String) async throws -> ChatFolder? {
		return nil
	}
}
