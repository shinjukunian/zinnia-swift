//
//  Zinnia-Swift+Convenience.swift
//  
//
//  Created by Morten Bertz on 2019/07/18.
//

import Foundation

#if canImport(CoreGraphics)
import CoreGraphics

public extension Point{
    init(cgPoint:CGPoint) {
        self.x=Int(cgPoint.x)
        self.y=Int(cgPoint.y)
    }
    
    var cgPoint:CGPoint{
        return CGPoint(x: self.x, y: self.y)
    }
}

public extension Recognizer.Size{
    init(cgSize:CGSize) {
        self.width=Int(cgSize.width)
        self.height=Int(cgSize.height)
    }
    
    var cgSize:CGSize{
        return CGSize(width: self.width, height: self.height)
    }
}

public extension Stroke{
    mutating func add(point:CGPoint){
        self.add(point: Point(cgPoint: point))
    }
}

#endif
