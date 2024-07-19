//
//  YoutubePlayer.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 19.07.2024.
//

import Foundation
import SwiftUI
import YouTubeiOSPlayerHelper

struct YouTubePlayerView: UIViewRepresentable {
    let videoID: String
    @Binding var isLoading: Bool
    
    func makeUIView(context: Context) -> YTPlayerView {
        let playerView = YTPlayerView()
        playerView.delegate = context.coordinator
        playerView.load(withVideoId: videoID)
        return playerView
    }
    
    func updateUIView(_ uiView: YTPlayerView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isLoading: $isLoading)
    }
    
    class Coordinator: NSObject, YTPlayerViewDelegate {
        @Binding var isLoading: Bool
        
        init(isLoading: Binding<Bool>) {
            _isLoading = isLoading
        }
        
        func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
            isLoading = false
        }
    }
}
