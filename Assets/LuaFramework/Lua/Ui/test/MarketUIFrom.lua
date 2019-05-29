local MarketUIFrom = class("MarketUIFrom",BaseUIForm)
function MarketUIFrom:ctor(...)
    self.super.ctor(self,...)
end

function MarketUIFrom:InitUI()
    print("MarketUIFrom:InitUI")
    self:AddButtonClickEvent("Btn_Close",function()
        self:Close()
    end)
    self:AddButtonClickEvent("BtnShoe",function()
        self:Open("PropDetailUIForm")
    end)
end


return MarketUIFrom