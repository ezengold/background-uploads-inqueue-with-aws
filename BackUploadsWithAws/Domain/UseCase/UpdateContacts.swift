//
//  UpdateContacts.swift
//  BackUploadsWithAws
//
//  Created by ezen on 30/11/2024.
//

import Foundation
import Contacts

protocol UpdateContacts {
	
	func execute() async -> Bool
}

struct UpdateContactsUseCase: UpdateContacts {
	
	var store: CNContactStore
	
	func execute() async -> Bool {
		do {
			var contacts = [CNContact]()
			
			let keys = [
				CNContactGivenNameKey,
				CNContactFamilyNameKey,
				CNContactPhoneNumbersKey
			] as [CNKeyDescriptor]
			
			try store.enumerateContacts(with: CNContactFetchRequest(keysToFetch: keys)) { _contact, stop in
				if _contact.givenName.starts(with: "Canisius") {
					contacts.append(_contact)
				}
			}
			
			for contact in contacts {
				let numbers = contact.phoneNumbers.filter({
					$0.value.stringValue.withoutSpaces().hasPrefix("01") ||
					$0.value.stringValue.withoutSpaces().hasPrefix("+22901")
				})
				
				guard numbers.count > 0 else { continue }
				
				let mutableContact = contact.mutableCopy() as! CNMutableContact
				
				for number in numbers {
					let numberString = number.value.stringValue.withoutSpaces()
					
					let actualNumber = numberString[numberString.index(numberString.startIndex, offsetBy: numberString.hasPrefix("+22901") ? 6 : 2)...]
					
					let hasBeenFixedAlready = contact.phoneNumbers.contains(where: { $0.value.stringValue.withoutSpaces() == "+229\(actualNumber)" })
					
					
					if !hasBeenFixedAlready {
						mutableContact.phoneNumbers.append(CNLabeledValue(
							label: CNLabelPhoneNumberMobile,
							value: CNPhoneNumber(stringValue: "+229\(actualNumber)")
						))
					}

					dump((numberString, actualNumber, hasBeenFixedAlready))
					continue
				}

				dump(mutableContact.phoneNumbers)
				
				let saveRequest = CNSaveRequest()
				
				saveRequest.update(mutableContact)
				
				do {
					try store.execute(saveRequest)
					continue
				} catch {
					continue
				}
			}
			
			return true
		} catch {
			return false
		}
	}
}

extension String {
	
	func withoutSpaces() -> String {
		return self.replacingOccurrences(of: " ", with: "")
	}
}
