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

class FixedSizeOperationQueue: OperationQueue {
    override func addOperation(_ block: @escaping () -> Void) {
        if self.operationCount < self.maxConcurrentOperationCount {
            super.addOperation(block)
        }
        else {
            print("skipped")
        }
    }
}

public class MovieCapture: NSObject, Capture {
    private var movieUrl: URL
    private var player: AVPlayer!
    private var videoOutput: AVPlayerItemVideoOutput!
    private var timeObserverToken: Any?
    private let opQueue = FixedSizeOperationQueue()
    private var orientation: CGImagePropertyOrientation = .up

    private let queue = DispatchQueue(label: "net.machinethink.video-queue", qos: .userInteractive)

    init(from url: URL) {
        movieUrl = url
        opQueue.maxConcurrentOperationCount = 2
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
        let requiredAssetKeys = [
            "playable",
            "hasProtectedContent"
        ]
        let asset = AVAsset(url: movieUrl)
        let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: requiredAssetKeys)

        player = AVPlayer(playerItem: playerItem)

        videoOutput = AVPlayerItemVideoOutput()
        player.currentItem?.add(videoOutput)

        if let transform = asset.tracks(withMediaType: .video).first?.preferredTransform {
            orientation = getOrientation(from: transform)
        }

        let interval = CMTimeMake(1, Int32(fps))
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: queue, using: CheckNextFrameRefresh)
        previewLayer = AVPlayerLayer(player: player)

        if let error = playerItem.error {
            print(error.localizedDescription)
            completion(false)
        } else {
            completion(true)
        }
    }

    func CheckNextFrameRefresh(timestamp: CMTime) {
        if videoOutput.hasNewPixelBuffer(forItemTime: timestamp),
           var pixelBuffer = videoOutput.copyPixelBuffer(forItemTime: timestamp, itemTimeForDisplay: nil)
        {
            print(timestamp.seconds)
            if orientation != .up {
                if let rotatedBuffer = Filter.rotate(pixelBuffer, orientation: orientation) {
                    pixelBuffer = rotatedBuffer
                }
            }
            opQueue.addOperation {
                self.delegate?.videoCapture(self, didCaptureVideoFrame: Filter.mani(buffer: pixelBuffer), timestamp: timestamp)
            }
        } else {
            print("CheckNextFrameRefresh called, hasNewPixelBuffer = false")
        }
    }
}
