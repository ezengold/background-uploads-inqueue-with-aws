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
				contacts.append(_contact)
			}
			
			// handle migrations to -> 01[oldnumber]
			for contact in contacts {
				let numbers = contact.phoneNumbers.filter({
					$0.value.stringValue.withoutSpaces().count == 8 ||
					($0.value.stringValue.withoutSpaces().hasPrefix("+229") && $0.value.stringValue.withoutSpaces().count == 12) ||
					($0.value.stringValue.withoutSpaces().hasPrefix("229") && $0.value.stringValue.withoutSpaces().count == 11) ||
					($0.value.stringValue.withoutSpaces().hasPrefix("00229") && $0.value.stringValue.withoutSpaces().count == 13)
				})
				
				guard numbers.count > 0 else { continue }
				
				let mutableContact = contact.mutableCopy() as! CNMutableContact
				
				for number in numbers {
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
					
					let hasBeenFixedAlready = contact.phoneNumbers.contains(where: { $0.value.stringValue.withoutSpaces() == "+22901\(actualNumber)" })
					
					if !hasBeenFixedAlready {
						print("01[number] > \(contact.givenName) \(contact.familyName) | added number: +22901\(actualNumber)")
	
						mutableContact.phoneNumbers.append(CNLabeledValue(
							label: CNLabelPhoneNumberMobile,
							value: CNPhoneNumber(stringValue: "+22901\(actualNumber)")
						))
					}
				}
				
				let saveRequest = CNSaveRequest()
				
				saveRequest.update(mutableContact)
				
				do {
					try store.execute(saveRequest)
					continue
				} catch {
					continue
				}
			}
			
			contacts.removeAll()
			try store.enumerateContacts(with: CNContactFetchRequest(keysToFetch: keys)) { _contact, stop in
				contacts.append(_contact)
			}
			
			// fix migration issues to have both number with and without 01
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
						print("fix[+229] > \(contact.givenName) \(contact.familyName) | added number: +229\(actualNumber)")

						mutableContact.phoneNumbers.append(CNLabeledValue(
							label: CNLabelPhoneNumberMobile,
							value: CNPhoneNumber(stringValue: "+229\(actualNumber)")
						))
					}
				}
				
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
