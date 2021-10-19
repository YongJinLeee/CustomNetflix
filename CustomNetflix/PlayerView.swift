//
//  PlayerView.swift
//  CustomNetflix
//
//  Created by LeeYongJin on 2021/10/19.
//

import UIKit
import AVFoundation
// 공식 문서 https://developer.apple.com/documentation/avfoundation/avplayerlayer/ 에서 다운로드
/// A view that displays the visual contents of a player object.
class PlayerView: UIView {

    // Override the property to make AVPlayerLayer the view's backing layer.
    override static var layerClass: AnyClass { AVPlayerLayer.self }
    
    // The associated player object.
    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }
    
    private var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
}
