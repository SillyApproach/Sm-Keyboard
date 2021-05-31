# General information
This document describes what you need to do in order to use this on-screen keyboard for Scrap Mechanic.

## Including the script
In order to utilise this keyboard, you need to load the file with `dofile("path/to/Script.lua")`.
```lua
dofile("./Keyboard.lua") -- The path might differ
```

## Prerequisites for a scripted shape
A scripted shape has to provide an interface, that the keyboard depends from.  
The scripted shape must implement the `keyboardTextChangedCallback(bufferedText: string)` method.
It takes one argument of the type `string`. This method gets called, when a user clicks on the `confirm` button and gets the text from the keyboard screen passed.
The parameter `bufferedText` contains the input text.

## Creating a keyboard
A new keyboard instance needs to be created for every instance of your scripted shape.
This only needs to happen on the client. In order to create a new keyboard instance, call the `Keyboard.new(scriptedShape, title)` function.
The function expects the instance of the scripted shape that uses it as an argument and a title to display.

## Opening the keyboard
In order to open the keyboard, the `open(initialBuffer: string)` method of the keyboard has to be called.  
It takes an optional argument, with the initial text that it should display on the screen.

## Example
The following snippet shows a small script, that utilises the keyboard.

```lua
MyShape = class()

function MyShape:client_onCreate()
    self.keyboard = Keyboard.new(self, "My keyboard")
end

function MyShape:client_onInteract(character, lookingAt)
    if lookingAt then
        self.keyboard:open("My test string")
    end
end

function MyShape:keyboardTextChangedCallback(bufferedText)
    print(bufferedText)
end
```
