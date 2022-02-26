//
//  MovieCapture.swift
//  Ampel Pilot
//
//  Created by Андрей Гавриков on 26.02.2022.
//  Copyright © 2022 Patrick Valenta. All rights reserved.
//

import Foundation
import AVFoundation

public class MovieCapture: NSObject, Capture {
    public func start() {

    }

    public func stop() {

    }

    public func zoomIn() {

    }

    public func zoomOut() {

    }

    public var delegate: CaptureDelegate?

    public var initialZoom: CGFloat = 1.5

    public var fps: Int = 15

    public func setUp(completion: @escaping (Bool) -> Void) {

    }

    public var previewLayer: CALayer?




}
