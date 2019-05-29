using UnityEngine;
using LuaInterface;
using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine.UI;

namespace LuaFramework {
    public class LuaBehaviour : View {
        private string data = null;
        private Dictionary<string, LuaFunction> buttons = new Dictionary<string, LuaFunction>();
        private Dictionary<string, LuaFunction> listeners = new Dictionary<string, LuaFunction>();
        protected void Awake() {
            // Util.CallMethod(name, "Awake", gameObject);
            OnListenter("Awake");
        }

        protected void Start() {
            // Util.CallMethod(name, "Start");
            OnListenter("Start");

        }

        protected void OnClick() {
            // Util.CallMethod(name, "OnClick");
            OnListenter("OnClick");
        }

        protected void OnClickEvent(GameObject go) {
            OnListenter("OnClickEvent",go);
        }

        private void OnListenter(string eventType)
        {
            print(name +" " +eventType + " LuaBehaviour");
            OnListenter(eventType, null);
        }
        private void OnListenter(string eventType,GameObject go)
        {
            LuaFunction luafunc = null;
            listeners.TryGetValue(eventType, out luafunc);
            if (luafunc != null)
            {
                if(go!= null)
                {
                    luafunc.Call(go);
                }
                else
                {
                    luafunc.Call();
                }
            }
        }
        public void AddEventListener(string eventType,LuaFunction luafunc) {
            listeners.Add(eventType, luafunc);
        }

        public void RemoveEventListener(string eventType)
        {
            LuaFunction luafunc = null;
            if (listeners.TryGetValue(eventType, out luafunc))
            {
                luafunc.Dispose();
                luafunc = null;
                listeners.Remove(eventType);
            }

        }

        public void ClearEventListener()
        {
            foreach (var de in listeners)
            {
                if (de.Value != null)
                {
                    de.Value.Dispose();
                }
            }
            listeners.Clear();
        }


        /// <summary>
        /// 添加单击事件
        /// </summary>
        public void AddClick(GameObject go, LuaFunction luafunc) {
            if (go == null || luafunc == null) return;
            buttons.Add(go.name, luafunc);
            go.GetComponent<Button>().onClick.AddListener(
                delegate() {
                    luafunc.Call(go);
                }
            );
        }

        /// <summary>
        /// 删除单击事件
        /// </summary>
        /// <param name="go"></param>
        public void RemoveClick(GameObject go) {
            if (go == null) return;
            LuaFunction luafunc = null;
            if (buttons.TryGetValue(go.name, out luafunc)) {
                luafunc.Dispose();
                luafunc = null;
                buttons.Remove(go.name);
            }
        }

        /// <summary>
        /// 清除单击事件
        /// </summary>
        public void ClearClick() {
            foreach (var de in buttons) {
                if (de.Value != null) {
                    de.Value.Dispose();
                }
            }
            buttons.Clear();
        }

        //-----------------------------------------------------------------
        protected void OnDestroy() {
            ClearClick();
            ClearEventListener();
#if ASYNC_MODE
            //TODO 清理内存先注释掉
            //string abName = name.ToLower().Replace("panel", "");
            //ResManager.UnloadAssetBundle(abName + AppConst.ExtName);
#endif
            Util.ClearMemory();
            Debug.Log("~" + name + " was destroy!");
        }
    }
}