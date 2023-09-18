//
//  FolderDetailsViewController.swift
//  BackUploadsWithAws
//
//  Created by ezen on 17/09/2023.
//

import UIKit
import SwiftUI
import YPImagePicker
import AVFoundation

class FolderDetailsViewController: UIViewController {
	
	private var searchController = UISearchController(searchResultsController: nil)
	
	var vm: FolderDetailsViewModel!
	
	var folder: ChatFolder!

	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		self.setupNavBar()
		
		self.title = folder.folderName
		
		self.vm = FolderDetailsViewModel(host: self, withFolder: self.folder)
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
	
	private func setupNavBar() {
		
		let addItem = UIBarButtonItem(
			image: UIImage(systemName: "doc.badge.plus"),
			primaryAction: nil,
			menu: UIMenu(
				title: "Add a new asset",
				children: [
					UIAction(title: "Image", image: UIImage(named: "image-icon"), handler: self.pickImages),
					UIAction(title: "Video", image: UIImage(named: "video-icon"), handler: self.pickVideos),
					UIAction(title: "File", image: UIImage(systemName: "doc"), handler: { _ in
						//
					}),
				]
			)
		)
		addItem.tintColor = .appPrincipal
		self.navigationItem.rightBarButtonItem = addItem
	}
}

// MARK: - Handle pickers
extension FolderDetailsViewController {
	
	@objc
	func pickImages(_ action: UIAction) {

		var configs = getDefaultConfigs()
		setImageConfigs(toConfig: &configs)

		lazy var vc = YPImagePicker(configuration: configs)

		vc.didFinishPicking { [unowned vc] items, cancelled in
			vc.dismiss(animated: false) {
				self.previewPickedAssets(withItems: items)
			}
		}
		self.present(vc, animated: true)
	}
	
	@objc
	func pickVideos(_ action: UIAction) {
		
		var configs = getDefaultConfigs()
		setVideoConfigs(toConfig: &configs)
	
		lazy var vc = YPImagePicker(configuration: configs)

		vc.didFinishPicking { [unowned vc] items, cancelled in
			vc.dismiss(animated: false) {
				self.previewPickedAssets(withItems: items)
			}
		}
		self.present(vc, animated: true)
	}
	
	private func getDefaultConfigs() -> YPImagePickerConfiguration {
		
		var config = YPImagePickerConfiguration()
		config.albumName = "BacksUp"
		config.preferredStatusBarStyle = UIStatusBarStyle.default
		config.startOnScreen = YPPickerScreen.library
		config.bottomMenuItemSelectedTextColour = #colorLiteral(red: 0.1980375946, green: 0.1980375946, blue: 0.1980375946, alpha: 1)
		config.bottomMenuItemUnSelectedTextColour = #colorLiteral(red: 0.6642268896, green: 0.6642268896, blue: 0.6642268896, alpha: 1)
		config.maxCameraZoomFactor = 10.0
		config.fonts.pickerTitleFont = .appBoldFont(ofSize: 17)
		config.fonts.libaryWarningFont = .appRegularFont(ofSize: 14)
		config.fonts.durationFont = .appRegularFont(ofSize: 12)
		config.fonts.multipleSelectionIndicatorFont = .appRegularFont(ofSize: 12)
		config.fonts.albumCellTitleFont = .appRegularFont(ofSize: 16)
		config.fonts.albumCellNumberOfItemsFont = .appRegularFont(ofSize: 12)
		config.fonts.menuItemFont = .appRegularFont(ofSize: 17)
		config.fonts.filterNameFont = .appRegularFont(ofSize: 11)
		config.fonts.filterSelectionSelectedFont = .appRegularFont(ofSize: 11)
		config.fonts.filterSelectionUnSelectedFont = .appRegularFont(ofSize: 11)
		config.fonts.navigationBarTitleFont = .appBoldFont(ofSize: 17)
		config.fonts.rightBarButtonFont = .appRegularFont(ofSize: 17)
		config.fonts.leftBarButtonFont = .appRegularFont(ofSize: 17)
		return config
	}
	
	private func setImageConfigs(toConfig config: inout YPImagePickerConfiguration) {
		
		config.showsCrop = .none
		config.shouldSaveNewPicturesToAlbum = false
		config.targetImageSize = .original
		config.showsPhotoFilters = true
		config.screens = [.library, .photo]
		config.library.mediaType = .photo
		config.library.maxNumberOfItems = 5
		config.library.spacingBetweenItems = 1.0
		config.library.defaultMultipleSelection = true
		config.library.skipSelectionsGallery = true
		config.library.isSquareByDefault = false
		config.library.preSelectItemOnMultipleSelection = false
	}
	
	private func setVideoConfigs(toConfig config: inout YPImagePickerConfiguration) {
		
		config.showsVideoTrimmer = true
		config.screens = [.library, .video]
		config.library.minNumberOfItems = 1
		config.library.maxNumberOfItems = 2
		config.video.libraryTimeLimit = 60.0 * 3
		config.video.compression = AVAssetExportPresetHighestQuality
		config.video.fileType = .mp4
		config.library.mediaType = .video
		config.library.isSquareByDefault = false
	}
}
