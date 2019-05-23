local transform;
local gameObject;

MessagePanel = {};
local this = MessagePanel;

--启动事件--
function MessagePanel.Awake(obj)

	gameObject = obj;
	transform  = obj.transform;
		print(transform)
	logWarn("Awake1 lua--->>"..gameObject.name);
	this.InitPanel();
	logWarn("Awake2 lua--->>"..gameObject.name);
end

--初始化面板--
function MessagePanel.InitPanel()
	this.btnClose = transform:Find("Button").gameObject;
end
function MessagePanel.OnClick()
	logWarn("MessagePanel.OnClick---->>>");
end
--单击事件--
function MessagePanel.OnDestroy()
	logWarn("OnDestroy---->>>");
end

