//
//  ViewController.swift
//  glitch
//
//  Created by Samuel Loeschen on 5/19/18.
//  Copyright © 2018 Samuel Loeschen. All rights reserved.
//

import UIKit
import GPUImage
import AVFoundation

class ViewController: UIViewController {
    
//    @IBOutlet weak var renderView: RenderView!
    @IBOutlet var renderView: RenderView!
    var camera: Camera?
    var floydSteinbergFilter: BasicOperation?
    var pixellateFilter = Pixellate()
    
    //MARK: Time
    public var currentT: Float = 0
    public var deltaT: Float = 0
    public var awakeTime: Float = 0
    
    private var displayLink: CADisplayLink!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up camera/rendering pipeline
        do {
            
            //get camera
            camera = try Camera(sessionPreset: AVCaptureSession.Preset.hd1920x1080.rawValue)
            
            //compile shader
            let url = Bundle.main.url(forResource: "FakeFloydSteinberg_GLES", withExtension: "fsh")
            floydSteinbergFilter = try BasicOperation(fragmentShaderFile: url!, numberOfInputs: 1)
            
            
        } catch {
            fatalError("Could not initialize rendering pipeline: \(error)")
        }
        
        //time since the application began
        awakeTime = Float(Date().timeIntervalSinceReferenceDate)
        
        //set up display link
        displayLink = CADisplayLink(target: self, selector: #selector(renderLoop))
        displayLink.add(to: .current, forMode: .defaultRunLoopMode)
        
        guard let camera = camera,
            let floydSteinbergFilter = floydSteinbergFilter else { return }
        
        pixellateFilter.fractionalWidthOfAPixel = 0.005
        camera --> pixellateFilter --> floydSteinbergFilter --> renderView
        camera.startCapture()
    }
    
    @objc func renderLoop () {
        deltaT = Float(displayLink.timestamp) - currentT
        currentT = Float(displayLink.timestamp)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

