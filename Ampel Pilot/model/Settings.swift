//
//  Settings.swift
//  Ampel Pilot
//
//  Created by Patrick Valenta on 16.10.17.
//  Copyright © 2017 Patrick Valenta. All rights reserved.
//

import Foundation
import AVFoundation

struct Settings {
    // Detection
    var sound: Bool
    var vibrate: Bool
    
    // Yolo
    var confidenceThreshold: Float
    var iouThreshold: Float
    
    // Camera
    var resolution: AVCaptureSession.Preset
    var zoom: Float
    var livePreview: Bool

    // Movie
    var movie: Bool
    var movieUrl: String
    
    static func initDefaults() {
        if !Defaults.hasKey("sound") {
            Defaults[DefaultsKey<Bool>("sound")] = true
        }
        
        if !Defaults.hasKey("vibrate") {
            Defaults[DefaultsKey<Bool>("vibrate")] = true
        }
        
        if !Defaults.hasKey("confidenceThreshold") {
            Defaults[DefaultsKey<Double>("confidenceThreshold")] = 0.4
        }
        
        if !Defaults.hasKey("iouThreshold") {
            Defaults[DefaultsKey<Double>("iouThreshold")] = 0.5
        }
        
        if !Defaults.hasKey("resolution") {
            Defaults[DefaultsKey<Any?>("resolution")] = AVCaptureSession.Preset.hd1920x1080
        }
        
        if !Defaults.hasKey("zoom") {
            Defaults[DefaultsKey<Double>("zoom")] = 1.25
        }

        if !Defaults.hasKey("livePreview") {
            Defaults[DefaultsKey<Bool>("livePreview")] = false
        }

        if !Defaults.hasKey("Movie") {
            Defaults[DefaultsKey<Bool>("Movie")] = false
        }

        if !Defaults.hasKey("Movie URL") {
            Defaults[DefaultsKey<String>("Movie URL")] = ""
        }
    }
    
    static func removeKeys() {
        Defaults.remove("sound")
        Defaults.remove("vibrate")
        Defaults.remove("confidenceThreshold")
        Defaults.remove("iouThreshold")
        Defaults.remove("resolution")
        Defaults.remove("zoom")
        Defaults.remove("livePreview")
        Defaults.remove("Movie")
        Defaults.remove("Movie URL")
    }
    
    static func fetch() -> Settings {
        let sound = Defaults[DefaultsKey<Bool>("sound")]
        let vibrate = Defaults[DefaultsKey<Bool>("vibrate")]
        let cThresh = Float(Defaults[DefaultsKey<Double>("confidenceThreshold")])
        let iouThresh = Float(Defaults[DefaultsKey<Double>("iouThreshold")])
        let resolution = Defaults[DefaultsKey<Any?>("resolution")] as! AVCaptureSession.Preset
        let zoom = Float(Defaults[DefaultsKey<Double>("zoom")])
        let livePreview = Defaults[DefaultsKey<Bool>("livePreview")]
        let movie = Defaults[DefaultsKey<Bool>("Movie")]
        let movieUrl = Defaults[DefaultsKey<String>("Movie URL")]
        
        return Settings(sound: sound, vibrate: vibrate, confidenceThreshold: cThresh, iouThreshold: iouThresh, resolution: resolution, zoom: zoom, livePreview: livePreview, movie: movie, movieUrl: movieUrl)
    }
    
    func save() {
        Defaults[DefaultsKey<Bool>("sound")] = self.sound
        Defaults[DefaultsKey<Bool>("vibrate")] = self.vibrate
        Defaults[DefaultsKey<Double>("confidenceThreshold")] = Double(self.confidenceThreshold)
        Defaults[DefaultsKey<Double>("iouThreshold")] = Double(self.iouThreshold)
        Defaults[DefaultsKey<Any?>("resolution")] = self.resolution
        Defaults[DefaultsKey<Double>("zoom")] = Double(self.zoom)
        Defaults[DefaultsKey<Bool>("livePreview")] = self.livePreview
        Defaults[DefaultsKey<Bool>("Movie")] = self.movie
        Defaults[DefaultsKey<String>("Movie URL")] = self.movieUrl
    }
}
