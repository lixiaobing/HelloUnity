require "Common/define"

require "Ui/SysDefine"

require "Ui/UnityHelper"


-- UI窗体（位置）类型
 
local UIConfigs = 
{
    ["Logon"] = { 
        name = "Logon" ,
        prefabName = "Prefabs/LogonUIForm" ,
        scriptName = "Ui/test/LogonUIForm" , 
        showMode   = 1 , 
        formType   = 1 , 
        opacity    = 0 ,--透明度 
        },

    ["SelectHeroUIForm"] = { 
        name = "SelectHeroUIForm" ,
        prefabName = "Prefabs/SelectHeroUIForm" ,
        scriptName = "Ui/test/SelectHeroUIForm" , 
        showMode   = 1 , 
        formType   = 1,
        opacity    = 0 ,--透明度 
        }  ,

    ["MainCityUIForm"] = { 
        name = "MainCityUIForm" ,
        prefabName = "Prefabs/MainCityUIForm" ,
        scriptName = "Ui/test/MainCityUIForm" , 
        showMode = 1 , 
        formType = 1 ,
        opacity    = 0.5 ,--透明度 
        } ,


        ["MarketUIFrom"] = { 
        name = "MarketUIFrom" ,
        prefabName = "Prefabs/MarketUIFrom" ,
        scriptName = "Ui/test/MarketUIFrom" , 
        showMode   = 2 , 
        formType   = 3 ,
        opacity    = 0.5 ,--透明度 
        }  ,

        ["PropDetailUIForm"] = { 
        name       = "PropDetailUIForm" ,
        prefabName = "Prefabs/PropDetailUIForm" ,
        scriptName = "Ui/test/PropDetailUIForm" , 
        showMode = 2 , 
        formType = 3,
        opacity  = 0.5 ,--透明度 
        } ,

        ["HeroInfoUIForm"] = { 
        name = "HeroInfoUIForm" ,
        prefabName = "Prefabs/HeroInfoUIForm" ,
        scriptName = "Ui/test/HeroInfoUIForm" , 
        showMode = 2 , 
        formType = 2 ,
        opacity  = 0 ,--透明度 
        },

        ["Tip"] = { 
        name = "Tip" ,
        prefabName = "Prefabs/Tips" ,
        scriptName = "Ui/test/Tip" , 
        showMode = 1 , 
        formType = 4 ,
        opacity  = 0 ,--透明度 
        }  

}



UIManager = {}
function UIManager:Instance()
    return self
end
--初始化核心数据，加载“UI窗体路径”到集合中。
function UIManager:init()
    --字段初始化
    self._DicALLUIForms         = {}
    self._DicCurrentShowUIForms = {}
    self._StaCurrentUIForms     = {}
    --初始化加载（根UI窗体）Canvas预设
    --self:InitRootCanvasLoading()
    --得到UI根节点、全屏节点、固定节点、弹出节点
    self._TraCanvas          = GameObject.FindGameObjectWithTag(SysDefine.SYS_TAG_CANVAS)
    UnityEngine.Object.DontDestroyOnLoad(self._TraCanvas.transform)
    self.transNodes = {}
    self.transNodes[UIFormType.Normal]     = UnityHelper.FindTheChildNode(self._TraCanvas, SysDefine.SYS_NORMAL_NODE);
    self.transNodes[UIFormType.Fixed]      = UnityHelper.FindTheChildNode(self._TraCanvas, SysDefine.SYS_FIXED_NODE);
    self.transNodes[UIFormType.PopUp]      = UnityHelper.FindTheChildNode(self._TraCanvas, SysDefine.SYS_POPUP_NODE);  
    self.transNodes[UIFormType.Tip]        = UnityHelper.FindTheChildNode(self._TraCanvas, SysDefine.SYS_TIP_NODE); 
    local tansCamera = UnityHelper.FindTheChildNode(self._TraCanvas, "GuiCamera")
    self.camera            = tansCamera:GetComponent(typeof(UnityEngine.Camera))


end

local MaskColors ={
    [UIFormLucenyType.Lucency]     = Color.New(0,0,0,0)  ,
    [UIFormLucenyType.Translucence]= Color.New(0,0,0,0.5),
    [UIFormLucenyType.ImPenetrable]= Color.New(0,0,0,0.8),
}


function UIManager:getParent(formType)
    return self.transNodes[formType]
end

function UIManager:createUIForm(uiFormName)
    local data        = UIConfigs[uiFormName]
    print("createUIForm:"..uiFormName.." prefab:" ..data.prefabName.." scriptName:"..data.scriptName)
    local ClassUIForm = require(data.scriptName)
    local uiForm      = ClassUIForm.new(data)
    return uiForm

end--Mehtod_end



function UIManager:createPanel(prefabName)
    print("createPanel:"..tostring(prefabName))
    local prefab = UnityEngine.Resources.Load(prefabName,typeof(UnityEngine.GameObject))
    return GameObject.Instantiate(prefab)
end


-- function UIManager:onShowUIForm(uiForm)
--     local showMode = uiForm:GetShowMode()
--     if showMode == UIFormShowMode.Normal then                    --“普通显示”窗口模式
--         self._DicCurrentShowUIForms[uiForm:GetName()] = uiForm
--     elseif showMode == UIFormShowMode.ReverseChange then         --需要“反向切换”窗口模式
--         table.insert(self._StaCurrentUIForms, 1 ,uiForm)
--     elseif showMode == UIFormShowMode.HideOther then              --“隐藏其他”窗口模式
--         for k , v in pairs(self._DicCurrentShowUIForms) do
--             v:Hide()
--         end
--         for k , v in pairs(self._StaCurrentUIForms) do
--             v:Hide()
--         end
--     end
-- end

function UIManager:GetUIConfig(uiFormName)
    return UIConfigs[uiFormName]
end

-- function UIManager:ShowUIForm(uiFormName)
--     --根据UI窗体的名称，加载到“所有UI窗体”缓存集合中
--     local uiForm = self._DicALLUIForms[uiFormName]
--     if not uiForm then
--         uiForm = self:createUIForm(uiFormName)
--         self._DicALLUIForms[uiFormName] = uiForm
--     end
--     if uiForm == nil then  
--         return
--     end
--     uiForm:Show()
-- end

function UIManager:OpenUIForm(uiFormName)
    --根据UI窗体的名称，加载到“所有UI窗体”缓存集合中
    local uiForm = self._DicALLUIForms[uiFormName]
    if not uiForm then
        uiForm = self:createUIForm(uiFormName)
        self._DicALLUIForms[uiFormName] = uiForm
    end
    if uiForm == nil then  
        return
    end
    uiForm:Show()
    -- --根据不同的UI窗体的显示模式，分别作不同的加载处理
    local showMode = uiForm:GetShowMode()
    if showMode == UIFormShowMode.Normal then                 --“普通显示”窗口模式
        --把当前窗体加载到“当前窗体”集合中。
        self._DicCurrentShowUIForms[uiForm:GetName()] = uiForm
    elseif showMode == UIFormShowMode.ReverseChange then         --需要“反向切换”窗口模式
        for i,v in ipairs(self._StaCurrentUIForms) do
            v:HideBackground()
        end
        table.insert(self._StaCurrentUIForms, 1 ,uiForm)     
    elseif showMode == UIFormShowMode.HideOther then              --“隐藏其他”窗口模式
        for k , v in pairs(self._DicCurrentShowUIForms) do
            v:Hide()
        end
        for k , v in pairs(self._StaCurrentUIForms) do
            v:Hide()
        end
    end

end
function UIManager:CloseUIFormWithName(uiFormName)
    local uiForm = self._DicALLUIForms[uiFormName]
    if uiForm then 
        self:CloseUIForm(uiForm)
    end
end
function UIManager:CloseUIForm(uiForm)
    -- --根据窗体不同的显示类型，分别作不同的关闭处理
    local showMode = uiForm:GetShowMode()
    print("CloseUIForm:"..uiForm:GetName().." showMode:"..showMode)
    if showMode == UIFormShowMode.Normal then
        --普通窗体的关闭
       self:ExitUIForms(uiForm)
    elseif showMode == UIFormShowMode.ReverseChange then
       --反向切换窗体的关闭
        self:PopUIFroms(uiForm)
    elseif showMode == UIFormShowMode.HideOther then
    --     --隐藏其他窗体关闭
        self:ExitUIFormsAndDisplayOther(uiForm)
    end
end

--把当前窗体加载到“当前窗体”集合中
function UIManager:AddToCurrentShow(baseUiForm)
    self._DicCurrentShowUIForms[baseUiForm:GetName()] = baseUiForm
end
 
--指定窗体，标记为“隐藏状态”，且从"正在显示集合"中移除。
function UIManager:ExitUIForms(uiForm)
    uiForm:Hide()
    self._DicCurrentShowUIForms[uiForm:GetName()] = nil
end

--（“反向切换”属性）窗体的出栈逻辑
function UIManager:PopUIFroms(uiForm)
    uiForm:Hide()
    for index, _uiForm in ipairs(self._StaCurrentUIForms) do
        if _uiForm == uiForm then
            table.remove(self._StaCurrentUIForms,index)
            break
        end
    end
    if self._StaCurrentUIForms[1] then 
        self._StaCurrentUIForms[1]:resetBackground()
    end

end

function UIManager:ExitUIFormsAndDisplayOther(uiForm)     
    uiForm:Hide()
    --当前窗体隐藏状态，且“正在显示”集合中，移除本窗体
    self._DicCurrentShowUIForms[uiForm:GetName()] = nil
    --把“正在显示集合”与“栈集合”中所有窗体都定义重新显示状态。
    for k,baseUI in pairs(self._DicCurrentShowUIForms) do
        baseUI:ReShow()
    end
    for k,baseUI in pairs(self._StaCurrentUIForms) do
        baseUI:ReShow()
    end
end

UIManager:init()
