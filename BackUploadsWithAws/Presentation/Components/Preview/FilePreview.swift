//
//  FilePreview.swift
//  BackUploadsWithAws
//
//  Created by ezen on 18/09/2023.
//

import SwiftUI
import QuickLook

struct FilePreviewBridge: UIViewControllerRepresentable {
	
	var files: [PreviewElement]
	
	func makeUIViewController(context: Context) -> QLPreviewController {
		let vc = QLPreviewController()
		vc.dataSource = context.coordinator
		return vc
	}
	
	func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) { }
	
	func makeCoordinator() -> Coordinator {
		Coordinator(parent: self)
	}
	
	class Coordinator: QLPreviewControllerDataSource {
		
		let parent: FilePreviewBridge
		
		init(parent: FilePreviewBridge) {
			self.parent = parent
		}

		func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
			self.parent.files.count
		}
		
		func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
			if let safeFile = self.parent.files[index].fileData {
				return safeFile as NSURL
			}
			return URL(string: "")! as NSURL
		}
	}
}

struct FilePreview: View {
	
	@Binding var files: [PreviewElement]
	
    var body: some View {
		VStack {
			Text("Slide to Left or Right to see more files")
				.font(.appRegularFont(ofSize: 14))
				.foregroundColor(.gray)
				.padding(.vertical, 5)
			VStack {
				FilePreviewBridge(files: files)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
			.background(Color.black.opacity(0.04))
			.cornerRadius(0)
			.overlay(
				RoundedRectangle(cornerRadius: 0)
					.stroke(Color.black.opacity(0.04), lineWidth: 2)
			)
		}
    }
}

struct FilePreview_Previews: PreviewProvider {

    static var previews: some View {
		FilePreview(files: .constant([]))
    }
}
