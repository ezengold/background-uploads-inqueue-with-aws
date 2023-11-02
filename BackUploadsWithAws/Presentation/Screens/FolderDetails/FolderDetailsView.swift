//
//  FolderDetailsView.swift
//  BackUploadsWithAws
//
//  Created by ezen on 14/09/2023.
//

import SwiftUI

struct FolderDetailsView: View {
	
	@StateObject var vm: FolderDetailsViewModel
	
	var body: some View {
		if vm.isLoading {
			ProgressView()
		} else {
			if vm.folder.contents.isEmpty {
				Text("No file in this folder")
					.font(.appRegularFont(ofSize: 16))
					.foregroundColor(.black)
			} else {
				ScrollView {
					LazyVStack(spacing: 15) {
						ForEach($vm.folder.contents, id: \.id) { fl in
							if fl.wrappedValue.isUploaded {
								ChatFilePreview(
									file: fl,
									onDelete: vm.handleDeleteFile
								)
							} else {
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
}

#Preview {
	FolderDetailsView(vm: FolderDetailsViewModel(host: UIViewController(), withFolder: .DUMMY_FOLDER))
}
