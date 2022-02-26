//
//  Capture.swift
//  Ampel Pilot
//
//  Created by Андрей Гавриков on 26.02.2022.
//  Copyright © 2022 Patrick Valenta. All rights reserved.
//

import Foundation
import AVFoundation
import CoreVideo

public protocol CaptureDelegate: class {
    func videoCapture(_ capture: Capture, didCaptureVideoFrame: CVPixelBuffer?, timestamp: CMTime)

    func videoCaptureDidStop(_ capture: Capture)
    func videoCaptureDidStart(_ capture: Capture)
}

public protocol Capture {
    func start()
    func stop()
    func zoomIn()
    func zoomOut()
    var delegate: CaptureDelegate? { get set }
    var initialZoom: CGFloat { get set }
    var fps: Int { get set }
    func setUp(completion: @escaping (Bool) -> Void)
    var previewLayer: CALayer? { get }
}
