local LogonUIForm = class("LogonUIForm",BaseUIForm)
function LogonUIForm:ctor(...)
    self.super.ctor(self,...)
end

function LogonUIForm:InitUI()
    print("LogonUIForm:InitUI")
    self:AddButtonClickEvent("Btn_OK",function()
        self:Open("SelectHeroUIForm")
    end)
end
return LogonUIForm