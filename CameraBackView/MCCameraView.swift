//
//  MCCameraBackView.swift
//  CameraBackView
//
//  Created by Maroof Khan on 1/16/15.
//  Copyright (c) 2015 Maroof Khan. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files, to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.




import UIKit
import AVFoundation

enum DevicePosition : Int {
    case Front
    case Back
}

class MCCameraView: UIView {
    
    //MARK: BlurEffect
    var blurEffect: UIBlurEffect = UIBlurEffect(style: .ExtraLight)
    
    //MARK: Blur
    var blur: Bool {
        get {
            let blurEffectView = subviews[1] as? UIVisualEffectView
            if blurEffectView == nil {
                return false
            
            } else {
                return true
            
            }
        
        } set {
            if newValue == true {
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = bounds
                addSubview(blurEffectView)
                
            } else {
                let blurEffectView = subviews[1] as? UIVisualEffectView
                blurEffectView!.removeFromSuperview()
                
            }
        }
    }
    
    //MARK: Initializers
    required init (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        cameraBack(CameraInPosition: .Front)
    
    }
    
    init (InView View: UIView, DevicePosition position: DevicePosition) {
        let frame = View.frame
        super.init(frame: frame)
        cameraBack(CameraInPosition: position)
        
    }
    
    //MARK: Change in camera postion
    func changeCameraPostion (DevicePosition position: DevicePosition) {
        cameraBack(CameraInPosition: position)
    
    }

    //MARK: Capture through camera
    private func cameraBack (CameraInPosition position: DevicePosition) {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        var device: AVCaptureDevice?
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        for aDevice in devices {
            if position == .Back {
                if  aDevice.position  == AVCaptureDevicePosition.Back {
                    device = aDevice as? AVCaptureDevice
                
                }
                
            } else {
                if aDevice.position == AVCaptureDevicePosition.Front {
                    device = aDevice as? AVCaptureDevice
                
                }
            }
        }
        
        if device == nil {
            println("No camera found!")
            println("YOU ARE PROBABLY WORKING WITH A SIMULATOR LAD!")
            return
        }
        
        var error = NSErrorPointer()
        let outputSettings = NSDictionary(dictionary:[AVVideoCodecKey:AVVideoCodecJPEG])
        let input = AVCaptureDeviceInput(device: device, error: error)
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        let imageOutput = AVCaptureStillImageOutput()
        imageOutput.outputSettings = outputSettings
        session.addOutput(imageOutput)
        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = AVLayerVideoGravityResizeAspectFill
        preview.frame = frame
        layer.addSublayer(preview)
        session.startRunning()
        
    }
    
}

