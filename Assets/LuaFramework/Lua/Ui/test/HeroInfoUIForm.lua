local HeroInfoUIForm = class("HeroInfoUIForm",BaseUIForm)
function HeroInfoUIForm:ctor(...)
    self.super.ctor(self,...)
end
function HeroInfoUIForm:InitUI()
    print("HeroInfoUIForm:InitUI")
    self:AddButtonClickEvent("BtnItem1",function()
        self:Open("Tip")
    end)
end

return HeroInfoUIForm