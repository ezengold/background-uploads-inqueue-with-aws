//
//  ChatFolderApi.swift
//  BackUploadsWithAws
//
//  Created by ezen on 14/09/2023.
//

import Foundation

struct ChatFolderApi {

	static let shared = ChatFolderApi()
	
	static var ALL_DATA = [ChatFolder]()
	
	// MARK: - Public methods

	func getAllFolders() async throws -> [ChatFolder] {
		
		if UserDefaults.standard.bool(forKey: Constants.FOLDERS_HAS_BEEN_SAVED_ONCE) {
			ChatFolderApi.ALL_DATA = try self.loadFromStorage()
		} else {
			ChatFolderApi.ALL_DATA = try self.loadFromSourceFile()
		}

		return ChatFolderApi.ALL_DATA
	}
	
	func getFoldersFiltered(with keywords: String) -> [ChatFolder] {
		
		let allFolders = ChatFolderApi.ALL_DATA
		
		let predicate = NSPredicate(format: "SELF contains[c] %@", keywords)
		
		if keywords.isEmpty {
			return allFolders
		} else {
			return allFolders.filter { predicate.evaluate(with: ($0.folderName).uppercased()) }
		}
	}
	
	func getFolder(ofId folderId: String) async throws -> ChatFolder? {
		
		let _ = try await self.getAllFolders()
		
		return ChatFolderApi.ALL_DATA.first(where: { $0.id == folderId })
	}
	
	func updateFolder(ofId folderId: String, with data: ChatFolder) async throws {
		
		guard let folderIndex = ChatFolderApi.ALL_DATA.firstIndex(where: { $0.id == folderId }) else {
			throw ApiError("Folder not found", error: NSError(domain: "Unable to resolve folder of id : [\(folderId)]", code: 404))
		}
		
		ChatFolderApi.ALL_DATA[folderIndex] = data

		try saveToStorage()
	}
	
	// MARK: - Private methods

	private func saveToStorage() throws {
		UserDefaults.standard.setValue(Helpers.stringify(json: ChatFolderApi.ALL_DATA), forKey: Constants.FOLDERS_SAVED)
	}
	
	private func loadFromStorage() throws -> [ChatFolder] {

		guard let foldersData = UserDefaults.standard.string(forKey: Constants.FOLDERS_SAVED) else {
			throw ApiError("Request error occured", error: NSError(domain: "Unable to fetch content of local storage", code: 400))
		}
		
		guard let foldersList = Helpers.parse(str: foldersData, to: [ChatFolder].self) else {
			return []
		}

		return foldersList
	}
	
	private func loadFromSourceFile() throws -> [ChatFolder] {

		guard let url = Bundle.main.url(forResource: "folders", withExtension: "json") else {
			throw ApiError("Resource not found", error: NSError(domain: "Unable to resolve [folders.json]", code: 404))
		}
		
		guard let jsonData = try? Data(contentsOf: url) else {
			throw ApiError("Request error occured", error: NSError(domain: "Unable to fetch content of [folders.json]", code: 400))
		}
		
		do {
			let foldersList = try JSONDecoder().decode([ChatFolder].self, from: jsonData)
			
			UserDefaults.standard.setValue(String(data: jsonData, encoding: .utf8), forKey: Constants.FOLDERS_SAVED)
			UserDefaults.standard.setValue(true, forKey: Constants.FOLDERS_HAS_BEEN_SAVED_ONCE)
			
			return foldersList
		} catch {
			throw ApiError(error.localizedDescription, error: error)
		}
	}
}
