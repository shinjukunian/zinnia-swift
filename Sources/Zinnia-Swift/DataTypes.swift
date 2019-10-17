//
//  DataTypes.swift
//  
//
//  Created by Morten Bertz on 2019/07/18.
//

import Foundation

/**
 A struct to represent a point in two-dimensional space
 */
public struct Point{
    ///The horizontal distance from the origin
    let x:Int
    ///The vertical distance from the origin
    let y:Int
    
    static let zero = Point(x: 0, y: 0)
}


/**
 A stroke, a gesture that contains a number of points (from pen down to pen up). Several strokes make a character.
 */
public struct Stroke{
    public var points=[Point]()
    
    public mutating func add(point:Point){
        self.points.append(point)
    }
    
    public init(){}
    
    public init(start:Point){
        self.add(point: start)
    }
    
    public init(points:[Point]){
        self.points=points
    }
    
}
