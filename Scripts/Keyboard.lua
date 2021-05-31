Keyboard = class()
Keyboard.layout = nil
Keyboard.gui = nil
Keyboard.scriptedShape = nil
Keyboard.buffer = nil
Keyboard.shift = nil

function Keyboard.new(scriptedShape, title)
    local instance = Keyboard()
    instance.scriptedShape = scriptedShape
    instance.buffer = ""
    instance.shift = false
    instance.gui = sm.gui.createGuiFromLayout("$MOD_DATA/Gui/Keyboard.layout")
    instance.layout = sm.json.open("$MOD_DATA/Gui/KeyboardLayouts/default.json")

    scriptedShape.gui_keyboardButtonCallback = function (shape, buttonName)
        instance:onButtonClick(buttonName)
    end

    scriptedShape.gui_keyboardCloseCallback = function (shape)
        instance:close()
    end

    for i = 1, #instance.layout.keys, 1 do
        instance.gui:setButtonCallback(tostring(i), "gui_keyboardButtonCallback")
    end

    instance.gui:setButtonCallback("Confirm", "gui_keyboardButtonCallback")
    instance.gui:setButtonCallback("Cancel", "gui_keyboardButtonCallback")
    instance.gui:setButtonCallback("Backspace", "gui_keyboardButtonCallback")
    instance.gui:setButtonCallback("Shift", "gui_keyboardButtonCallback")
    instance.gui:setButtonCallback("Space", "gui_keyboardButtonCallback")
    instance.gui:setOnCloseCallback("gui_keyboardCloseCallback")
    instance.gui:setText("Title", title)

    return instance
end

function Keyboard:shiftKeys(shift)
    self.shift = shift
    self.gui:setButtonState("Shift", shift)

    for i = 1, #self.layout.keys, 1 do
        self.gui:setText(tostring(i), shift and self.layout.keys[i][2] or self.layout.keys[i][1])
    end
end

function Keyboard:open(initialBuffer)
    self.gui:open()
    self.buffer = initialBuffer or ""
    self.gui:setText("Textbox", self.buffer)
end

function Keyboard:close()
    self.buffer = ""
    self.gui:close()
end

function Keyboard:onButtonClick(buttonName)
    if buttonName == nil then
        return
    end

    if buttonName == "Confirm" then
        self.scriptedShape:keyboardTextChangedCallback(self.buffer)
        self.gui:close()
    elseif buttonName == "Cancel" then
        self.gui:close()
    elseif buttonName == "Backspace" then
        self.buffer = self.buffer:sub(1, -2)
        self.gui:setText("Textbox", self.buffer)
    elseif buttonName == "Shift" then
        self:shiftKeys(not self.shift)
    elseif buttonName == "Space" then
        self.buffer = self.buffer .. " "
        self.gui:setText("Textbox", self.buffer)
    else
        local keyToAppend

        if self.shift then
            keyToAppend = self.layout.keys[tonumber(buttonName)][2]
            self:shiftKeys(false)
        else
            keyToAppend = self.layout.keys[tonumber(buttonName)][1]
        end

        self.buffer = self.buffer .. keyToAppend
        self.gui:setText("Textbox", self.buffer)
    end
end
