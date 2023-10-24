//
//  ChatFileLoadingPreview.swift
//  BackUploadsWithAws
//
//  Created by ezen on 16/10/2023.
//

import SwiftUI

struct ChatFileLoadingPreview: View {
	
	@Binding var file: ChatFile
	
	var onRefresh: ((ChatFile) -> Void)?
	
	var onDelete: ((ChatFile) -> Void)?
	
	var body: some View {
		HStack {
			VStack(alignment: .leading, spacing: 10) {
				HStack(alignment: .top) {
					Text(file.file.s3UploadKey)
						.font(.appBoldFont(ofSize: 15))
						.foregroundColor(.black)
					Spacer()
					Image(uiImage: file.file.contentType.icon)
						.resizable()
						.foregroundColor(.black)
						.scaledToFit()
						.frame(width: 25, height: 25)
				}
				if file.file.status == .error {
					Text("Failed due to such reason")
						.font(.appRegularFont(ofSize: 14))
						.foregroundColor(.red)
				}
				if [TaskStatus.pending, TaskStatus.running].contains(file.file.status) {
					ProgressView(value: (file.file.progress / 100.0))
						.accentColor(.appPrincipal)
				}
				Text("Added : \(file.addedAt.toFormat("yyyy-MM-dd [at] HH:mm"))")
					.font(.appRegularFont(ofSize: 14))
					.foregroundColor(.appDarkGray)
			}
			.frame(width: UIScreen.main.bounds.width * 0.6)
			.padding(10)
			.background(Color.white)
			.cornerRadius(7)
			Spacer()
			HStack(alignment: .center, spacing: 10) {
				if file.file.status == .error && UploadService.isInUploadsDirectory(file.file) {
					Image(systemName: "arrow.clockwise")
						.resizable()
						.foregroundColor(.appPrincipal)
						.scaledToFit()
						.frame(width: 25, height: 25)
						.onTapGesture {
							onRefresh?(file)
						}
				}
				Image(systemName: "trash")
					.resizable()
					.foregroundColor(.white)
					.scaledToFit()
					.frame(width: 25, height: 25)
					.onTapGesture {
						onDelete?(file)
					}
			}
		}
		.padding(10)
		.background(
			Image(uiImage: getBackImage())
				.blur(radius: 7.0)
		)
		.background(Color.appFileBack)
		.cornerRadius(7)
	}
	
	func getBackImage() -> UIImage {
		if file.file.contentType == .image {
			guard let safeUrl = file.file.getActualUrl(), let safeImage = UIImage(contentsOfFile: safeUrl.path) else {
				return UIImage()
			}
			return safeImage
		} else if file.file.contentType == .video {
			if let thumbData = file.thumbData {
				return UIImage(data: thumbData) ?? UIImage()
			} else {
				return UIImage()
			}
		} else {
			return UIImage()
		}
	}
}

#Preview {
	ChatFileLoadingPreview(file: .constant(.DUMMY_VIDEO_FILE))
		.previewLayout(.sizeThatFits)
}
