local Tip = class("Tip",BaseUIForm)
function Tip:ctor(...)
    self.super.ctor(self,...)
end
function Tip:InitUI()
    print("Tip:InitUI")
 -- 	local timer
	-- timer = Timer.New(function()
	-- 	timer:Stop()
	-- 	self:Close()
	-- end,2)
	-- timer:Start()
    -- local _transform = UnityHelper.FindChildTransForm(self.gameObject.transform, "Text")

     self:MakeUITween(self.panel, TweenType.Color, Color.New(1, 1, 1, 0.1), 1, function ( )
     	print(" 执行完成")
     end)

end

return Tip