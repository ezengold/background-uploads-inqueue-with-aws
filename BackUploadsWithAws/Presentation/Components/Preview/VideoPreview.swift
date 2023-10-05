//
//  VideoPreview.swift
//  BackUploadsWithAws
//
//  Created by ezen on 18/09/2023.
//

import SwiftUI
import AVKit

struct VideoPreview: View {
	
	@Binding var player: AVPlayer
	
    var body: some View {
		VStack {
			VideoPlayer(player: player)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
		.background(Color.black.opacity(0.04))
		.cornerRadius(30)
		.onDisappear {
			self.player.pause()
		}
    }
}

struct VideoPreview_Previews: PreviewProvider {

    static var previews: some View {
		VideoPreview(player: .constant(AVPlayer(url: Resources.dummyVideo)))
    }
}
