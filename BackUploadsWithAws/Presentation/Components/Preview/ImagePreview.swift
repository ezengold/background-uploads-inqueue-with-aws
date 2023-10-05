//
//  ImagePreview.swift
//  BackUploadsWithAws
//
//  Created by ezen on 18/09/2023.
//

import SwiftUI

struct ImagePreview: View {
	
	@Binding var image: UIImage
	
    var body: some View {
		VStack {
			Image(uiImage: image)
				.resizable()
				.scaledToFit()
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
		.background(Color.black.opacity(0.04))
		.cornerRadius(30)
    }
}

struct ImagePreview_Previews: PreviewProvider {

    static var previews: some View {
		ImagePreview(image: .constant(#imageLiteral(resourceName: "reiner")))
    }
}
