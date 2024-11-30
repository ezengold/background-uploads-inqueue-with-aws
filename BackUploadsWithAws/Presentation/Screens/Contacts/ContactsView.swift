//
//  ContactsView.swift
//  BackUploadsWithAws
//
//  Created by ezen on 30/11/2024.
//

import SwiftUI

class ContactsViewController: UIViewController {

	var vm: ContactsViewModel!

	override func viewDidLoad() {

		super.viewDidLoad()
		
		self.setupNavBar()
		
		self.vm = ContactsViewModel(host: self)
		
		let hostedView = ContactsView(vm: self.vm)
		
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
	}
	
	private func setupNavBar() {
		self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.appBoldFont(ofSize: 17)]
		self.navigationItem.backButtonTitle = ""
		self.navigationItem.backBarButtonItem?.tintColor = .appPrincipal
		
		let searchItem = UIBarButtonItem(
			image: UIImage(systemName: "magnifyingglass"),
			style: .plain,
			target: self,
			action: nil
		)
		searchItem.tintColor = UIColor.black
		
		self.navigationItem.rightBarButtonItems = [
			searchItem
		]
	}
}

struct ContactsView: View {
	
	@StateObject var vm: ContactsViewModel
	
	var body: some View {
		VStack(spacing: 0) {
			ScrollView {
				LazyVStack(spacing: 15) {
					ForEach(Array(vm.data.enumerated()), id: \.0) { _, item in
						ZStack(alignment: .topTrailing) {
							VStack(alignment: .leading, spacing: 10) {
								Text("\(item.givenName) \(item.familyName)")
									.font(.appBoldFont(ofSize: 17))
									.foregroundColor(.appPrincipal)
								Text(item.phoneNumbers.map({ $0.value.stringValue }).joined(separator: ", "))
									.font(.appRegularFont(ofSize: 15))
									.foregroundColor(.black)
									.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
							}
							.padding(10)
							.background(Color.white)
							.cornerRadius(7)
							.clipped()
							.shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 1)
							if !vm.isValid(item) {
								Image(systemName: "xmark.octagon.fill")
									.resizable()
									.scaledToFit()
									.foregroundColor(.red)
									.frame(width: 20, height: 20)
									.offset(CGSize(width: -10, height: 10))
							}
						}
					}
				}
				.padding(.horizontal, 15)
				.padding(.top, 20)
				.padding(.bottom, 100)
			}
			HStack(spacing: 10) {
				Button {
					vm.fixNumbers()
				} label: {
					if vm.isLoading {
						ProgressView()
							.progressViewStyle(CircularProgressViewStyle(tint: .white))
					} else {
						Text("FIX NUMBERS")
							.font(.appBoldFont(ofSize: 17))
					}
				}
				.frame(maxWidth: .infinity)
				.frame(height: 50, alignment: .center)
				.foregroundColor(Color.white)
				.background(
					RoundedRectangle(cornerRadius: 5)
						.fill(Color.appPrincipal.opacity(vm.isLoading ? 0.5 : 1))
				)
			}
			.padding(10)
		}
	}
}

#Preview {
	ContactsView(vm: ContactsViewModel(host: UIViewController()))
}
