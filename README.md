# Zinnia-Swift

A Swift wrapper around zinnia, a library to recognize handwritten Japanese (or Chinese) characters.

For more information about zinnia, see [https://taku910.github.io/zinnia/](https://taku910.github.io/zinnia/).

Recognition requires a model file that incorporates training data. Model files can be downloaded, for example from [https://tegaki.github.io](https://tegaki.github.io).
A model file is included for unit testing.

## Installation
Use the Swift Package Manager. Add the following to your dependencies in `Package.swift`

```swift 
dependencies: [
        .package(url: /* package url */, from: "0.1.0"),
    ],
```

## How to use
To get started, initialize the `Recognizer`

```swift
let url = ... //the url of your model file
let recognizer=try? Recognizer(modelURL:url)
```
Don't forget to specify the canvas size on which the characters are being drawn.

```swift
recognizer.canvasSize = Recognizer.Size(width:500, height:500)
```
Next, add strokes to the recognizer. These would typically come from a gesture recognizer on a `UIView` or the movements of a mouse. A stroke consists of all the points between `touchesBegan(:)` and `touchesEnded(:)`.

```swift
let stroke = Stroke(points: [Point(x: 50, y: 250], Point(x:450, y: 250)])
//strokes for character 一

recognizer.add(stroke:stroke)
```

The stroke order is important. To classify strokes, use

```swift
let result = recognizer.classify()

let characters = result.map({$0.character})
//the recognized characters
```

The recognizer can be reset using 

```
recognizer.clear()
```

to start a new character.

## To Do
- [ ] Implement training
- [ ] Sample application

## Licence

zinnia (Copyright (c) 2005-2007, Taku Kudo), is BSD-licenced.

zinnia-Swift is under the MIT licence

The various model files come with their own licence.

