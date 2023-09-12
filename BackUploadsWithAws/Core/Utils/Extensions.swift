//
//  Extensions.swift
//  BackUploadsWithAws
//
//  Created by ezen on 12/09/2023.
//

import Foundation

extension Double {
	
	func toPercentage() -> Double {
		let divisor = pow(10.0, Double(2))
		return (self * divisor).rounded() / divisor
	}
}
