local MainCityUIForm = class("MainCityUIForm",BaseUIForm)
function MainCityUIForm:ctor(...)
    self.super.ctor(self,...)
end

function MainCityUIForm:InitUI()
    print("MainCityUIForm:InitUI")
    self:AddButtonClickEvent("BtnMarket",function()
        self:Open("MarketUIFrom")
    end)
end

return MainCityUIForm