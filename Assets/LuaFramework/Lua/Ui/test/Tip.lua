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

     -- self:MakeUITween(self.panel, TweenType.Color, Color.New(1, 1, 1, 0.1), 1)

     -- self:MakeUITween(self.panel, TweenType.LOCAL_MOVE, Vector2(0, 150), 1, nil)

     self:MakeUITween(self.panel, TweenType.Scale, Vector3.New(1.1, 1.1, 1), 1, function()
     		print("Scale complete")
     end)


-- LuaException: Delegate DG.Tweening.TweenCallback not register
-- stack traceback:
-- 	[C]: in function 'OnComplete'
-- 	Ui/BaseUIForm:149: in function 'MakeUITween'
-- 	Ui/test/Tip:19: in function 'InitUI'
-- 	Ui/BaseUIForm:26: in function 'ctor'
-- 	Ui/test/Tip:3: in function 'ctor'
-- 	Common/functions:121: in function 'new'
-- 	Ui/UIManager:121: in function 'createUIForm'
-- 	Ui/UIManager:172: in function 'OpenUIForm'
-- 	Ui/BaseUIForm:110: in function 'Open'
-- 	Ui/test/HeroInfoUIForm:8: in function <Ui/test/HeroInfoUIForm:7>
-- LuaInterface.DelegateTraits`1:Create(LuaFunction) (at Assets/LuaFramework/ToLua/Core/TypeTraits.cs:179)
-- LuaInterface.ToLua:CheckDelegate(IntPtr, Int32) (at Assets/LuaFramework/ToLua/Core/ToLua.cs:2894)
-- DG_Tweening_TweenerWrap:OnComplete(IntPtr) (at Assets/LuaFramework/ToLua/Source/Generate/DG_Tweening_TweenerWrap.cs:359)
-- LuaInterface.LuaDLL:lua_pcall(IntPtr, Int32, Int32, Int32)
-- LuaInterface.LuaState:PCall(Int32, Int32) (at Assets/LuaFramework/ToLua/Core/LuaState.cs:753)
-- LuaInterface.LuaFunction:PCall() (at Assets/LuaFramework/ToLua/Core/LuaFunction.cs:96)
-- LuaInterface.LuaFunction:Call(GameObject) (at Assets/LuaFramework/ToLua/Core/LuaFunction.cs:128)
-- LuaFramework.<AddClick>c__AnonStorey0:<>m__0() (at Assets/LuaFramework/Scripts/Common/LuaBehaviour.cs:91)
-- UnityEngine.EventSystems.EventSystem:Update()

end

return Tip