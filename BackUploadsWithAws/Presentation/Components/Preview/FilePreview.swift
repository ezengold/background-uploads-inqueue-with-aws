//
//  FilePreview.swift
//  BackUploadsWithAws
//
//  Created by ezen on 18/09/2023.
//

import SwiftUI
import QuickLook

struct FilePreviewBridge: UIViewControllerRepresentable {
	
	let url: URL
	
	func makeUIViewController(context: Context) -> QLPreviewController {
		let vc = QLPreviewController()
		vc.dataSource = context.coordinator
		return vc
	}
	
	func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {
		// No update needed
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(parent: self)
	}
	
	class Coordinator: QLPreviewControllerDataSource {
		
		let parent: FilePreviewBridge
		
		init(parent: FilePreviewBridge) {
			self.parent = parent
		}

		func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
			1
		}
		
		func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
			parent.url as NSURL
		}
	}
}

struct FilePreview: View {
	
	@Binding var url: URL
	
    var body: some View {
		VStack {
			FilePreviewBridge(url: self.url)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
		.background(Color.black.opacity(0.04))
		.cornerRadius(10)
    }
}

struct FilePreview_Previews: PreviewProvider {

    static var previews: some View {
		FilePreview(url: .constant(Resources.dummyDocument))
    }
}
