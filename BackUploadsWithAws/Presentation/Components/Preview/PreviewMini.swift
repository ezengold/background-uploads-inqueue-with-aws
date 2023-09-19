//
//  PreviewMini.swift
//  BackUploadsWithAws
//
//  Created by ezen on 18/09/2023.
//

import SwiftUI

struct PreviewMini: View {
	
	@State var item: PreviewElement
	
	@Binding var isActive: Bool
	
	var onClick: (() -> Void)? = nil
	
	var body: some View {
		if item.type == .image {
			Image(uiImage: item.imageData?.image ?? UIImage())
				.resizable()
				.scaledToFill()
				.frame(width: 120, height: 120)
				.background(Color.black.opacity(0.35))
				.cornerRadius(10)
				.overlay(
					VStack(alignment: .center) {
						Image(uiImage: FileType.image.icon)
							.resizable()
							.foregroundColor(.white)
							.scaledToFit()
							.frame(width: 25, height: 25)
					}
						.frame(width: 120, height: 120, alignment: .center)
						.background(Color.black.opacity(0.5))
						.cornerRadius(10)
						.overlay(
							RoundedRectangle(cornerRadius: 10)
								.stroke(Color.appPrincipal, lineWidth: isActive ? 2 : 0)
						)
				)
				.onTapGesture {
					onClick?()
				}
		} else if item.type == .video {
			Image(uiImage: item.imageData?.image ?? UIImage())
				.resizable()
				.scaledToFill()
				.frame(width: 120, height: 120)
				.background(Color.black.opacity(0.35))
				.cornerRadius(10)
				.overlay(
					VStack(alignment: .center) {
						Image(uiImage: FileType.video.icon)
							.resizable()
							.foregroundColor(.white)
							.scaledToFit()
							.frame(width: 25, height: 25)
					}
						.frame(width: 120, height: 120, alignment: .center)
						.background(Color.black.opacity(0.5))
						.cornerRadius(10)
						.overlay(
							RoundedRectangle(cornerRadius: 10)
								.stroke(Color.appPrincipal, lineWidth: isActive ? 2 : 0)
						)
				)
				.onTapGesture {
					onClick?()
				}
		} else if item.type == .file {
			Image(uiImage: UIImage())
				.resizable()
				.scaledToFill()
				.frame(width: 120, height: 120)
				.background(Color.black.opacity(0.35))
				.cornerRadius(10)
				.overlay(
					VStack(alignment: .center) {
						Image(uiImage: FileType.file.icon)
							.resizable()
							.foregroundColor(.white)
							.scaledToFit()
							.frame(width: 25, height: 25)
					}
						.frame(width: 120, height: 120, alignment: .center)
						.background(Color.appPrincipal.opacity(0.2))
						.cornerRadius(10)
						.overlay(
							RoundedRectangle(cornerRadius: 10)
								.stroke(Color.appPrincipal, lineWidth: isActive ? 2 : 0)
						)
				)
				.onTapGesture {
					onClick?()
				}
		}
	}
}

struct PreviewMini_Previews: PreviewProvider {
	
    static var previews: some View {
		PreviewMini(
			item: PreviewElement(type: .file),
			isActive: .constant(true)
		)
		.previewLayout(.sizeThatFits)
    }
}
