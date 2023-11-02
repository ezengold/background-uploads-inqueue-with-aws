//
//  UploadTaskDelegate.swift
//  BackUploadsWithAws
//
//  Created by ezen on 12/09/2023.
//

import Foundation
import AWSS3

protocol UploadTaskDelegate {
	
	/**
	 Triggered on delegate when an upload starts
	 */
	func onStart(currentFile file: UploadFile)
	
	/**
	 Triggered on delegate while an upload is running, giving the percentage of progression
	 */
	func onProgressing(currentFile file: UploadFile, progressionInPercentage progress: Double, uploadTask task: AWSS3TransferUtilityTask)
	
	/**
	 Triggered on delegate when an upload is successfully completed
	 */
	func onCompleted(finalFile file: UploadFile, uploadTask task: AWSS3TransferUtilityTask, canContinue onContinue: @escaping ((Bool) -> Void))
	
	/**
	 Triggered on delegate when an error occured during upload
	 */
	func onError(currentFile file: UploadFile, errorEncountered error: Error?, uploadTask task: AWSS3TransferUtilityTask?)
}
