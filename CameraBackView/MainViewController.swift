//
//  MainViewController.swift
//  CameraBackView
//
//  Created by Maroof Khan on 1/16/15.
//  Copyright (c) 2015 Maroof Khan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To set up bur
        let cameraBack = view as MCCameraView
        cameraBack.blur = true
        // Since the default style is Extra light, the blur set wuld be extra light.
        
        // To change blur style
        cameraBack.blurEffect = UIBlurEffect(style: .Dark)
        cameraBack.blur = true
        // You need to set the blur value true again in order to update your blurEffect
        
    }


}

