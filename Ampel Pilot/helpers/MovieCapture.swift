//
//  MovieCapture.swift
//  Ampel Pilot
//
//  Created by Андрей Гавриков on 26.02.2022.
//  Copyright © 2022 Patrick Valenta. All rights reserved.
//

import Foundation
import AVFoundation
import CoreImage

class FizedSizeOperationQueue: OperationQueue {
    override func addOperation(_ block: @escaping () -> Void) {
        if self.operationCount < self.maxConcurrentOperationCount {
            super.addOperation(block)
        }
//        else {
//            print("skipped")
//        }
    }
}

public class MovieCapture: NSObject, Capture {
    private var movieUrl: URL
    private var player: AVPlayer!
    private var videoOutput: AVPlayerItemVideoOutput!
    var lastTimestamp = CMTime()
    let queue = FizedSizeOperationQueue()

    init(from url: URL) {
        movieUrl = url
        queue.maxConcurrentOperationCount = 2
    }

    public func start() {
        print("PLAY")
        if player.timeControlStatus != .playing {
            let currentItem = player.currentItem
            if currentItem?.currentTime() == currentItem?.duration {
                currentItem?.seek(to: kCMTimeZero, completionHandler: nil)
            }
            player.play()
            delegate?.videoCaptureDidStart(self)
        }
    }

    public func stop() {
        print("STOP")
        if player.timeControlStatus != .paused {
            player.pause()
            delegate?.videoCaptureDidStop(self)
        }
    }

    public func zoomIn() {
        print("ZOOM_IN")
    }

    public func zoomOut() {
        print("ZOOM_OUT")
    }

    public var delegate: CaptureDelegate?
    public var initialZoom: CGFloat = 1.0
    public var fps: Int = 1
    public var previewLayer: CALayer?

    public func setUp(completion: @escaping (Bool) -> Void) {
        player = AVPlayer(url: movieUrl)
        videoOutput = AVPlayerItemVideoOutput()
        player.currentItem?.add(videoOutput)
        let displayLink = CADisplayLink(target: self, selector: #selector(displayLinkDidRefresh(link:)))
        displayLink.add(to: RunLoop.main, forMode: .commonModes)
        let playerLayer = AVPlayerLayer()
        playerLayer.player = player
        previewLayer = playerLayer

        completion(true)
    }

    @objc
    func displayLinkDidRefresh(link: CADisplayLink) {
        let timestamp = videoOutput.itemTime(forHostTime: CACurrentMediaTime())
        
        if videoOutput.hasNewPixelBuffer(forItemTime: timestamp) {
            let pixelBuffer = videoOutput.copyPixelBuffer(forItemTime: timestamp, itemTimeForDisplay: nil)
            let deltaTime = timestamp - lastTimestamp
            if deltaTime >= CMTimeMake(1, Int32(fps)) {
                lastTimestamp = timestamp
                queue.addOperation {
                    self.delegate?.videoCapture(self, didCaptureVideoFrame: pixelBuffer, timestamp: timestamp)
                }
            }
        }
    }
}



