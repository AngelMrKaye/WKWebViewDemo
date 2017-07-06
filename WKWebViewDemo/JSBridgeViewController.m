//
//  ViewController.m
//  WKWebViewDemo
//
//  Created by Tina on 2017/6/28.
//  Copyright © 2017年 Tina. All rights reserved.
//

#import "JSBridgeViewController.h"
#import <WebKit/WebKit.h>
#import <WebViewJavascriptBridge/WKWebViewJavascriptBridge.h>

@interface JSBridgeViewController ()

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;
@property (nonatomic, strong) UILabel *label;

@end

@implementation JSBridgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self createUI];
    
    [self loadRequestWithRequestUrl:@"http://192.168.6.157:8090/"];
    
    //js 调用原生，获取数据,通过回调给JS
    [self.bridge registerHandler:@"JSCallOC1" handler:^(id data, WVJBResponseCallback responseCallback) {
        self.label.text = [NSString stringWithFormat:@"%@,并准备向Objective-C要一个苹果",data];
        responseCallback(@"并向Objective-C要了一个苹果");
    }];
}

-(void) deviceDemo {
    NSLog(@"%d",(long)[UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone);
}

- (void)createUI {
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-120) configuration:config];
    
    [self.view addSubview:self.webView];
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
//    [self loadLocalHtmlWithFileName:@"index"];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.webView.frame), self.view.frame.size.width, 50)];
    
    self.label.numberOfLines = 0;
    self.label.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.label];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.label.frame), self.view.frame.size.width - 30, 30)];
    [button setTitle:@"点我调用JS" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blueColor]];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}


-(void)click {
//    [self.bridge callHandler:@"OCCallJS"];
//    [self.bridge callHandler:@"OCCallJS" data:@"Objective-C主动给JS一个苹果，并且不要回报"];
    [self.bridge callHandler:@"OCCallJS2" data:@"Objective-C主动给JS一个苹果，并且不要回报" responseCallback:^(id responseData) {
        self.label.text = [NSString stringWithFormat:@"Objective-C主动给JS一个苹果后，%@",responseData];
    }];
}

-(void)loadRequestWithRequestUrl:(NSString *)url {
    if(_webView){
        [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]]];
    }
}

-(void)loadLocalHtmlWithFileName:(NSString *)fileName{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:fileName ofType:@"html"];
    if(_webView){
        [_webView loadFileURL:[NSURL fileURLWithPath:path] allowingReadAccessToURL:[bundle bundleURL]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
