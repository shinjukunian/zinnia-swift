import XCTest
@testable import Zinnia_Swift

final class Zinnia_SwiftTests: XCTestCase {
    
    lazy var 一:[Stroke]={
        var stroke=Stroke()
        stroke.add(point: Point(x: 50, y: 250))
        stroke.add(point: Point(x: 450, y: 250))
        return [stroke]
    }()
    
    
    lazy var 中:[Stroke]={
        return [Stroke(points: [Point(x: 50, y: 200),
                                Point(x: 50, y: 300)]),
                Stroke(points: [Point(x: 50, y: 200),
                                Point(x: 450, y: 200),
                                Point(x: 450, y: 300)]),
                Stroke(points: [Point(x: 50, y: 300),
                                Point(x: 450, y: 300)]),
                Stroke(points: [Point(x: 250, y: 100),
                                Point(x: 250, y: 400)])
        ]
        
    }()
    
    func testVersion() {
        let version=Recognizer.version
        XCTAssert(version.count > 0, "Version String empty")
    }
    
    func testInitialization(){
        let currentURL=URL(fileURLWithPath: #file).deletingLastPathComponent().deletingLastPathComponent()
        let modelURL=currentURL.appendingPathComponent("Resources", isDirectory: true).appendingPathComponent("handwriting-ja").appendingPathExtension("model")
        do{
            let recognizer = try Recognizer(modelURL: modelURL)
            XCTAssert(recognizer.canvasSize == Recognizer.Size.zero)
        }
        catch let error{
            XCTFail(error.localizedDescription)
        }
    }
    
    func testInitializationFailure(){
        do{
            _ = try Recognizer(modelURL: URL(fileURLWithPath: "test"))
        }
        catch {
            XCTAssert(true)
        }
    }
    
    func recognize(strokes:[Stroke])->[Recognizer.Result]{
        let currentURL=URL(fileURLWithPath: #file).deletingLastPathComponent().deletingLastPathComponent()
        let modelURL=currentURL.appendingPathComponent("Resources", isDirectory: true).appendingPathComponent("handwriting-ja").appendingPathExtension("model")
        do{
            let recognizer = try Recognizer(modelURL: modelURL)
            recognizer.canvasSize=Recognizer.Size(width: 500, height: 500)
            recognizer.clear()
            for stroke in strokes{
                recognizer.add(stroke: stroke)
            }
            let result=recognizer.classify()
            return result
        }
        catch let error{
            XCTFail(error.localizedDescription)
        }
        return [Recognizer.Result]()
    }
    
    func testRecognize一(){
        let result=self.recognize(strokes: self.一)
        XCTAssert(result.map({$0.character}).contains("一"))
    }
    
    func testRecognize中(){
        let result=self.recognize(strokes: self.中)
        XCTAssert(result.map({$0.character}).contains("中"))
    }
    
    

    
}
