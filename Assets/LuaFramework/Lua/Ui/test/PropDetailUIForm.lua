local PropDetailUIForm = class("PropDetailUIForm",BaseUIForm)
function PropDetailUIForm:ctor(...)
    self.super.ctor(self,...)
end

function PropDetailUIForm:InitUI()
    print("PropDetailUIForm:InitUI")
    self:AddButtonClickEvent("BtnClose",function()
        self:Close()
    end)
end


return PropDetailUIForm