

local BaseUIForm = class("BaseUIForm")
function  BaseUIForm:ctor()
    self._CurrentUIType  = {}
end
        --字段
        -- private UIType _CurrentUIType=new UIType();

        -- 属性
        --当前UI窗体类型
	    function BaseUIForm:getCurrentUIType()
            return self._CurrentUIType
        end

        --/ <summary>
        --/ 显示状态
        --/ </summary>
	    function BaseUIForm:Display()
	    
	        self.gameObject.SetActive(true);
            --设置模态窗体调用(必须是弹出窗体)
            if self._CurrentUIType.UIForms_Type == UIFormType.PopUp then
                -- UIMaskMgr.GetInstance().SetMaskWindow(self.gameObject,_CurrentUIType.UIForm_LucencyType);
            end
	    end

        --/ <summary>
        --/ 隐藏状态
        --/ </summary>
	    function BaseUIForm:Hiding()
	    
            self.gameObject.SetActive(false);
            --取消模态窗体调用
            if self._CurrentUIType.UIForms_Type == UIFormType.PopUp then
                -- UIMaskMgr.GetInstance().CancelMaskWindow();
            end
        end

        --/ <summary>
        --/ 重新显示状态
        --/ </summary>
	    function BaseUIForm:Redisplay()
	    
            self.gameObject.SetActive(true);
            --设置模态窗体调用(必须是弹出窗体)
            if self,_CurrentUIType.UIForms_Type == UIFormType.PopUp then
                -- UIMaskMgr.GetInstance().SetMaskWindow(self.gameObject, _CurrentUIType.UIForm_LucencyType);
            end
        end

        --/ <summary>
        --/ 冻结状态
        --/ </summary>
	    function BaseUIForm:Freeze()
            self.gameObject.SetActive(true)
        end



        --/ <summary>
        --/ 注册按钮事件
        --/ </summary>
        --/ <param name="buttonName">按钮节点名称</param>
        --/ <param name="delHandle">委托：需要注册的方法</param>
	    function BaseUIForm:RigisterButtonObjectEvent(string buttonName,EventTriggerListener.VoidDelegate  delHandle)
	    
            -- local  goButton = UnityHelper.FindTheChildNode(self.gameObject, buttonName).gameObject;
            --给按钮注册事件方法
            -- if goButton then 
            
                -- EventTriggerListener.Get(goButton).onClick = delHandle;
            -- end	    
        end

        --/ <summary>
        --/ 打开UI窗体
        --/ </summary>
        --/ <param name="uiFormName"></param>
	    function BaseUIForm:OpenUIForm(string uiFormName)
	   
            UIManager.GetInstance().ShowUIForms(uiFormName);
        end

        --/ <summary>
        --/ 关闭当前UI窗体
        --/ </summary>
	    function BaseUIForm:CloseUIForm()
	    
	        -- string strUIFromName = string.Empty;            --处理后的UIFrom 名称
	        -- int intPosition = -1;

         --    strUIFromName=GetType().ToString();             --命名空间+类名
         --    print(strUIFromName);
         --    intPosition=strUIFromName.IndexOf('.');
         --    if (intPosition!=-1)
         --    
         --        --剪切字符串中“.”之间的部分
         --        strUIFromName = strUIFromName.Substring(intPosition + 1);
         --    end

         --    UIManager.GetInstance().CloseUIForms(strUIFromName);
        end

        --/ <summary>
        --/ 发送消息
        --/ </summary>
        --/ <param name="msgType">消息的类型</param>
        --/ <param name="msgName">消息名称</param>
        --/ <param name="msgContent">消息内容</param>
	    function BaseUIForm:SendMessage(string msgType,string msgName,object msgContent)
            -- KeyValuesUpdate kvs = new KeyValuesUpdate(msgName,msgContent);
            -- MessageCenter.SendMessage(msgType, kvs);	    
        end

        --/ <summary>
        --/ 接收消息
        --/ </summary>
        --/ <param name="messagType">消息分类</param>
        --/ <param name="handler">消息委托</param>
	    function BaseUIForm:ReceiveMessage(string messagType,MessageCenter.DelMessageDelivery handler)
	
            -- MessageCenter.AddMsgListener(messagType, handler);
	    end

        --/ <summary>
        --/ 显示语言
        --/ </summary>
        --/ <param name="id"></param>
	    function BaseUIForm:Show(string id)

            -- local strResult = string.Empty;
            -- strResult = LauguageMgr.GetInstance().ShowText(id);
            -- return strResult;
        end


return BaseUIForm