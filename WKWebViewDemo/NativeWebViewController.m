//
//  NativeWebViewController.m
//  WKWebViewDemo
//
//  Created by Tina on 2017/7/4.
//  Copyright © 2017年 Tina. All rights reserved.
//

#import "NativeWebViewController.h"
#import <WebKit/WebKit.h>

@interface NativeWebViewController ()<WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong, readwrite) WKWebView *wkWebView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation NativeWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];

}

- (void)createUI {
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-120) configuration:config];
    self.wkWebView.navigationDelegate = self;
    
    [self.view addSubview:self.wkWebView];
    
    //注册方法，必须在HTML加载之前添加
    WKUserContentController *userCC = self.wkWebView.configuration.userContentController;
    [userCC addScriptMessageHandler:self name:@"JSCallOC"];

    
    [self loadLocalHtmlWithFileName:@"Native"];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.wkWebView.frame), self.view.frame.size.width, 50)];
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
    //
    [_wkWebView evaluateJavaScript:@"OCCallJS('JS被调用了')" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        //response是js方法的返回值
        NSLog(@"response:%@,error:%@",response,error);
    }];
}

-(void)loadLocalHtmlWithFileName:(NSString *)fileName{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:fileName ofType:@"html"];
    if(_wkWebView){
        [_wkWebView loadFileURL:[NSURL fileURLWithPath:path] allowingReadAccessToURL:[bundle bundleURL]];
    }
}

#pragma mark - WKScriptMessageHandler
//JS调用原生，在这个方法中，响应js的方法
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if([message.name isEqualToString: @"JSCallOC"]){
        NSLog(@"%@",message.body);
        //如果想在执行了一段代码之后，给予JS一个返回值，可通过类似于这种，变相充当返回值
//        [self.wkWebView evaluateJavaScript:@"responseCallHandler('1111')" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
//            NSLog(@"response:%@,\nerror: %@",response,error);
//        }];
        
    }
}

#pragma mark - WKNavigationDelegate
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //页面加在完成时调用
}

#pragma mark - WKUIDelegate



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
