//
//  ChatsView.swift
//  BackUploadsWithAws
//
//  Created by ezen on 13/09/2023.
//

import SwiftUI

class ChatsViewController: UIViewController {
	var vm: ChatsViewModel!

	override func viewDidLoad() {
		super.viewDidLoad()
		
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
}

struct ChatsView: View {
	@StateObject var vm: ChatsViewModel
	
	var body: some View {
		VStack(alignment: .center, spacing: 15) {
			HStack(alignment: .center, spacing: 10) {
				VStack {
					TextField("Search", text: $vm.keywords)
						.font(.appSemiBoldFont(ofSize: 17))
						.foregroundColor(.black)
						.frame(maxWidth: .infinity, alignment: .leading)
						.frame(height: 45)
						.padding(.horizontal, 12)
						.accentColor(.appPrincipal)
				}
				.background(Color.white)
				.cornerRadius(5)
				.clipped()
				.shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 0)
				Image("upload-icon")
					.resizable()
					.foregroundColor(.appPrincipal)
					.scaledToFit()
					.frame(width: 25, height: 25)
			}
			.padding(15)
			Spacer()
		}
	}
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView(vm: ChatsViewModel(host: UIViewController()))
    }
}
