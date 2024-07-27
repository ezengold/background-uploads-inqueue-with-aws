//
//  ChatsView.swift
//  BackUploadsWithAws
//
//  Created by ezen on 13/09/2023.
//

import SwiftUI
import Combine

class ChatsViewController: UIViewController {
	
	private var statusChip = UIView(frame: CGRect(x: 27, y: 5, width: 5, height: 5))
	
	var vm: ChatsViewModel!
	
	private var subscribers = Set<AnyCancellable>()

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
		
		self.vm.fetchAllData()
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(handleRefresh),
			name: .refreshChats,
			object: nil
		)
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
		
		statusChip.layer.backgroundColor = UIColor.orange.cgColor
		statusChip.layer.cornerRadius = statusChip.bounds.size.height / 2
		statusChip.layer.masksToBounds = true
		uploadsIcon.addSubview(statusChip)
		
		UploadService.shared.$hasNoOngoingUploads
			.receive(on: DispatchQueue.main)
			.assign(to: \.isHidden, on: statusChip)
			.store(in: &subscribers)
		
		let searchItem = UIBarButtonItem(
			image: UIImage(systemName: "magnifyingglass"),
			style: .plain,
			target: self,
			action: nil
		)
		searchItem.tintColor = UIColor.black
		
		self.navigationItem.rightBarButtonItems = [
			UIBarButtonItem(customView: uploadsIcon),
			searchItem
		]
	}
	
	@objc
	func handleRefresh() {

		self.vm.fetchAllData()
	}
	
	@objc
	func onViewUploads() {

		self.showOngoingUploads()
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
						Text(item.contents.isEmpty ? "No asset yet" : "\(item.contents.count) assets", comment: "Number of assets/files inside a chat")
							.font(.appRegularFont(ofSize: 15))
							.foregroundColor(.black)
							.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
						if let lastUpdate = item.getLastestChangeDate() {
							Text("Last update : \(lastUpdate.toString())")
								.font(.appRegularFont(ofSize: 13))
								.foregroundColor(.appDarkGray)
								.frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
						} else {
							Text("No change occured in a while")
								.font(.appRegularFont(ofSize: 13))
								.foregroundColor(.appDarkGray)
								.frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
						}
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
		}
	}
}

#Preview {
	ChatsView(vm: ChatsViewModel(host: UIViewController()))
}
