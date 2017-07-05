//
//  TYWebViewController.m
//  WKWebViewDemo
//
//  Created by Tina on 2017/7/4.
//  Copyright © 2017年 Tina. All rights reserved.
//

#import "TYWebViewController.h"

@interface TYWebViewController ()

@property (nonatomic, strong, readwrite) WKWebView *wkWebView;
@property (nonatomic, copy) NSString *requestUrl;

@end

@implementation TYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupWebView];
    
}

- (void)setupWebView {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    
    self.wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-20) configuration:config];
    
    [self.view addSubview:self.wkWebView];
}

-(void)loadRequestWithRequestUrl:(NSString *)requestUrl{
    
    if(_wkWebView){
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData | NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        [_wkWebView loadRequest:request];
    }
}

-(void)loadLocalHtmlWithFileName:(NSString *)fileName ofType:(NSString *)type{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:fileName ofType:type];
    if(_wkWebView){
        [_wkWebView loadFileURL:[NSURL fileURLWithPath:path] allowingReadAccessToURL:[bundle bundleURL]];
    }
}

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
