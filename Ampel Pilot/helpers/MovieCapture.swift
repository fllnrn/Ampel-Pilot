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
    private var movieUrl: URL

    init(from url: URL) {
        movieUrl = url
    }

    public func start() {
        print("START")
    }

    public func stop() {
        print("STOP")
    }

    public func zoomIn() {
        print("ZOOM_IN")
    }

    public func zoomOut() {
        print("ZOOM_OUT")
    }

    public var delegate: CaptureDelegate?

    public var initialZoom: CGFloat = 1.5

    public var fps: Int = 15

    public func setUp(completion: @escaping (Bool) -> Void) {
        print("SET_UP")
        completion(true)
    }

    public var previewLayer: CALayer?




}
