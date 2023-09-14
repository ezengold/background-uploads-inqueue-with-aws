//
//  Helpers.swift
//  BackUploadsWithAws
//
//  Created by ezen on 14/09/2023.
//

import Foundation

struct Helpers {

	static func stringify(json: Encodable, pretty: Bool = true) -> String {
		
		do {
			let encoder = JSONEncoder()
			if pretty {
				encoder.outputFormatting = .prettyPrinted
			}
			let jsonData = try JSONEncoder().encode(json)
			return String(data: jsonData, encoding: .utf8) ?? ""
		} catch {
			return ""
		}
	}
	
	static func parse<T: Decodable>(str: String, to: T.Type = T.self) -> T? {
		
		do {
			if let data = str.data(using: .utf8, allowLossyConversion: false) {
				let decodedData = try JSONDecoder().decode(to, from: data)
				return decodedData
			} else {
				return nil
			}
		} catch {
			return nil
		}
	}
}
