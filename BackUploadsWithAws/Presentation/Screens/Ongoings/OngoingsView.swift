//
//  OngoingsView.swift
//  BackUploadsWithAws
//
//  Created by ezen on 14/09/2023.
//

import SwiftUI
import Combine
import AWSS3

class OngoingsViewController: UIViewController {

	var vm: OngoingsViewModel!
	
	private var subscribers = Set<AnyCancellable>()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Ongoing Uploads"
		
		self.vm = OngoingsViewModel(host: self)
		let hostedView = OngoingsView(vm: self.vm)
		
		let hosting = UIHostingController(rootView: hostedView)
		hosting.view.translatesAutoresizingMaskIntoConstraints = false
		hosting.view.backgroundColor = UIColor.white

		addChild(hosting)
		view.addSubview(hosting.view)
		hosting.didMove(toParent: self)
		
		NSLayoutConstraint.activate([
			NSLayoutConstraint(item: hosting.view!, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: hosting.view!, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: hosting.view!, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: hosting.view!, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0)
		])
		
		UploadService.shared.$ongoingUploads
			.receive(on: DispatchQueue.main)
			.sink { ongoingUploads in
				self.vm.setFiles(withData: ongoingUploads)
			}
			.store(in: &subscribers)
		
		self.hideKeyboardWhenTappedAround()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		UploadService.shared.delegate = self
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		UploadService.shared.delegate = nil
	}
}

// MARK: - Handle upload service delegations methods
extension OngoingsViewController: UploadTaskDelegate {

	func onStart(currentFile file: UploadFile) {
		DispatchQueue.main.async {
			if let indexInContents = self.vm.data.firstIndex(where: { $0.file == file }) {
				self.vm.data[indexInContents].file = file
			}
		}
	}
	
	func onProgressing(currentFile file: UploadFile, progressionInPercentage progress: Double, uploadTask task: AWSS3TransferUtilityTask) {
		DispatchQueue.main.async {
			if let indexInContents = self.vm.data.firstIndex(where: { $0.file == file }) {
				self.vm.data[indexInContents].file = file
			}
		}
	}
	
	func onCompleted(finalFile file: UploadFile, uploadTask task: AWSS3TransferUtilityTask, canContinue onContinue: @escaping ((Bool) -> Void)) {
		onContinue(true)
	}
	
	func onError(currentFile file: UploadFile, errorEncountered error: Error?, uploadTask task: AWSS3TransferUtilityTask?) {
		DispatchQueue.main.async {
			if let indexInContents = self.vm.data.firstIndex(where: { $0.file == file }) {
				self.vm.data[indexInContents].file = file
			}
		}
	}
}


struct OngoingsView: View {

	@StateObject var vm: OngoingsViewModel
	
    var body: some View {
		if vm.data.isEmpty {
			Text("No ongoing upload")
				.font(.appRegularFont(ofSize: 16))
				.foregroundColor(.black)
		} else {
			ScrollView {
				LazyVStack(spacing: 15) {
					ForEach($vm.data, id: \.id) { fl in
						if !fl.wrappedValue.isUploaded {
							ChatFileLoadingPreview(
								file: fl,
								onRefresh: vm.handleRefreshFile,
								onDelete: vm.handleDeleteFile
							)
						}
					}
				}
				.padding(.horizontal, 15)
				.padding(.top, 20)
				.padding(.bottom, 100)
			}
		}
    }
}

#Preview {
	OngoingsView(vm: OngoingsViewModel(host: UIViewController()))
}
