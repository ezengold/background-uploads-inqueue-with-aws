//
//  FetchContacts.swift
//  BackUploadsWithAws
//
//  Created by ezen on 30/11/2024.
//

import Foundation
import Contacts

protocol FetchContacts {
	
	func execute() async -> [CNContact]
}

struct FetchContactsUseCase: FetchContacts {
	
	var store: CNContactStore
	
	func execute() async -> [CNContact] {
		guard await self.isPermissionGranted() else { return [] }
		
		do {
			var contacts = [CNContact]()
			
			let keys = [
				CNContactGivenNameKey,
				CNContactFamilyNameKey,
				CNContactPhoneNumbersKey
			] as [CNKeyDescriptor]
			
			try store.enumerateContacts(with: CNContactFetchRequest(keysToFetch: keys)) { _contact, stop in
				contacts.append(_contact)
			}
			
			return contacts
		} catch {
			return []
		}
	}
	
	private func isPermissionGranted() async -> Bool {
		let status = CNContactStore.authorizationStatus(for: .contacts)
		
		switch status {
		case .notDetermined:
			return await self.requestPermission()
		case .restricted:
			return false
		case .denied:
			return false
		case .authorized:
			return true
		case .limited:
			return true
		default:
			return false
		}
	}
	
	func requestPermission() async -> Bool {
		do {
			let _response = try await store.requestAccess(for: .contacts)
			return _response
		} catch {
			return false
		}
	}
}
