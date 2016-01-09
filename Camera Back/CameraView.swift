//
//  CameraView.swift
//  Camera Back
//
//  Created by Maroof Khan on 1/9/16.
//  Copyright © 2016 Maroof Khan. All rights reserved.
//

import UIKit
import AVFoundation

class CameraView: UIView {
    
    
    var position: CameraPosition? {
        didSet {
            stream(fromCameraPosition: position == nil ? .Front : position!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        stream(fromCameraPosition: position == nil ? .Front : position!)
    }

    
    private func stream(fromCameraPosition position: CameraPosition) {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        guard let device = getDevice(WithPosition: position) else {
            //MARK: These anti-statements will execute only when you will run this on a simulator.
            fatalError("You are, probably working on a simulator.\n")
            return
        }
        
        do {
            
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            let output = AVCaptureStillImageOutput()
            output.outputSettings = [
                AVVideoCodecKey: AVVideoCodecJPEG
            ]
            session.addOutput(output)
            let preview = AVCaptureVideoPreviewLayer(session: session)
            preview.videoGravity = AVLayerVideoGravityResizeAspectFill
            preview.frame = frame
            layer.addSublayer(preview)
            session.startRunning()
            
            
        } catch {
            fatalError("Could not create capture device input.")
        }
        
    }
    
    private func getDevice (WithPosition position: CameraPosition) -> AVCaptureDevice? {
        for device in AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) {
            if CameraPosition.position(device.position) == position {
                return (device as? AVCaptureDevice)
            }
        }
        return nil
    }
    
    enum CameraPosition {
        case Front, Back, Unspecified
        static func position (position: AVCaptureDevicePosition) -> CameraPosition {
            switch position {
            case .Back:
                return Back
            case .Front:
                return Front
            case .Unspecified:
                return Unspecified
            }
        }
    }
}
