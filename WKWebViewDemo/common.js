//这部分是固定的
var iosBridge = function (callback) {
    if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
    if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
    window.WVJBCallbacks = [callback];
    var WVJBIframe = document.createElement('iframe');
    WVJBIframe.style.display = 'none';
    WVJBIframe.src = 'https://__bridge_loaded__';
    document.documentElement.appendChild(WVJBIframe);
    setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
}

//用 iosBridge 接收
iosBridge(function (bridge){
    //js 注册 oc 需要调用的方法，并接收OC传递的值
    /**
     * OC调用JS中的注册方法，JS有两种响应方式
     * 1. JS接收到OC的调用请求，需要通过回调把一些数据给OC的
     * 2. JS接收到OC的调用请求，无需回调传值的
    */

    /**
     * 1. JS接收到OC的调用请求，需要通过回调把一些数据给OC的
     * @first param: 'OCCallJS', 是OC调用JS的方法名，需要事先注册
     * @second param: 回调函数，其中data 是OC通过 ‘OCCallJS’ 方法，传过来的值， ’responseCallBack‘ 是JS回调给OC的方法，通过’responseCallBack‘可以给OC传递一个值
     * 
     * 此方法必须对应OC中的方法，如果OC没有callback，JS端会报错
     * @first param: 'OCCallJS', 是OC调用的JS方法名
     * @second param data: 是需要通过OCCallJS方法，传递给JS的数据
     * @third param responseCallback: JS 收到调用之后，回调给OC的值
     * [self.bridge callHandler:@"OCCallJS" data:@"this is a have data and callback" responseCallback:^(id responseData) {
     *       NSLog(@"callback from JS:%@",responseData);
     * }];
     * 
    */
    // bridge.registerHandler('OCCallJS', function(data,responseCallBack){
    //        console.log('js is called by oc,data from oc:' + data)
    //        responseCallBack('JS\'s data to oc')
    // })

    /**
     * 2. JS接收到OC的调用请求，无需回调传值的
     * @first param: 'OCCallJS', 是OC调用JS的方法名，需要事先注册
     * @second param: 回调函数，其中data 是OC通过 ‘OCCallJS’ 方法，传过来的值,可能为null
     * 
     * 此方法对应OC中下面两个方法
     * [self.bridge callHandler:@"OCCallJS" data:@"this is a have data"]; 或者[self.bridge callHandler:@"OCCallJS"];
     * 如果是前者 则对应的JS回调函数中有值，后者，则为null 
    */
    bridge.registerHandler('OCCallJS', function (data){
        console.log('data from oc' + data);
    })
})

function btnClick() {
    /**
     * JS 调用 OC，同样也需要现在OC注册方法名，然后才能在JS中调用
     */


    iosBridge(function (bridge){
        // bridge.callHandler('JSCallOC')
        // bridge.callHandler('JSCallOC','js to oc')
        bridge.callHandler('JSCallOC','js to oc',function(responseData){
            console.log(responseData);
            document.getElementById('div1').innerText = 'OC给我的数据：' + responseData
        })
    })
}