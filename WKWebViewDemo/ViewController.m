//
//  ViewController.m
//  WKWebViewDemo
//
//  Created by Tina on 2017/6/28.
//  Copyright © 2017年 Tina. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <WebViewJavascriptBridge/WKWebViewJavascriptBridge.h>

@interface ViewController ()<WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-60) configuration:config];
    
//    self.webView.navigationDelegate = self;
//    
//    WKUserContentController *userCC = self.webView.configuration.userContentController;
//    
//    [userCC addScriptMessageHandler:self name:@"btnClick2"];
    
//    [self loadRequestWithRequestUrl:@"http://192.168.6.157:8090/"];
    [self loadLocalHtmlWithFileName:@"index"];
    
    [self.view addSubview:self.webView];
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    
    //js 调用原生，获取数据,通过回调给JS
    [self.bridge registerHandler:@"JSCallOC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"javascript data is :%@",data);
        responseCallback(@"from Objective-C");
    }];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.webView.frame), self.view.frame.size.width - 30, 30)];
    [button setTitle:@"点我调用JS" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blueColor]];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}


-(void)loadRequestWithRequestUrl:(NSString *)requestUrl{
    if(_webView){
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData | NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        [_webView loadRequest:request];
    }
}

-(void)click {
    [self.bridge callHandler:@"OCCallJS"];
//    [self.bridge callHandler:@"OCCallJS" data:@"this is a have data"];
//    [self.bridge callHandler:@"OCCallJS" data:@"this is a have data and callback" responseCallback:^(id responseData) {
//        NSLog(@"callback:%@",responseData);
//    }];
}

-(void)loadLocalHtmlWithFileName:(NSString *)fileName{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:fileName ofType:@"html"];
    if(_webView){
        [_webView loadFileURL:[NSURL fileURLWithPath:path] allowingReadAccessToURL:[bundle bundleURL]];
    }
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self.webView evaluateJavaScript:@"getMsg1('this is a token')" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"response:%@,\nerror: %@",response,error);
    }];
//
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WKScriptMessageHandler
//JS调用原生，在这个方法中，响应js的方法
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if([message.name isEqualToString: @"btnClick2"]){
        NSLog(@"%@",message.body);
        [self.webView evaluateJavaScript:@"getMsg1('1111')" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"response:%@,\nerror: %@",response,error);
        }];
        
    }
}

#pragma mark - WKNavigationDelegate


#pragma mark - WKUIDelegate


@end
