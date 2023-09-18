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
		Text("Nothing here for the moment")
			.font(.appRegularFont(ofSize: 15))
	}
}

struct FolderDetailsView_Previews: PreviewProvider {

    static var previews: some View {
		FolderDetailsView(vm: FolderDetailsViewModel(host: UIViewController(), withFolder: .DUMMY_FOLDER))
    }
}
