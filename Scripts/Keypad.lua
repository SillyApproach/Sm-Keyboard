Keypad = class()
Keypad.layout = nil
Keypad.gui = nil
Keypad.scriptedShape = nil
Keypad.buffer = nil
Keypad.hasDecimalPoint = nil

function Keypad.new(scriptedShape, title)
    local instance = Keypad()
    instance.scriptedShape = scriptedShape
    instance.buffer = ""
    instance.hasDecimalPoint = false
    instance.gui = sm.gui.createGuiFromLayout("$MOD_DATA/Gui/Keypad.layout")

    scriptedShape.gui_keypadButtonCallback = function (shape, buttonName)
        instance:onButtonClick(buttonName)
    end

    scriptedShape.gui_keypadCloseCallback = function (shape)
        instance:close()
    end

    for i = 0, 9, 1 do
        instance.gui:setButtonCallback(tostring(i), "gui_keypadButtonCallback")
    end

    instance.gui:setButtonCallback("Confirm", "gui_keypadButtonCallback")
    instance.gui:setButtonCallback("Cancel", "gui_keypadButtonCallback")
    instance.gui:setButtonCallback("Clear", "gui_keypadButtonCallback")
    instance.gui:setButtonCallback("Backspace", "gui_keypadButtonCallback")
    instance.gui:setButtonCallback("DecimalPoint", "gui_keypadButtonCallback")
    instance.gui:setOnCloseCallback("gui_keypadCloseCallback")
    instance.gui:setText("Title", title)

    return instance
end

function Keypad:open(initialBuffer)
    if initialBuffer ~= nil and type(initialBuffer) == "number" then
        self.buffer = tostring(initialBuffer)
        self.hasDecimalPoint = self.buffer:find(".", 1, true) ~= nil
    else
        self.buffer = "0"
    end

    self.gui:setText("Textbox", self.buffer)
    self.gui:open()
end

function Keypad:close()
    self.buffer = "0"
    self.hasDecimalPoint = false
    self.gui:close()
end

function Keypad:onButtonClick(buttonName)
    if buttonName == nil then
        return
    end

    if buttonName == "Confirm" then
        self.scriptedShape:keypadNumberChangedCallback(tonumber(self.buffer) or 0)
        self.gui:close()
    elseif buttonName == "Cancel" then
        self.gui:close()
    elseif buttonName == "Clear" then
        self.buffer = "0"
        self.hasDecimalPoint = false
    elseif buttonName == "Backspace" then
        local tempBuffer = self.buffer:sub(1, -2)

        if self.hasDecimalPoint and tempBuffer:find(".", 1, true) == nil then
            self.hasDecimalPoint = false
        end

        self.buffer = #tempBuffer > 0 and tempBuffer or "0"
    elseif buttonName == "DecimalPoint" then
        if not self.hasDecimalPoint then
            self.hasDecimalPoint = true
            self.buffer = self.buffer .. "."
        end
    else
        if self.buffer == "0" then
            self.buffer = buttonName
        else
            self.buffer = self.buffer .. buttonName
        end
    end

    self.gui:setText("Textbox", self.buffer)
end
