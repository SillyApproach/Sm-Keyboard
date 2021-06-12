# General information
This document describes what you need to do in order to use this on-screen keyboard or keypad for Scrap Mechanic.

## Including the script
In order to utilise the keyboard or keypad, you need to load the file with `dofile("path/to/Script.lua")`. The path on your machine might differ.
```lua
dofile("./Keyboard.lua") -- Loading the keyboard script
dofile("./Keypad.lua") -- Loading the keypad script
```

## Prerequisites for a scripted shape
A scripted shape has to provide an interface, that the keyboard depends from.  
The scripted shape must implement the `keyboardTextChangedCallback(bufferedText: string)` method.
It takes one argument of the type `string`. This method gets called, when a user clicks on the `confirm` button and gets the text from the keyboard screen passed.
The parameter `bufferedText` contains the input text.

In order to use the keypad, the scripted shape must implement the `keypadNumberChangedCallback(bufferedNumber: number)` method.  
It behaves similarily to the keyboard. The `bufferedNumber` parameter contains the input number from the keypad.

## Creating a keyboard
A new keyboard instance needs to be created for every instance of your scripted shape.
This only needs to happen on the client. In order to create a new keyboard instance, call the `Keyboard.new(scriptedShape, title)` function.
The function expects the instance of the scripted shape that uses it as an argument and a title to display.

## Creating a keypad
Analogous to the creation of a keyboard, the keypad can be instantiated by calling the `Keypad.new(scriptedShape, title)` function.
It expects the instance of the scripted shape that uses it as the first and a title to display as the second argument.

## Opening the keyboard
In order to open the keyboard, the `open(initialBuffer: string)` method of the keyboard has to be called.  
It takes an optional argument, with the initial text that it should display on the screen.

## Opening the keypad
Similar to the keyboard, the `open(initialNumber: number)` method has to be called.  
It takes an optional argument of type `number` as the initial number to display.

## Example
The following snippet shows a small script, that utilises the keyboard.

```lua
MyShape = class()

function MyShape:client_onCreate()
    self.keyboard = Keyboard.new(self, "My keyboard")
    self.keypad = Keypad.new(self, "My keypad")
end

function MyShape:client_onInteract(character, lookingAt)
    if lookingAt then
        self.keyboard:open("My test string") -- Opens the keyboard with the inital text "My test string"
        self.keypad:open(123) -- Opens the keypad with the initial value 123
    end
end

function MyShape:keyboardTextChangedCallback(bufferedText)
    print(bufferedText)
end

function MyShape:keypadNumberChangedCallback(bufferedNumber)
    print(bufferedNumber)
end
```
