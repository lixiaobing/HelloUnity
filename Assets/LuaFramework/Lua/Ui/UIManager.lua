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
        multiple   = true 
        }  ,

        ["PropDetailUIForm"] = { 
        name       = "PropDetailUIForm" ,
        prefabName = "Prefabs/PropDetailUIForm" ,
        scriptName = "Ui/test/PropDetailUIForm" , 
        showMode = 2 , 
        formType = 3,
        opacity  = 0.5 ,--透明度
        multiple = true,  
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
        multiple = true 
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
    --正在显示的
    self._showUIForms         = {}
    for k , v in pairs(UIFormType) do
        self._showUIForms[v] = {}
    end
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


function UIManager:GetUIConfig(uiFormName)
    return UIConfigs[uiFormName]
end
function UIManager:OpenUIForm(uiFormName)
    local uiForm
    local config = self:GetUIConfig(uiFormName)   
    if not config.multiple then  --多实例的不添加到缓存 关闭时直接销毁，后续可以优化成缓存一个
        uiForm = self._DicALLUIForms[uiFormName]
        if not uiForm then
            uiForm = self:createUIForm(uiFormName)
            self._DicALLUIForms[uiFormName] = uiForm
        end
    else
        uiForm = self:createUIForm(uiFormName)
    end
    if uiForm == nil then  
        return
    end
    -- --根据不同的UI窗体的显示模式，分别作不同的加载处理
    local showMode = uiForm:GetShowMode()
    local formType = uiForm:GetFormType()
    local uiForms  = self:GetUIForms(formType)

    table.insert(uiForms, 1 ,uiForm) 
    if showMode == UIFormShowMode.Normal then                 --“普通显示”窗口模式
    elseif showMode == UIFormShowMode.ReverseChange then         --需要“反向切换”窗口模式
        self:ResetMask(uiForms)    
    elseif showMode == UIFormShowMode.HideOther then   --“隐藏其他”窗口模式
        self:HideOther(uiForms)
    end
    uiForm:Show()
end

function UIManager:CloseUIFormWithName(uiFormName)
    local config = self:GetUIConfig(uiFormName)
    -- local uiForm = self._DicALLUIForms[uiFormName]
    -- if uiForm then 
    --     self:CloseUIForm(uiForm)
    -- end
end

function UIManager:GetUIForms(formType)
    return self._showUIForms[formType]
end

function UIManager:CloseUIForm(uiForm)
    -- --根据窗体不同的显示类型，分别作不同的关闭处理
    local showMode = uiForm:GetShowMode()
    local formType = uiForm:GetFormType()
    local uiForms  = self:GetUIForms(formType)
    print("CloseUIForm:"..uiForm:GetName().." showMode:"..showMode)
    ---重显示列表移除
    for index, _uiForm in ipairs(uiForms) do
        if _uiForm == uiForm then
            table.remove(uiForms,index)
            break
        end
    end
    uiForm:Hide()
    if uiForm:IsMultiple() then 
        uiForm:Destroy()
    end
    if showMode == UIFormShowMode.ReverseChange then
        self:ResetMask(uiForms)
    elseif showMode == UIFormShowMode.HideOther then
        self:DisplayOther(uiForms)
    end
end

 

function UIManager:ResetMask(uiForms)
    local mask 
    print("UIManager:ResetMask---------------------")
    for index, uiForm in ipairs(uiForms) do
        print(uiForm:GetName()..tostring(uiForm:HasMask()))
        if not mask then 
            if uiForm:HasMask() then 
                uiForm:ResetMask()
                mask = true
            end
        else
            uiForm:HideMask()
        end
    end
end

--关闭的不是最上层的窗体 会有Bug
function UIManager:DisplayOther(uiForms)    
    for k,_uiForm in pairs(uiForms) do
        baseUI:ReShow()
    end
end

function UIManager:HideOther(uiForms)    
    for k,_uiForm in pairs(uiForms) do
        baseUI:Hide()
    end
end

UIManager:init()
