//
//  ContactsViewModel.swift
//  BackUploadsWithAws
//
//  Created by ezen on 30/11/2024.
//

import Foundation
import UIKit
import Contacts

class ContactsViewModel: ObservableObject {

	var host: ContactsViewController
	
	static let ContactStore = CNContactStore()
	
	// MARK: Use cases
	var fetchContactsUseCase = FetchContactsUseCase(store: ContactStore)
	
	var updateContactsUseCase = UpdateContactsUseCase(store: ContactStore)
	
	@Published var data: [CNContact] = []
	
	@Published var isLoading: Bool = false
	
	init(host: UIViewController) {

		guard host is ContactsViewController else {
			self.host = ContactsViewController()
			return
		}
		self.host = host as! ContactsViewController
	}
	
	func isValid(_ contact: CNContact) -> Bool {
		// case of numbers not already migrated
		let _possiblyNotMigratedNumbers = contact.phoneNumbers.filter({
			$0.value.stringValue.withoutSpaces().count == 8 ||
			($0.value.stringValue.withoutSpaces().hasPrefix("+229") && $0.value.stringValue.withoutSpaces().count == 12) ||
			($0.value.stringValue.withoutSpaces().hasPrefix("229") && $0.value.stringValue.withoutSpaces().count == 11) ||
			($0.value.stringValue.withoutSpaces().hasPrefix("00229") && $0.value.stringValue.withoutSpaces().count == 13)
		})
		
		var isCorrect = true
		
		for number in _possiblyNotMigratedNumbers {
			let numberString = number.value.stringValue.withoutSpaces()
			
			var actualNumber: String = ""
			
			if numberString.count == 8 {
				actualNumber = numberString
			} else if numberString.hasPrefix("+229") && numberString.count == 12 {
				actualNumber = String(numberString[numberString.index(numberString.startIndex, offsetBy: 4)...])
			} else if numberString.hasPrefix("229") && numberString.count == 11 {
				actualNumber = String(numberString[numberString.index(numberString.startIndex, offsetBy: 3)...])
			} else if numberString.hasPrefix("00229") && numberString.count == 13 {
				actualNumber = String(numberString[numberString.index(numberString.startIndex, offsetBy: 5)...])
			}
			
			let isFixed = contact.phoneNumbers.contains(where: { $0.value.stringValue.withoutSpaces() == "+22901\(actualNumber)" })
			
			isCorrect = isCorrect && isFixed
		}
		
		// case of numbers not fixed back by migration
		let _numbers = contact.phoneNumbers.filter({
			$0.value.stringValue.withoutSpaces().starts(with: "+22901") ||
			$0.value.stringValue.withoutSpaces().starts(with: "01")
		})
		
		guard _numbers.count > 0 else { return true }
		
		for number in _numbers {
			let numberString = number.value.stringValue.withoutSpaces()
			
			let actualNumber = numberString[numberString.index(numberString.startIndex, offsetBy: numberString.hasPrefix("+22901") ? 6 : 2)...]
			
			let isFixed = contact.phoneNumbers.contains(where: { $0.value.stringValue.withoutSpaces() == "+229\(actualNumber)" })
			
			isCorrect = isCorrect && isFixed
		}
		
		return isCorrect
	}
	
	func fetchAllData() {
		Task {
			self.data = await fetchContactsUseCase.execute()
		}
	}
	
	func fixNumbers() {
		self.isLoading = true
		Task {
			if await updateContactsUseCase.execute() {
				self.fetchAllData()
				self.isLoading = false
				await self.host.alert(withTitle: "Contacts Sync", message: "Contacts fixed successfully ✅")
			} else {
				self.isLoading = false
				await self.host.alert(withTitle: "Contacts Sync", message: "An error occured while synchronizing contacts ❌")
			}
		}
	}
}
