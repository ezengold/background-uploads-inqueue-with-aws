//
//  ChatsView.swift
//  BackUploadsWithAws
//
//  Created by ezen on 13/09/2023.
//

import SwiftUI

class ChatsViewController: UIViewController {
	
	private var searchController = UISearchController(searchResultsController: nil)
	
	private var statusChip = UIView(frame: CGRect(x: 27, y: 5, width: 5, height: 5))
	
	var vm: ChatsViewModel!

	override func viewDidLoad() {

		super.viewDidLoad()
		
		self.setupNavBar()
		
		self.vm = ChatsViewModel(host: self)
		let hostedView = ChatsView(vm: self.vm)
		
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
	
	private func setupNavBar() {

		self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.appBoldFont(ofSize: 17)]
		self.navigationItem.backButtonTitle = ""
		self.navigationItem.backBarButtonItem?.tintColor = .appPrincipal
		
		let uploadsIcon = UIButton(type: .custom)
		uploadsIcon.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
		uploadsIcon.setImage(UIImage(named: "upload-icon"), for: .normal)
		uploadsIcon.tintColor = .appPrincipal
		uploadsIcon.addTarget(self, action: #selector(onViewUploads), for: .touchUpInside)
		
		statusChip.layer.backgroundColor = UIColor.orange.cgColor // TODO: Use clear color when no upload
		statusChip.layer.cornerRadius = statusChip.bounds.size.height / 2
		statusChip.layer.masksToBounds = true
		uploadsIcon.addSubview(statusChip)
		
		let searchItem = UIBarButtonItem(
			image: UIImage(systemName: "magnifyingglass"),
			style: .plain,
			target: self,
			action: #selector(self.onSearch)
		)
		searchItem.tintColor = UIColor.black
		
		self.navigationItem.rightBarButtonItems = [
			UIBarButtonItem(customView: uploadsIcon),
			searchItem
		]
		
		// Search bar
		searchController = UISearchController(searchResultsController: nil)
		
		searchController.searchBar.searchBarStyle = .minimal
		searchController.searchBar.tintColor = .black
		searchController.searchBar.barStyle = .default
		searchController.definesPresentationContext = true
		
		let searchBarTextField = searchController.searchBar.value(forKey: "searchBarTextField") as! UITextField
		let imageView = UIImageView(frame: CGRect(x: 25, y: 25, width: 25, height: 25))
		imageView.image = UIImage(systemName: "magnifyingglass")!
		searchBarTextField.leftView = imageView
		searchBarTextField.leftView?.tintColor = UIColor.black
		
		searchBarTextField.font = .appRegularFont(ofSize: 13)
		searchBarTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [
			.font: UIFont.appRegularFont(ofSize: 13),
			.foregroundColor: UIColor.black
		])
		
		self.navigationItem.searchController = searchController
		searchController.searchBar.delegate = self
	}
	
	@objc
	func onViewUploads() {

		self.showOngoingUploads()
	}
	
	@objc
	func onSearch() {

		self.searchController.searchBar.becomeFirstResponder()
	}
}

extension ChatsViewController: UISearchBarDelegate {

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

		searchBar.resignFirstResponder()
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

		self.vm.keywords = searchText
	}
}

struct ChatsView: View {

	@StateObject var vm: ChatsViewModel
	
	var body: some View {
		ScrollView {
			LazyVStack(spacing: 15) {
				ForEach(vm.data, id: \.id) { item in
					VStack(alignment: .leading, spacing: 10) {
						Text(item.folderName)
							.font(.appBoldFont(ofSize: 17))
							.foregroundColor(.appPrincipal)
						Text("No asset yet")
							.font(.appRegularFont(ofSize: 15))
							.foregroundColor(.black)
							.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
						Text("Last update : 2023-09-11 at 7 am")
							.font(.appRegularFont(ofSize: 13))
							.foregroundColor(.appDarkGray)
							.frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
					}
					.padding(10)
					.background(Color.white)
					.cornerRadius(7)
					.clipped()
					.shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 1)
					.onTapGesture {
						vm.viewDetails(of: item)
					}
				}
			}
			.padding(.horizontal, 15)
			.padding(.top, 20)
			.padding(.bottom, 100)
			.onAppear {
				vm.fetchAllData()
			}
		}
	}
}

struct ChatsView_Previews: PreviewProvider {

    static var previews: some View {
        ChatsView(vm: ChatsViewModel(host: UIViewController()))
    }
}