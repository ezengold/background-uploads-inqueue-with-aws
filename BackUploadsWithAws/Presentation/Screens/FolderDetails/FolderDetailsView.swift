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
		if vm.folder.contents.isEmpty {
			Text("No file in this folder")
				.font(.appRegularFont(ofSize: 16))
				.foregroundColor(.black)
		} else {
			ScrollView {
				LazyVStack(spacing: 15) {
					ForEach(vm.folder.contents, id: \.id) { fl in
						ChatFilePreview(file: .constant(fl))
					}
				}
				.padding(.horizontal, 15)
				.padding(.top, 20)
				.padding(.bottom, 100)
			}
		}
	}
}

struct FolderDetailsView_Previews: PreviewProvider {

    static var previews: some View {
		FolderDetailsView(vm: FolderDetailsViewModel(host: UIViewController(), withFolder: .DUMMY_FOLDER))
    }
}
