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
    init(CGPoint:CGPoint) {
        self.x=Int(CGPoint.x)
        self.y=Int(CGPoint.y)
    }
}

public extension Recognizer.Size{
    init(CGSize:CGSize) {
        self.width=Int(CGSize.width)
        self.height=Int(CGSize.height)
    }
}

public extension Stroke{
    mutating func add(point:CGPoint){
        self.add(point: Point(CGPoint: point))
    }
}

#endif
