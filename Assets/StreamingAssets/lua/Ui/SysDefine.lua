
UIFormType =
{

    Normal= 1,        --普通窗体
                            
    Fixed = 2,        --固定窗体    

    PopUp = 3,        --弹出窗体

    Tip   = 4,        --提示
}
    --/ <summary>
    --/ UI窗体的显示类型
    --/ </summary>
UIFormShowMode =
{
    --普通
    Normal       = 1 ,
    --反向切换
    ReverseChange= 2 ,
    --隐藏其他
    HideOther    = 3
}

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
    -- --可以穿透
    -- Pentrate    = 4   
}

--UI动画
TweenType = {               --动画类型
    Move = 1,               --移动
    Color = 2,              --颜色渐变
    Scale = 3,              --缩放
    LOCAL_MOVE = 4,         --local移动
    Rotate = 5,             --旋转
    Kill   =6,              --结束Tween
    Rect_Local_Move = 7,    --rect local移动
}



SysDefine = {

    -- 节点常量 */
    SYS_NORMAL_NODE = "Normal",
    SYS_FIXED_NODE  = "Fixed",
    SYS_POPUP_NODE  = "PopUp",
    SYS_TIP_NODE    = "Tip", 

    -- 路径常量 */
    SYS_PATH_CANVAS = "Canvas",
    SYS_PATH_UIFORMS_CONFIG_INFO = "UIFormsConfigInfo",
    SYS_PATH_CONFIG_INFO = "SysConfigInfo",

    -- 标签常量 */
    SYS_TAG_CANVAS = "_TagCanvas",


    -- 遮罩管理器中，透明度常量 */
    SYS_UIMASK_LUCENCY_COLOR_RGB = 255 / 255,
    SYS_UIMASK_LUCENCY_COLOR_RGB_A = 0 / 255,

    SYS_UIMASK_TRANS_LUCENCY_COLOR_RGB = 220 / 255,
    SYS_UIMASK_TRANS_LUCENCY_COLOR_RGB_A = 50 / 255,

    SYS_UIMASK_IMPENETRABLE_COLOR_RGB = 50 / 255,
    SYS_UIMASK_IMPENETRABLE_COLOR_RGB_A = 200/ 255,


}
