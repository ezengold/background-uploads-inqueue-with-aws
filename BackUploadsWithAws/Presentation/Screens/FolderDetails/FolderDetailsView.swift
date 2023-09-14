//
//  FolderDetailsView.swift
//  BackUploadsWithAws
//
//  Created by ezen on 14/09/2023.
//

import SwiftUI

class FolderDetailsViewController: UIViewController {
	
	private var searchController = UISearchController(searchResultsController: nil)
	
	var vm: FolderDetailsViewModel!
	
	var folder: ChatFolder!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = folder.folderName
		
		self.vm = FolderDetailsViewModel(host: self)
		let hostedView = FolderDetailsView(vm: self.vm)
		
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
		
		self.hideKeyboardWhenTappedAround()
	}
}

struct FolderDetailsView: View {

	@StateObject var vm: FolderDetailsViewModel
	
    var body: some View {
        Text("Nothing here for the moment")
			.font(.appRegularFont(ofSize: 15))
    }
}

struct FolderDetailsView_Previews: PreviewProvider {

    static var previews: some View {
        FolderDetailsView(vm: FolderDetailsViewModel(host: UIViewController()))
    }
}
