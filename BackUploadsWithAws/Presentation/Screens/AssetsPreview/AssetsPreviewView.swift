//
//  AssetsPreviewView.swift
//  BackUploadsWithAws
//
//  Created by ezen on 18/09/2023.
//

import SwiftUI
import UIKit
import YPImagePicker
import AVKit

class AssetsPreviewViewController: UIViewController {
	
	var vm: AssetsPreviewViewModel!
	
	var pickedItems = [(FileType, Any)]()
	
	var onFinish: (([PreviewElement]) -> Void)?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.vm = AssetsPreviewViewModel(host: self, withItems: self.pickedItems)
		let hostedView = AssetsPreviewView(vm: self.vm)
		
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

struct AssetsPreviewView: View {
	
	@StateObject var vm: AssetsPreviewViewModel
	
	var body: some View {
		VStack(spacing: 15) {
			if vm.isFilePreview {
				FilePreview(files: .constant(vm.items))
					.padding(.horizontal, 15)
					.padding(.top, 15)
			} else {
				if let previewItem = vm.currentItem {
					if previewItem.type == .image {
						if let safeImage = previewItem.imageData?.image {
							ImagePreview(image: .constant(safeImage))
								.padding(.horizontal, 15)
								.padding(.top, 15)
						}
					} else if previewItem.type == .video {
						if let safeVideo = previewItem.videoData?.url {
							VideoPreview(player: .constant(AVPlayer(url: safeVideo)))
								.padding(.horizontal, 15)
								.padding(.top, 15)
						}
					}
				}
			}
			Text("\(vm.items.count) Files")
				.font(.appBoldFont(ofSize: 16))
			if !vm.isFilePreview {
				ScrollView(.horizontal, showsIndicators: false) {
					HStack(alignment: .center, spacing: 15) {
						ForEach(vm.items) { item in
							PreviewMini(
								item: item,
								isActive: .constant(vm.currentItem == item)
							) {
								vm.viewFully(item: item)
							}
						}
					}
					.padding(.vertical, 5)
					.padding(.leading, 15)
					.padding(.trailing, 50)
				}
			}
			HStack(alignment: .bottom) {
				Button {
					vm.host.dismiss(animated: true)
				} label: {
					HStack(alignment: .center, spacing: 10) {
						Image(systemName: "chevron.backward")
							.resizable()
							.scaledToFit()
							.foregroundColor(.appDarkGray)
							.frame(width: 15, height: 15)
						Text("Annuler")
							.font(.appRegularFont(ofSize: 16))
							.foregroundColor(.appDarkGray)
					}
				}
				Spacer()
				Button {
					vm.handleSubmit()
				} label: {
					Text("Envoyer")
						.font(.appBoldFont(ofSize: 16))
						.frame(height: 40, alignment: .center)
						.foregroundColor(Color.white)
						.padding(.horizontal, 20)
						.background(
							RoundedRectangle(cornerRadius: 7)
								.fill(Color.appPrincipal)
						)
				}
			}
			.padding(.horizontal, 15)
		}
	}
}

struct AssetsPreviewView_Previews: PreviewProvider {
	
	static var previews: some View {
		AssetsPreviewView(vm: AssetsPreviewViewModel(host: UIViewController(), withItems: []))
	}
}
