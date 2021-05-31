Keyboard = class()
Keyboard.layout = nil
Keyboard.gui = nil
Keyboard.scriptedShape = nil
Keyboard.buffer = nil
Keyboard.shift = nil

function Keyboard.new(scriptedShape)
    local instance = Keyboard()
    instance.scriptedShape = scriptedShape
    instance.buffer = ""
    instance.shift = false
    instance.gui = sm.gui.createGuiFromLayout("$MOD_DATA/Gui/Keyboard.layout")
    instance.layout = {}
    local keys = "1234567890abcdefghijklmnopqrstuvwxyz-=[];'#\\,./"
    local layoutConfig = sm.json.open("$MOD_DATA/Gui/KeyboardLayouts/default.json")

    scriptedShape.gui_keyboardButtonCallback = function (shape, buttonName)
        instance:onButtonClick(buttonName)
    end

    scriptedShape.gui_keyboardCloseCallback = function (shape)
        instance:close()
    end

    for i = 1, #keys, 1 do
        local lookup = {
            default = layoutConfig.default:sub(i, i) == "#" and "##" or layoutConfig.default:sub(i, i),
            shifted = layoutConfig.shifted:sub(i, i) == "#" and "##" or layoutConfig.shifted:sub(i, i)
        }
        local k = keys:sub(i, i) == "'" and "SingleQuote" or keys:sub(i, i)
        instance.layout[k] = lookup
        instance.gui:setButtonCallback(k, "gui_keyboardButtonCallback")
    end

    instance.gui:setButtonCallback("Confirm", "gui_keyboardButtonCallback")
    instance.gui:setButtonCallback("Cancel", "gui_keyboardButtonCallback")
    instance.gui:setButtonCallback("Shift", "gui_keyboardButtonCallback")
    instance.gui:setButtonCallback("Space", "gui_keyboardButtonCallback")
    instance.gui:setButtonCallback("Backspace", "gui_keyboardButtonCallback")
    instance.gui:setOnCloseCallback("gui_keyboardCloseCallback")

    return instance
end

function Keyboard:shiftKeys()
    for k, v in pairs(self.layout) do
        self.gui:setText(k, self.shift and v.shifted or v.default)
    end

    self.gui:setButtonState("Shift", self.shift)
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
    elseif buttonName == "Shift" then
        self.shift = not self.shift
        self:shiftKeys()
    elseif buttonName == "Backspace" then
        self.buffer = self.buffer:sub(1, -2)
        self.gui:setText("Textbox", self.buffer)
    elseif buttonName == "Space" then
        self.buffer = self.buffer .. " "
        self.gui:setText("Textbox", self.buffer)
    else
        local keyToAppend

        if self.shift then
            keyToAppend = self.layout[buttonName].shifted
        else
            keyToAppend = self.layout[buttonName].default
        end

        self.buffer = self.buffer .. keyToAppend
        self.gui:setText("Textbox", self.buffer)
        self.shift = false
        self:shiftKeys()
        self.gui:setButtonState("Shift", false)
    end
end
