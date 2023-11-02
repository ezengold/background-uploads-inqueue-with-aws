//
//  Navigations.swift
//  BackUploadsWithAws
//
//  Created by ezen on 14/09/2023.
//

import Foundation
import UIKit
import YPImagePicker

extension UIViewController {
	
	func showOngoingUploads() {
		lazy var vc = OngoingsViewController()
		vc.view.backgroundColor = .white
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	func showDetailsView(ofFolder folder: ChatFolder) {
		lazy var vc = FolderDetailsViewController()
		vc.folder = folder
		vc.view.backgroundColor = .white
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	func previewPickedAssets(withItems items: [(FileType, Any)], onFinish: (([PreviewElement]) -> Void)?) {
		lazy var vc = AssetsPreviewViewController()
		vc.pickedItems = items
		vc.onFinish = onFinish
		vc.view.backgroundColor = .white
		vc.modalPresentationStyle = .fullScreen
		self.present(vc, animated: true)
	}
}
