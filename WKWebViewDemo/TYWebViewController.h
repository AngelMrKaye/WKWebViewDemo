//
//  TYWebViewController.h
//  WKWebViewDemo
//
//  Created by Tina on 2017/7/4.
//  Copyright © 2017年 Tina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface TYWebViewController : UIViewController

@property (nonatomic, strong, readonly) WKWebView *wkWebView;


-(void)loadLocalHtmlWithFileName:(NSString *)fileName ofType:(NSString *)type;

-(void)loadRequestWithRequestUrl:(NSString *)requestUrl;

@end
