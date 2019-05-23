require "Common/define"


-- UI窗体（位置）类型
 
UIFormType =
{

    Normal= 1,        --普通窗体
                            
    Fixed = 2,        --固定窗体    

    PopUp = 3         --弹出窗体
end
    --/ <summary>
    --/ UI窗体的显示类型
    --/ </summary>
UIFormShowMode =
{
    --普通
    Normal = 1,
    --反向切换
    ReverseChange=2 ,
    --隐藏其他
    HideOther= 3
end

    --/ <summary>
    --/ UI窗体透明度类型
UIFormLucenyType = 
{
    --完全透明，不能穿透
    Lucency     = 1,
    --半透明，不能穿透
    Translucence= 2,
    --低透明度，不能穿透
    ImPenetrable= 3,
    --可以穿透
    Pentrate    = 4   
end




local UIManager = class("UIManager")

function UIManager:ctor()
    -- body
end
        -- /* 字段 */
        -- private static UIManager _Instance = null;
        -- --UI窗体预设路径(参数1：窗体预设名称，2：表示窗体预设路径)
        -- private Dictionary<string, string> self._DicFormsPaths; 
        -- --缓存所有UI窗体
        -- private Dictionary<string, BaseUIForm> self._DicALLUIForms;
        -- --当前显示的UI窗体
        -- private Dictionary<string, BaseUIForm> self._DicCurrentShowUIForms;
        -- --定义“栈”集合,存储显示当前所有[反向切换]的窗体类型
        -- private Stack<BaseUIForm> self._StaCurrentUIForms;  
        -- --UI根节点
        -- private Transform self._TraCanvasTransfrom = null;
        -- --全屏幕显示的节点
        -- private Transform self._TraNormal = null;
        -- --固定显示的节点
        -- private Transform self._TraFixed = null;
        -- --弹出节点
        -- private Transform self._TraPopUp = null;
        -- --UI管理脚本的节点
        -- private Transform self._TraUIScripts = null;


        --/ <summary>
        --/ 得到实例
        --/ </summary>
        --/ <returns></returns>
        function UIManager.GetInstance()
            if not _Instance then 
                _Instance = UIManager.new()
            end
            return _Instance
        end

        --初始化核心数据，加载“UI窗体路径”到集合中。
        function UIManager:ctor()
     
            --字段初始化
            self._DicALLUIForms         ={}
            self._DicCurrentShowUIForms = {}
            self._DicFormsPaths         = {} 
            self._StaCurrentUIForms     = {}
            --初始化加载（根UI窗体）Canvas预设
            self:InitRootCanvasLoading()
            --得到UI根节点、全屏节点、固定节点、弹出节点
            self._TraCanvasTransfrom = GameObject.FindGameObjectWithTag(SysDefine.SYS_TAG_CANVAS).transform;
            self._TraNormal     = UnityHelper.FindTheChildNode(self._TraCanvasTransfrom.gameObject, SysDefine.SYS_NORMAL_NODE);
            self._TraFixed      = UnityHelper.FindTheChildNode(self._TraCanvasTransfrom.gameObject, SysDefine.SYS_FIXED_NODE);
            self._TraPopUp      = UnityHelper.FindTheChildNode(self._TraCanvasTransfrom.gameObject, SysDefine.SYS_POPUP_NODE);
            self._TraUIScripts  = UnityHelper.FindTheChildNode(self._TraCanvasTransfrom.gameObject,SysDefine.SYS_SCRIPTMANAGER_NODE);

            --把本脚本作为“根UI窗体”的子节点。
            self.gameObject.transform.SetParent(self._TraUIScripts, false)
            --"根UI窗体"在场景转换的时候，不允许销毁
            self:DontDestroyOnLoad(self._TraCanvasTransfrom)
            --初始化“UI窗体预设”路径数据
            self:InitUIFormsPathData()
        end

        --/ <summary>
        --/ 显示（打开）UI窗体
        --/ 功能：
        --/ 1: 根据UI窗体的名称，加载到“所有UI窗体”缓存集合中
        --/ 2: 根据不同的UI窗体的“显示模式”，分别作不同的加载处理
        --/ </summary>
        --/ <param name="uiFormName">UI窗体预设的名称</param>
        function UIManager:ShowUIForms(string uiFormName)
     
            local baseUIForms                     --UI窗体基类

            --参数的检查
            -- if (string.IsNullOrEmpty(uiFormName)) return;

            --根据UI窗体的名称，加载到“所有UI窗体”缓存集合中
            baseUIForms = self:LoadFormsToAllUIFormsCatch(uiFormName);
            if baseUIForms == nil then  
                return
            end
            --是否清空“栈集合”中得数据
            if baseUIForms.CurrentUIType.IsClearStack then 
                self:ClearStackArray()
            end

            --根据不同的UI窗体的显示模式，分别作不同的加载处理
    
            local  UIForms_ShowMode = baseUIForms.CurrentUIType.UIForms_ShowMode
                             
            if UIForms_ShowMode == UIFormShowMode.Normal then                 --“普通显示”窗口模式
                    --把当前窗体加载到“当前窗体”集合中。
                    self:LoadUIToCurrentCache(uiFormName)
            elseif UIForms_ShowMode == UIFormShowMode.ReverseChange then         --需要“反向切换”窗口模式
                    self:PushUIFormToStack(uiFormName)
   
            elseif UIForms_ShowMode == UIFormShowMode.HideOther then              --“隐藏其他”窗口模式
                    self:EnterUIFormsAndHideOther(uiFormName);
            end
        end

        --/ <summary>
        --/ 关闭（返回上一个）窗体
        --/ </summary>
        --/ <param name="uiFormName"></param>
        function UIManager:CloseUIForms(string uiFormName)
      
            local baseUiForm;                          --窗体基类

            --参数检查
            -- if (string.IsNullOrEmpty(uiFormName)) return;
            --“所有UI窗体”集合中，如果没有记录，则直接返回
            baseUiForm = self._DicALLUIForms[uiFormName]
            if not baseUiForm then 
                return
            end
            --根据窗体不同的显示类型，分别作不同的关闭处理
            local UIForms_ShowMode  = baseUiForm.CurrentUIType.UIForms_ShowMode
            if UIForms_ShowMode == UIFormShowMode.Normal then
                --普通窗体的关闭
                self:ExitUIForms(uiFormName)
            if UIForms_ShowMode == UIFormShowMode.ReverseChange then
                --反向切换窗体的关闭
                self:PopUIFroms()
            if UIForms_ShowMode == UIFormShowMode.HideOther then
                --隐藏其他窗体关闭
                self:ExitUIFormsAndDisplayOther(uiFormName) then
            end
        end

   
        
        --/ <summary>
        --/ 显示"所有UI窗体"集合的数量
        --/ </summary>
        --/ <returns></returns>
        function UIManager:ShowALLUIFormCount()
     
            if self._DicALLUIForms then 
                return table.count(self._DicALLUIForms)
            else 
                return 0
            end   
        end

        --/ <summary>
        --/ 显示"当前窗体"集合中数量
        --/ </summary>
        --/ <returns></returns>
        function UIManager:ShowCurrentUIFormsCount()
            if self._DicCurrentShowUIForms then
                return table.count(self._DicCurrentShowUIForms.Count)
            else
                return 0
            end           
        end

        --/ <summary>
        --/ 显示“当前栈”集合中窗体数量
        --/ </summary>
        --/ <returns></returns>
        function UIManager:ShowCurrentStackUIFormsCount()
            if self._StaCurrentUIForms  then
                return table.count(self._StaCurrentUIForms)
            else
                return 0
            end           
        end

        function UIManager:InitRootCanvasLoading()
            -- ResourcesMgr.GetInstance().LoadAsset(SysDefine.SYS_PATH_CANVAS, false);
        end

        --/ <summary>
        --/ 根据UI窗体的名称，加载到“所有UI窗体”缓存集合中
        --/ 功能： 检查“所有UI窗体”集合中，是否已经加载过，否则才加载。
        --/ </summary>
        --/ <param name="uiFormsName">UI窗体（预设）的名称</param>
        --/ <returns></returns>
         function UIManager:LoadFormsToAllUIFormsCatch(string uiFormsName)
            local baseUIResult                 --加载的返回UI窗体基类
            baseUIResult = self._DicALLUIForms[uiFormsName]
            if not baseUIResult then
         
                --加载指定名称的“UI窗体”
                baseUIResult = LoadUIForm(uiFormsName);
            end

            return baseUIResult;
        end

        --/ <summary>
        --/ 加载指定名称的“UI窗体”
        --/ 功能：
        --/    1：根据“UI窗体名称”，加载预设克隆体。
        --/    2：根据不同预设克隆体中带的脚本中不同的“位置信息”，加载到“根窗体”下不同的节点。
        --/    3：隐藏刚创建的UI克隆体。
        --/    4：把克隆体，加入到“所有UI窗体”（缓存）集合中。
        --/ 
        --/ </summary>
        --/ <param name="uiFormName">UI窗体名称</param>
        private BaseUIForm LoadUIForm(string uiFormName)
     
            string strUIFormPaths = null;                   --UI窗体路径
            GameObject goCloneUIPrefabs = null;             --创建的UI克隆体预设
            BaseUIForm baseUiForm=null;                     --窗体基类


            --根据UI窗体名称，得到对应的加载路径
            self._DicFormsPaths.TryGetValue(uiFormName, out strUIFormPaths);
            --根据“UI窗体名称”，加载“预设克隆体”
            if (!string.IsNullOrEmpty(strUIFormPaths))
         
                goCloneUIPrefabs = ResourcesMgr.GetInstance().LoadAsset(strUIFormPaths, false);
            end
            --设置“UI克隆体”的父节点（根据克隆体中带的脚本中不同的“位置信息”）
            if (self._TraCanvasTransfrom != null && goCloneUIPrefabs != null)
         
                baseUiForm = goCloneUIPrefabs.GetComponent<BaseUIForm>();
                if (baseUiForm == null)
             
                    Debug.Log("baseUiForm==null! ,请先确认窗体预设对象上是否加载了baseUIForm的子类脚本！ 参数 uiFormName=" + uiFormName);
                    return null;
                end
                switch (baseUiForm.CurrentUIType.UIForms_Type)
             
                if UIForms_ShowMode == UIFormType.Normal:                 --普通窗体节点
                        goCloneUIPrefabs.transform.SetParent(self._TraNormal, false);
                        break;
                if UIForms_ShowMode == UIFormType.Fixed:                  --固定窗体节点
                        goCloneUIPrefabs.transform.SetParent(self._TraFixed, false);
                        break;
                if UIForms_ShowMode == UIFormType.PopUp:                  --弹出窗体节点
                        goCloneUIPrefabs.transform.SetParent(self._TraPopUp, false);
                        break;
                    default:
                        break;
                end

                --设置隐藏
                goCloneUIPrefabs.SetActive(false);
                --把克隆体，加入到“所有UI窗体”（缓存）集合中。
                self._DicALLUIForms.Add(uiFormName, baseUiForm);
                return baseUiForm;
            end
            else
         
                Debug.Log("self._TraCanvasTransfrom==null Or goCloneUIPrefabs==null!! ,Plese Check!, 参数uiFormName="+uiFormName); 
            end

            Debug.Log("出现不可以预估的错误，请检查，参数 uiFormName="+uiFormName);
            return null;
        end--Mehtod_end

        --/ <summary>
        --/ 把当前窗体加载到“当前窗体”集合中
        --/ </summary>
        --/ <param name="uiFormName">窗体预设的名称</param>
        function UIManager:LoadUIToCurrentCache(string uiFormName)
     
            BaseUIForm baseUiForm;                          --UI窗体基类
            BaseUIForm baseUIFormFromAllCache;              --从“所有窗体集合”中得到的窗体

            --如果“正在显示”的集合中，存在整个UI窗体，则直接返回
            self._DicCurrentShowUIForms.TryGetValue(uiFormName, out baseUiForm);
            if (baseUiForm != null) return;
            --把当前窗体，加载到“正在显示”集合中
            self._DicALLUIForms.TryGetValue(uiFormName, out baseUIFormFromAllCache);
            if (baseUIFormFromAllCache!=null)
         
                self._DicCurrentShowUIForms.Add(uiFormName, baseUIFormFromAllCache);
                baseUIFormFromAllCache.Display();           --显示当前窗体
            end
        end
 
        --/ <summary>
        --/ UI窗体入栈
        --/ </summary>
        --/ <param name="uiFormName">窗体的名称</param>
        function UIManager:PushUIFormToStack(string uiFormName)
      
            BaseUIForm baseUIForm;                          --UI窗体

            --判断“栈”集合中，是否有其他的窗体，有则“冻结”处理。
            if(self._StaCurrentUIForms.Count>0)
         
                BaseUIForm topUIForm=self._StaCurrentUIForms.Peek();
                --栈顶元素作冻结处理
                topUIForm.Freeze();
            end
            --判断“UI所有窗体”集合是否有指定的UI窗体，有则处理。
            self._DicALLUIForms.TryGetValue(uiFormName, out baseUIForm);
            if (baseUIForm!=null)
         
                --当前窗口显示状态
                baseUIForm.Display();
                --把指定的UI窗体，入栈操作。
                self._StaCurrentUIForms.Push(baseUIForm);
            endelse{
                Debug.Log("baseUIForm==null,Please Check, 参数 uiFormName=" + uiFormName);
            end
        end

        --/ <summary>
        --/ 退出指定UI窗体
        --/ </summary>
        --/ <param name="strUIFormName"></param>
        function UIManager:ExitUIForms(string strUIFormName)
      
            BaseUIForm baseUIForm;                          --窗体基类

            --"正在显示集合"中如果没有记录，则直接返回。
            self._DicCurrentShowUIForms.TryGetValue(strUIFormName, out baseUIForm);
            if(baseUIForm==null) return ;
            --指定窗体，标记为“隐藏状态”，且从"正在显示集合"中移除。
            baseUIForm.Hiding();
            self._DicCurrentShowUIForms.Remove(strUIFormName);
        end

        --（“反向切换”属性）窗体的出栈逻辑
        function UIManager:PopUIFroms()
      
            if(self._StaCurrentUIForms.Count>=2)
         
                --出栈处理
                BaseUIForm topUIForms = self._StaCurrentUIForms.Pop();
                --做隐藏处理
                topUIForms.Hiding();
                --出栈后，下一个窗体做“重新显示”处理。
                BaseUIForm nextUIForms = self._StaCurrentUIForms.Peek();
                nextUIForms.Redisplay();
            end
            else if (self._StaCurrentUIForms.Count ==1)
         
                --出栈处理
                BaseUIForm topUIForms = self._StaCurrentUIForms.Pop();
                --做隐藏处理
                topUIForms.Hiding();
            end
        end

        --/ <summary>
        --/ (“隐藏其他”属性)打开窗体，且隐藏其他窗体
        --/ </summary>
        --/ <param name="strUIName">打开的指定窗体名称</param>
        function UIManager:EnterUIFormsAndHideOther(string strUIName)
      
            BaseUIForm baseUIForm;                          --UI窗体基类
            BaseUIForm baseUIFormFromALL;                   --从集合中得到的UI窗体基类


            --参数检查
            if (string.IsNullOrEmpty(strUIName)) return;

            self._DicCurrentShowUIForms.TryGetValue(strUIName, out baseUIForm);
            if (baseUIForm != null) return;

            --把“正在显示集合”与“栈集合”中所有窗体都隐藏。
            foreach (BaseUIForm baseUI in self._DicCurrentShowUIForms.Values)
         
                baseUI.Hiding();
            end
            foreach (BaseUIForm staUI in self._StaCurrentUIForms)
         
                staUI.Hiding();
            end

            --把当前窗体加入到“正在显示窗体”集合中，且做显示处理。
            self._DicALLUIForms.TryGetValue(strUIName, out baseUIFormFromALL);
            if (baseUIFormFromALL!=null)
         
                self._DicCurrentShowUIForms.Add(strUIName, baseUIFormFromALL);
                --窗体显示
                baseUIFormFromALL.Display();
            end
        end

        --/ <summary>
        --/ (“隐藏其他”属性)关闭窗体，且显示其他窗体
        --/ </summary>
        --/ <param name="strUIName">打开的指定窗体名称</param>
        function UIManager:ExitUIFormsAndDisplayOther(string strUIName)
     
            BaseUIForm baseUIForm;                          --UI窗体基类


            --参数检查
            if (string.IsNullOrEmpty(strUIName)) return;

            self._DicCurrentShowUIForms.TryGetValue(strUIName, out baseUIForm);
            if (baseUIForm == null) return;

            --当前窗体隐藏状态，且“正在显示”集合中，移除本窗体
            baseUIForm.Hiding();
            self._DicCurrentShowUIForms.Remove(strUIName);

            --把“正在显示集合”与“栈集合”中所有窗体都定义重新显示状态。
            foreach (BaseUIForm baseUI in self._DicCurrentShowUIForms.Values)
         
                baseUI.Redisplay();
            end
            foreach (BaseUIForm staUI in self._StaCurrentUIForms)
         
                staUI.Redisplay();
            end
        end

        --/ <summary>
        --/ 是否清空“栈集合”中得数据
        --/ </summary>
        --/ <returns></returns>
        private bool ClearStackArray()
     
            if (self._StaCurrentUIForms != null && self._StaCurrentUIForms.Count>=1)
         
                --清空栈集合
                self._StaCurrentUIForms.Clear();
                return true;
            end

            return false;
        end

        --/ <summary>
        --/ 初始化“UI窗体预设”路径数据
        --/ </summary>
        function UIManager:InitUIFormsPathData()
     
            IConfigManager configMgr = new ConfigManagerByJson(SysDefine.SYS_PATH_UIFORMS_CONFIG_INFO);
            if (configMgr!=null)
         
                self._DicFormsPaths = configMgr.AppSetting;
            end
        end

        #endregion

    end--class_end
end