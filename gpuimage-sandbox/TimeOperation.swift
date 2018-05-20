//
//  CustomOperation.swift
//  glitch
//
//  Created by Samuel Loeschen on 5/19/18.
//  Copyright © 2018 Samuel Loeschen. All rights reserved.
//

import Foundation
import GPUImage

class TimeOperation : BasicOperation {
    
    public var currentTime: Float = 0 {
        didSet {
            uniformSettings["time"] = currentTime
        }
    }

    public init(vertexShaderFile:URL? = nil, fragmentShaderFile:URL, numberOfInputs:UInt = 1, operationName:String = #file, startTime: Float = 0) throws {
        
        try super.init(vertexShaderFile: vertexShaderFile, fragmentShaderFile: fragmentShaderFile, numberOfInputs: numberOfInputs, operationName: operationName)
        self.currentTime = startTime
    }
}

