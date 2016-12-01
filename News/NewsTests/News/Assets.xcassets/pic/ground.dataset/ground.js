// 与native交互实现
function init_native() {
    var toString = function (v) {
        return Object.prototype.toString.call(v);
    },
    isFunction = function (v) {
        return toString(v) === '[object Function]';
    },
    athene = {},
    CALLBACK_PREFIX = 'callback__',
    callbacks = {},
    callbackCount = 0,
    CallbackStatus = {
        OK : 1
    };
    athene.exec = function (success, fail, service, action, params) {
        var callbackId = CALLBACK_PREFIX + callbackCount++;
        callbacks[callbackId] = {
            success : success,
            fail : fail
        };
        params = Array.prototype.concat.call([], callbackId, params || []);
        action.apply(service, params);
    };
    athene.complete = function () {
        if (arguments.length < 2) {
            throw new Error('Missing essential arguments');
        }
        var callbackId = arguments[0],
        status = arguments[1],
        callback = callbacks[callbackId],
        params = Array.prototype.slice
        .call(arguments, 2),
        success,
        fail;
        for (var i = 0; i < params.length; i++) {
            params[i] = decodeURIComponent(params[i].replace(/\+/g, '%20'));
            //  params[i] = JSON.parse(params[i]);
            // console.log(params[i].url);
        }
        delete callbacks[callbackId];
        if (!callback) {
            return;
        }
        success = callback.success;
        fail = callback.fail;
        if (status == CallbackStatus.OK && isFunction(success)) {
            success.apply(null, params);
            //console.log('success params= '+ params[0]);
        } else if (isFunction(fail)) {
            fail.apply(null, params);
        }
    }
    window['athene'] = athene;
};

// ground 接口
function android_init() {
    init_native();
    var ground = {
        //跳转类型 ， 跳转地址 ，   跳转来源种类（不可不填）， 错误页面，文章documentId
        dispatch : function (type, url, category, errUrl, documentId) {
            ifeng.dispatch(type, url, category, errUrl, documentId);
            return false;
        },
        //分享链接，  分享标题，  分享内容，  分享的图片，文章documentId， 成功回调， 失败回调
        shareLivePage : function (shareUrl, title, intro, thumbnail, documentId, success, fail) {
            athene.exec(success, fail, ifeng, ifeng.shareLivePage, [shareUrl, title,
                                                                    intro, thumbnail, documentId]);
            return false;
        },
        //评论链接，  评论标题，  分享链接，  分享的图片，文章documentId
        redirect2Comments : function (commentsUrl, title, shareUrl, thumbnail, documentId) {
            ifeng.redirect2Comments(commentsUrl, title, shareUrl, thumbnail, documentId);
            return false;
        },
        //显示推送的标题，  显示推送的内容，   显示推送的跳转链接， 显示推送的时间，显示推送的类型，是订阅还是取消订阅，  成功回调， 失败回调
        showNotify : function (title, content, documentId, time, type, isShow, success, fail) {
            athene.exec(success, fail, ifeng, ifeng.showNotify, [title, content,
                                                                 documentId, time, type, isShow]);
            return false;
        },
        //分享链接，  分享标题，  分享内容，  分享的图片，文章documentId
        shareLivePageDelay : function (shareUrl, title, intro, thumbnail, documentId) {
            ifeng.shareLivePageDelay(shareUrl, title, intro, thumbnail, documentId);
            return false;
        },
        //获取所有的订阅条目
        getAllSubscription : function (success, fail) {
            athene.exec(success, fail, ifeng, ifeng.getAllSubscription, []);
            return false;
        },
		//打开相机
		openPhotoPannel : function(success){
			athene.exec(success, null, ifeng, ifeng.openPhotoPannel, []);
            return false;
		},
		
		//发送图片
		postJPG : function (posturl,path,fileKey,params,isuseAppSysParam,success){
			athene.exec(success, null, ifeng, ifeng.postJPG, [posturl, path, fileKey, params, isuseAppSysParam]);
			return false;
		}
    };
    window['ground'] = ground;
};

function ios_init(obj) {
    if (!obj.ground) {
        obj.ground = {}
        
    }
    var _IfengJSBridge_callbackId = 0;
    var _IfengJSBridge_callbackArray = {};
    var _IfengJSBridge_objArray = {};
    var _IfengBridgeId = 0;
    var _IfengJSBridge_shakecack = 0;
    
    function baseCall(jsonString) {
        _IfengJSBridge_objArray[_IfengBridgeId] = jsonString;
        window.location.href = "http://callobjc_" + _IfengBridgeId;
        _IfengBridgeId++;
    }
    
    function getArgs(bridgeId) {
        var args = _IfengJSBridge_objArray[bridgeId];
        delete _IfengJSBridge_objArray[bridgeId];
        return args;
    }
    window['ground']['getArgs'] = getArgs;
    function addCallback(functionObj) {
        var cid = _IfengJSBridge_callbackId;
        _IfengJSBridge_callbackArray[cid] = functionObj;
        _IfengJSBridge_callbackId++;
        return cid;
    }
    
    function callback(cid, msg, flag, alsoDeleteId) {
        _IfengJSBridge_callbackArray[cid](msg);
        //    if(1==flag){
        //      _IfengJSBridge_callbackArray[cid]["success"](msg);
        //    }else if(2==flag){
        //      _IfengJSBridge_callbackArray[cid]["error"](msg);
        //    }
        delete _IfengJSBridge_callbackArray[cid];
        delete _IfengJSBridge_callbackArray[alsoDeleteId];
    }
    window['ground']['callback'] = callback;
    
    function deleteCallBack(cid) {
        delete _IfengJSBridge_callbackArray[cid];
    }
    window['ground']['deleteCallBack'] = callback;
    
    function dispatch(type, url, category, errUrl, documentId) {
        var err = "";
        if (errUrl || errUrl != "") {
            err = ",\"errURL\":\"" + errUrl + "\"";
        }
        var docId = "";
        if (documentId || documentId != "") {
            docId = ",\"documentId\":\"" + documentId + "\"";
        }
        var args = "{\"type\":\"" + type + "\",\"url\":\"" + url + "\",\"category\":\"" + category + "\"" + err + docId + "}";
        var call = "{\"method\":\"dispatch:\",\"arg\":" + args + "}";
        baseCall(call);
    }
    window['ground']['dispatch'] = dispatch;
    
    function dispatchList(type, list, index, category) {
        dispatch(type, list[index], category);
    }
    window['ground']['dispatchList'] = dispatchList;
    
    // 分享
    function shareLivePage(shareUrl, title, intro, thumbnail, documentId, success, fail) {
        
        var successId = addCallback(success);
        var failId = addCallback(fail);
        
        var args = "{\"title\":\"" + title + "\",\"shareUrl\":\"" + shareUrl + "\",\"intro\":\"" + intro + "\",\"success\":\"" + successId + "\",\"failId\":\"" + failId + "\",\"thumbnail\":\"" + thumbnail + "\",\"documentId\":\"" + documentId + "\"}";
        
        var call = "{\"method\":\"shareLivePage:\",\"arg\":" + args + "}";
        baseCall(call);
    }
    window['ground']['shareLivePage'] = shareLivePage;
    
    // 返回
    function back2Application() {
        //alert("back2Application..");
        var call = "{\"method\":\"backBtnPressed\"}";
        baseCall(call);
    }
    window['ground']['back2Application'] = back2Application;
    
    // 检测是否支持摇动
    function isSupportShake(callBackFunction) {
        
        var callId = addCallback(callBackFunction);
        //alert("back2Application..");
        var call = "{\"method\":\"isSupportShake:\",\"callback\":\"" + callId + "\"}";
        baseCall(call);
    }
    window['ground']['isSupportShake'] = isSupportShake;
    
    function showCommentInput(title, commentUrl, ext, callBackFunction) {}
    
    // 打开摇动
    function shakeOn() {
        //alert("back2Application..");
        var call = "{\"method\":\"shakeOn\"}";
        baseCall(call);
    }
    window['ground']['shakeOn'] = shakeOn;
    
    // 关闭摇动
    function shakeOff() {
        //alert("back2Application..");
        var call = "{\"method\":\"shakeOff\"}";
        baseCall(call);
    }
    window['ground']['shakeOff'] = shakeOff;
    
    function shakeOver() {
        if (_IfengJSBridge_shakecack) {
            _IfengJSBridge_shakecack();
        }
    }
    
    window['ground']['shakeOver'] = shakeOver;
    
    function setShakeCallback(shakeFunction) {
        _IfengJSBridge_shakecack = shakeFunction;
    }
    window['ground']['setShakeCallback'] = setShakeCallback;
    
    function redirect2Comments(commentsUrl, title, shareUrl, thumbnail, documentId) {
        var args = "{\"title\":\"" + title + "\",\"shareUrl\":\"" + shareUrl + "\",\"commentsUrl\":\"" + commentsUrl + "\",\"thumbnail\":\"" + thumbnail + "\",\"doucmentId\":\"" + documentId + "\"}";
        
        var call = "{\"method\":\"redirect2Comments:\",\"arg\":" + args + "}";
        baseCall(call);
        
    }
    window['ground']['redirect2Comments'] = redirect2Comments;
    
    function openSendCommemnt(title, commentsUrl, ext) {
        var args = "{\"title\":\"" + title + "\",\"commentsUrl\":\"" + commentsUrl + "\",\"ext\":\"" + ext + "\"}";
        var call = "{\"method\":\"openSendCommemnt:\",\"arg\":" + args + "}";
        baseCall(call);
        
    }
    window['ground']['openSendCommemnt'] = openSendCommemnt;
    
    function showNotify(title, content, documentId, time, isShow, success, fail) {
        
        var successId = addCallback(success);
        var failId = addCallback(fail);
        var args = "{\"title\":\"" + title + "\",\"content\":\"" + content + "\",\"documentId\":\"" + documentId + "\",\"time\":\"" + time + "\",\"success\":\"" + successId + "\",\"fail\":\"" + failId + "\",\"isShow\":\"" + (isShow ? "1" : "0") + "\"}";
        
        var call = "{\"method\":\"showNotify:\",\"arg\":" + args + "}";
        baseCall(call);
        
    }
    window['ground']['showNotify'] = showNotify;
    
    function shareLivePageDelay(shareUrl, title, intro, thumbnail, documentId) {
        var args = "{\"shareUrl\":\"" + shareUrl + "\",\"title\":\"" + title + "\",\"intro\":\"" + intro + "\",\"documentId\":\"" + documentId + "\"}";
        
        var call = "{\"method\":\"shareLivePageDelay:\",\"arg\":" + args + "}";
        baseCall(call);
    }
    
    window['ground']['shareLivePageDelay'] = shareLivePageDelay;
    
    function getAllSubscription(success, fail) {
        var successId = addCallback(success);
        var failId = addCallback(fail);
        
        var args = "{\"success\":\"" + successId + "\",\"fail\":\"" + failId + "\"}";
        
        var call = "{\"method\":\"getAllSubscription:\",\"arg\":" + args + "}";
        baseCall(call);
    }
    window['ground']['getAllSubscription'] = getAllSubscription;
    
    function openPhotoPannel(callback){
        
        var successId = addCallback(callback);
        var args = "{\"success\":\"" + successId + "\"}";
        
        var call = "{\"method\":\"openPhotoPannel:\",\"arg\":" + args + "}";
        
        baseCall(call);
        
    }
    window['ground']['openPhotoPannel'] = openPhotoPannel;
    
    
    function json2str(o) {
        var arr = [];
        var fmt = function(s) {
            if (typeof s == 'object' && s != null) return json2str(s);
            return /^(string|number)$/.test(typeof s) ? "\"" + s + "\"" : s;
        }
        for (var i in o) arr.push("\"" + i + "\":" + fmt(o[i]));
        return '{' + arr.join(',') + '}';
    }
    
    function postJPG(posturl,path,fileKey,params,isuseAppSysParam,callback){
        
        var successId = addCallback(callback);
        
        var args = "{\"callback\":\"" + successId + "\",\"params\":"+(json2str(params))+
        ",\"path\":\""+path+"\",\"postUrl\":\"" + posturl + "\",\"fileKey\":\"" + fileKey + "\",\"isAppend\":\"" + (isuseAppSysParam?"1":"0") + "\"}";
        // alert(args);
        var call = "{\"method\":\"postJPG:\",\"arg\":" + args + "}";
        
        baseCall(call);
    }
    
    window['ground']['postJPG'] = postJPG;
    
    
    

};

(function () {
 var isAndroid = (/android/gi).test(navigator.appVersion),
 isIDevice = (/iphone|ipad/gi).test(navigator.appVersion);
 if (isAndroid) {
 android_init();
 } else if (isIDevice) {
 ios_init(window);
 }
 })();
