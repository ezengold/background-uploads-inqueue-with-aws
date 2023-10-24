//
//  ChatFilePreview.swift
//  BackUploadsWithAws
//
//  Created by ezen on 23/10/2023.
//

import SwiftUI
import AVKit

struct ChatFilePreview: View {
	
	@Binding var file: ChatFile
	
	var onDelete: ((ChatFile) -> Void)?
	
	var body: some View {
		VStack(spacing: 5) {
			HStack(alignment: .top, spacing: 10) {
				VStack(alignment: .center, spacing: 10) {
					Text(file.file.s3UploadKey)
						.font(.appBoldFont(ofSize: 15))
						.foregroundColor(.black)
						.frame(maxWidth: .infinity, alignment: .leading)
					Text("Added : \(file.addedAt.toFormat("yyyy-MM-dd [at] HH:mm"))")
						.font(.appRegularFont(ofSize: 14))
						.foregroundColor(.appDarkGray)
						.frame(maxWidth: .infinity, alignment: .leading)
				}
				Image(systemName: "trash")
					.resizable()
					.foregroundColor(.red)
					.scaledToFit()
					.frame(width: 20, height: 20)
					.onTapGesture {
						onDelete?(file)
					}
			}
			.frame(maxWidth: .infinity)
			.padding(10)
			.background(Color.white)
			.cornerRadius(5)
			if file.file.contentType == .image {
				AsyncImage(url: URL(string: file.file.publicUrl)) { img in
					img
						.resizable()
						.aspectRatio(contentMode: .fill)
					
				} placeholder: {
					Image(uiImage: FileType.image.icon)
						.resizable()
						.scaledToFit()
						.foregroundColor(.white)
						.frame(width: 50, height: 50)
				}
				.frame(height: 200)
				.frame(maxWidth: .infinity)
				.background(Color.black.opacity(0.1))
				.cornerRadius(5)
			} else if file.file.contentType == .video {
				if let safeVideoUrl = URL(string: file.file.publicUrl) {
					VideoPreview(
						player: .constant(AVPlayer(url: safeVideoUrl)),
						cornerRadius: 5
					)
					.frame(height: 200)
					.frame(maxWidth: .infinity)
				}
			} else if file.file.contentType == .file {
				Button {
					// TODO: Visualize the file
				} label: {
					VStack(alignment: .center, spacing: 10) {
						Image(uiImage: FileType.file.icon)
							.resizable()
							.scaledToFit()
							.foregroundColor(.white)
							.frame(width: 40, height: 40)
						Text("Click here to open")
							.font(.appRegularFont(ofSize: 14))
							.foregroundColor(.white)
					}
				}
				.frame(height: 200)
				.frame(maxWidth: .infinity)
				.background(Color.black.opacity(0.1))
				.cornerRadius(5)
			}
		}
		.padding(5)
		.background(Color.appFileBack)
		.cornerRadius(7)
	}
}

#Preview {
	ChatFilePreview(file: .constant(.DUMMY_DOC_FILE))
		.previewLayout(.sizeThatFits)
}
