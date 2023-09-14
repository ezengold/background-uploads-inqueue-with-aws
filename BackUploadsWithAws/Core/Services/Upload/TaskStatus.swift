//
//  TaskStatus.swift
//  BackUploadsWithAws
//
//  Created by ezen on 12/09/2023.
//

import Foundation

enum TaskStatus: String, Codable {
	/**
	 When ongoing task is completely finished without any error
	 */
	case success
	
	/**
	 When a task is registered in upload queue to be started
	 */
	case pending
	
	/**
	 When a task is currently running
	 */
	case running
	
	/**
	 When an error occured while processing the task
	 */
	case error
}
