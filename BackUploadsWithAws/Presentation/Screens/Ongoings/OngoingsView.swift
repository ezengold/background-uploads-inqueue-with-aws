//
//  OngoingsView.swift
//  BackUploadsWithAws
//
//  Created by ezen on 14/09/2023.
//

import SwiftUI

class OngoingsViewController: UIViewController {

	var vm: OngoingsViewModel!
	
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
		
		self.hideKeyboardWhenTappedAround()
	}
}

struct OngoingsView: View {

	@StateObject var vm: OngoingsViewModel
	
    var body: some View {
        Text("No data")
    }
}

struct OngoingsView_Previews: PreviewProvider {

    static var previews: some View {
        OngoingsView(vm: OngoingsViewModel(host: UIViewController()))
    }
}
