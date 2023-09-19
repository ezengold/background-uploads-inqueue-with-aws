//
//  VideoPreview.swift
//  BackUploadsWithAws
//
//  Created by ezen on 18/09/2023.
//

import SwiftUI
import AVKit

struct VideoPreview: View {
	
	@Binding var url: URL
	
	@State var player: AVPlayer? = nil
	
    var body: some View {
		VStack {
			VideoPlayer(player: player)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
		.background(Color.black.opacity(0.04))
		.cornerRadius(10)
		.onAppear {
			self.player = AVPlayer(url: self.url)
		}
    }
}

struct VideoPreview_Previews: PreviewProvider {

    static var previews: some View {
		VideoPreview(url: .constant(Resources.dummyVideo))
    }
}
