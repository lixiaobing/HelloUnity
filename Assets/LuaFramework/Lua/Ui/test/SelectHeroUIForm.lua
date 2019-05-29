local SelectHeroUIForm = class("SelectHeroUIForm",BaseUIForm)
function SelectHeroUIForm:ctor(...)
    self.super.ctor(self,...)
end

function SelectHeroUIForm:InitUI()
    print("SelectHeroUIForm:InitUI")
    self:AddButtonClickEvent("BtnClose",function()
        self:Close()
    end)
    self:AddButtonClickEvent("BtnConfirm",function()
        self:Open("MainCityUIForm")
        self:Open("HeroInfoUIForm")
    end)


end



return SelectHeroUIForm