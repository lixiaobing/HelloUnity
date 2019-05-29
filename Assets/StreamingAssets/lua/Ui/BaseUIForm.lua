BaseUIForm = class("BaseUIForm")
function BaseUIForm:ctor(uiConfig)
    self.uiConfig     = uiConfig
    self.gameObject   = UIManager:createPanel("Prefabs/Background")
    self.mask         = self.gameObject.transform:Find("Mask")
    self.background   = self.mask:GetComponent("Image")
    self.panel        = UIManager:createPanel(self.uiConfig.prefabName)
    self.panel.transform:SetParent(self.gameObject.transform,false)
    self.luaBehaviour = self.gameObject:AddComponent(typeof(LuaFramework.LuaBehaviour))
    --初始化窗体的一些属性
    self:SetParent(UIManager:getParent(self.uiConfig.formType))
    if self.uiConfig.formType == UIFormType.PopUp 
    or self.uiConfig.formType == UIFormType.Normal then
        self.background.raycastTarget = true
        self.background.color = Color.New(0,0,0,self.uiConfig.opacity)
    else
        self.background.color = Color.New(0,0,0,0)
        self.background.raycastTarget = false
        self.background.enabled = false
    end
    --点击其他地方关闭
    self:AddClick(self.mask.gameObject,function ()
        print("xxxxxxx"..self.uiConfig.name)
        -- self:Close()
    end)
    self:InitUI()
end


function BaseUIForm:resetBackground()
    self.background.color = Color.New(0,0,0,self.uiConfig.opacity)
end


function BaseUIForm:HideBackground()
    self.background.color = Color.New(0,0,0,0)
end

function BaseUIForm:InitUI()

end

function BaseUIForm:GetName()
    return self.uiConfig.name
end

function BaseUIForm:SetParent(parent)
    self.gameObject.transform:SetParent(parent, false)
end

--当前UI窗体类型
function BaseUIForm:GetShowMode()
    return self.uiConfig.showMode
end

function BaseUIForm:GetFormType()
    return self.uiConfig.formType
end

function BaseUIForm:GetLucenyType()
    return self.uiConfig.lucenyType
end


-- --/ <summary>
-- --/ 显示状态
-- --/ </summary>
function BaseUIForm:SetActive(active)
    self.gameObject.transform:SetActive(active)
end
function BaseUIForm:Show()
    self.gameObject:SetActive(true)
    --设置模态窗体调用(必须是弹出窗体)
    -- if self.uiConfig.formType == UIFormType.PopUp then 
    --     UIManager:SetMaskWindow(self)
    -- end
end


function BaseUIForm:SetAsLastSibling()
    self.gameObject.transform:SetAsLastSibling()
end
-- 隐藏状态
function BaseUIForm:Hide()
    self.gameObject:SetActive(false)
    --取消模态窗体调用
    -- if self.uiConfig.formType == UIFormType.PopUp then 
    --     UIManager:CancelMaskWindow(self)
    -- end
end

function BaseUIForm:Close()
    UIManager:CloseUIForm(self)
end

-- <summary>
-- 重新显示状态
-- </summary>
function BaseUIForm:ReShow()
    print(self.uiConfig.name.." ReShow")
    self.gameObject:SetActive(true)
    --设置模态窗体调用(必须是弹出窗体)
    -- if self.uiConfig.formType == UIFormType.PopUp then 
    --     UIManager:SetMaskWindow(self)
    -- end
end


function BaseUIForm:Open(uiFormName)
    UIManager:OpenUIForm(uiFormName)
end


function BaseUIForm:AddButtonClickEvent(buttonName,func)
    local _transform = UnityHelper.FindChildTransForm(self.gameObject.transform, buttonName)
    if _transform then 
        self:AddClick(_transform.gameObject,func)
    end       
end
function BaseUIForm:AddClick(gameObject,func)
    self.luaBehaviour:AddClick(gameObject,func)
end



--1.UI物体，2.动画类型，3.目标值，4.持续时间，5.结束回调
function BaseUIForm:MakeUITween(go,type,target,time,comFunc)
    local tweener
    if type == 1 then
        tweener = go.transform:DOMove(target,time,nil) 
    elseif type == 2 then
        local image = go.transform:GetComponent("Image")
        tweener =  image:DOColor(target,time) 
    elseif type == 3 then
        tweener =  go.transform:DOScale(target,time)
    elseif type == TweenType.LOCAL_MOVE then
        tweener =  go.transform:DOLocalMove(target,time,false)
    elseif type == TweenType.Rect_Local_Move then
        tweener = go:GetComponent("RectTransform"):DOMove(target,time,false);
    elseif type == TweenType.Rotate then
        tweener = go.transform:DORotate(target,time);   
    elseif type == TweenType.Kill then
        if go ~= nil then
            go.transform:DOKill();
        end
    end

    if comFunc ~=nil then
        tweener:OnComplete(comFunc)
    end
    return tweener
end


--         --/ <summary>
--         --/ 冻结状态
--         --/ </summary>
-- 	    function BaseUIForm:Freeze()
--             self.gameObject.SetActive(true)
--         end



--         --/ <summary>
--         --/ 注册按钮事件
--         --/ </summary>
--         --/ <param name="buttonName">按钮节点名称</param>
--         --/ <param name="delHandle">委托：需要注册的方法</param>
-- 	    function BaseUIForm:RigisterButtonObjectEvent(string buttonName,EventTriggerListener.VoidDelegate  delHandle)
	    
--             -- local  goButton = UnityHelper.FindTheChildNode(self.gameObject, buttonName).gameObject;
--             --给按钮注册事件方法
--             -- if goButton then 
            
--                 -- EventTriggerListener.Get(goButton).onClick = delHandle;
--             -- end	    
--         end

--         --/ <summary>
--         --/ 打开UI窗体
--         --/ </summary>
--         --/ <param name="uiFormName"></param>
-- 	    function BaseUIForm:OpenUIForm(string uiFormName)
	   
--             UIManager.GetInstance().ShowUIForms(uiFormName);
--         end

--         --/ <summary>
--         --/ 关闭当前UI窗体
--         --/ </summary>
-- 	    function BaseUIForm:CloseUIForm()
	    
-- 	        -- string strUIFromName = string.Empty;            --处理后的UIFrom 名称
-- 	        -- int intPosition = -1;

--          --    strUIFromName=GetType().ToString();             --命名空间+类名
--          --    print(strUIFromName);
--          --    intPosition=strUIFromName.IndexOf('.');
--          --    if (intPosition!=-1)
--          --    
--          --        --剪切字符串中“.”之间的部分
--          --        strUIFromName = strUIFromName.Substring(intPosition + 1);
--          --    end

--          --    UIManager.GetInstance().CloseUIForms(strUIFromName);
--         end

--         --/ <summary>
--         --/ 发送消息
--         --/ </summary>
--         --/ <param name="msgType">消息的类型</param>
--         --/ <param name="msgName">消息名称</param>
--         --/ <param name="msgContent">消息内容</param>
-- 	    function BaseUIForm:SendMessage(string msgType,string msgName,object msgContent)
--             -- KeyValuesUpdate kvs = new KeyValuesUpdate(msgName,msgContent);
--             -- MessageCenter.SendMessage(msgType, kvs);	    
--         end

--         --/ <summary>
--         --/ 接收消息
--         --/ </summary>
--         --/ <param name="messagType">消息分类</param>
--         --/ <param name="handler">消息委托</param>
-- 	    function BaseUIForm:ReceiveMessage(string messagType,MessageCenter.DelMessageDelivery handler)
	
--             -- MessageCenter.AddMsgListener(messagType, handler);
-- 	    end

--         --/ <summary>
--         --/ 显示语言
--         --/ </summary>
--         --/ <param name="id"></param>


return BaseUIForm