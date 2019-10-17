//
//  Zinnia-Swift.swift
//
//
//  Created by Morten Bertz on 2019/07/18.
//

import Foundation
import zinnia


/**
 A SVM-based recognizer for handwritten characters. Reconition is based on 'strokes', which are akin to the stroke of a pen on a piece of paper. The order of these strokes is important for recognition
 */
public class Recognizer{
    
    public enum RecognizerErrors : Error, Equatable {
        case openingModelFailed(url:URL, errorMessage:String?)
        case recognizerInitializationFailed
    }
    
    /// A struct representing a twodimensional size.
    public struct Size : Equatable,Hashable{
        let width:Int
        let height:Int
        
        /// A size with no extent
        public static let zero=Size(width: 0, height: 0)
    }
    
    
    /// A recognition result
    public struct Result:Equatable, Comparable{
        ///The recognized character
        public let character:String
        /// The score of the recognzied character
        public let score:Float
        
        public static func < (lhs: Recognizer.Result, rhs: Recognizer.Result) -> Bool {
            return lhs.score < rhs.score
        }
        
    }
    
    fileprivate let modelURL:URL
    
    /** The size of the canvas that the character is drawn onto. The bounding box of the character's strokes should fall within this size.
     Ideally, this canvas should be square, but this is not required. This value has to be specified, the initial value is .zero
     */
    public var canvasSize:Size = .zero{
        didSet{
            zinnia_character_set_width(self._currentCharacter, canvasSize.width)
            zinnia_character_set_height(self._currentCharacter, canvasSize.height)
        }
    }
    
    ///The version of the underlying engine.
    public class var version:String{
        guard let versionString=zinnia_version() else { return "" }
        return String.init(cString: versionString)
    }
    
    fileprivate let _recognizer:OpaquePointer
    fileprivate let _currentCharacter:OpaquePointer
    
    fileprivate var currentStrokes=[Stroke]()
    
    /**
     Initializes the recognizer.
     - parameters:
        - modelURL: The location of the model file
        - canvasSize: The size of the canvas on which the characters are drawn. This can be changed later.
     - Throws:
        * `RecognizerErrors.recognizerInitializationFailed` if the recognizer could not be initialized.
        * `RecognizerErrors.openingModelFailed` if the model file does not exist or could not be read
     */
    
    public init(modelURL:URL, canvasSize:Size = .zero)throws {
        self.modelURL=modelURL
        
        guard let recognizer=zinnia_recognizer_new() else{
            throw RecognizerErrors.recognizerInitializationFailed
        }
        
        try self.modelURL.withUnsafeFileSystemRepresentation({path in
            let success=zinnia_recognizer_open(recognizer, path)
            if success != 1{
                if let error=zinnia_recognizer_strerror(recognizer){
                    let errorString=String(cString: error)
                    throw RecognizerErrors.openingModelFailed(url: modelURL, errorMessage:  errorString)
                }
                else{
                    throw RecognizerErrors.openingModelFailed(url: modelURL, errorMessage: nil)
                }
                
            }
        })
        
        self._recognizer = recognizer
        self._currentCharacter = zinnia_character_new()
        self.canvasSize=canvasSize
        zinnia_character_set_width(self._currentCharacter, canvasSize.width)
        zinnia_character_set_height(self._currentCharacter, canvasSize.height)
    }
    
    /**
     Clears and resets the current character. To be called before a new charater is started.
     */
    public func clear(){
        zinnia_character_clear(self._currentCharacter)
        self.currentStrokes.removeAll()
    }
    
    /**
     Adds a stroke to the current character. The order of strokes is important for recognition.
     - parameters:
        - stroke:The stroke to be added
     */
    public func add(stroke:Stroke){
        for point in stroke.points{
            zinnia_character_add(self._currentCharacter, self.currentStrokes.count, Int32(point.x), Int32(point.y))
        }
        self.currentStrokes.append(stroke)
    }
    
    /**
     Classifies the strokes that have been added to the current character.
     - parameters:
        - maxResults:The maximum number of results to return. Actually returned results can be fewer than this number.
     - Returns: An array of results, which contains the recognized characters and their confidence score. The array is already sorted with the most likely result at the beginning. If recognition fails, this array is empty.
     */
    public func classify(maxResults:Int = 10)->[Result]{
        guard let result=zinnia_recognizer_classify(self._recognizer, self._currentCharacter, maxResults) else {return [Result]()}
        
        let resultSize=zinnia_result_size(result)
        var results=[Result]()
        
        for i in 0..<resultSize{
            let value=String(cString: zinnia_result_value(result, i))
            let score=zinnia_result_score(result, i)
            results.append(Result(character: value, score: score))
        }
        return results
    }
    
    /**
     A convenience function to recognize several strokes
     - parameters:
        - strokes: The strokes to recognize
        - maxResults: The maximum number of results to return
     - Returns: An array of `Result`.
     */
    public func classify(strokes:[Stroke], maxResults:Int = 10)->[Result]{
        self.clear()
        for stroke in strokes{
            self.add(stroke: stroke)
        }
        return self.classify(maxResults: maxResults)
    }
    
    
    
    deinit {
        zinnia_recognizer_close(self._recognizer)
        zinnia_recognizer_destroy(self._recognizer)
        zinnia_character_destroy(self._currentCharacter)
    }
}
