//
//  UploadTaskDelegate.swift
//  BackUploadsWithAws
//
//  Created by ezen on 12/09/2023.
//

import Foundation
import AWSS3

protocol UploadTaskDelegate {
	func onStart(currentFile file: UploadFile)
	func onProgressing(currentFile file: UploadFile, progressionInPercentage progress: Double, uploadTask task: AWSS3TransferUtilityTask)
	func onCompleted(finalFile file: UploadFile, uploadTask task: AWSS3TransferUtilityTask, canContinue onContinue: @escaping ((Bool) -> Void))
	func onError(currentFile file: UploadFile, errorEncountered error: Error?, uploadTask task: AWSS3TransferUtilityTask?)
}
