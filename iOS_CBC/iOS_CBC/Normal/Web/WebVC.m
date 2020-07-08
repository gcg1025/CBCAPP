//
//  WebV.m
//  Axym-customer
//
//  Created by Mac book on 2019/8/8.
//  Copyright © 2019 Mac book. All rights reserved.
//

#import "WebVC.h"
#import <WebKit/WebKit.h>

@interface WebVC () <WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet WKWebView *webV;
@property (weak, nonatomic) IBOutlet UIView *backgroundV;

@end

@implementation WebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
}

- (void)setViews {
    [self setNavigationBarWithTitle:self.model.title hasBackBtn:true];
    [self.navigationView.rightBtn setImage:kImage(@"") forState:UIControlStateNormal];
    self.navigationView.rightBtn.alpha = 1;
    
    [self.webV.configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:true]];
    
    self.webV.navigationDelegate = self;
    self.errorV.frame = self.backgroundV.bounds;
    [self.backgroundV addSubview:self.errorV];
    self.requestV.frame = self.backgroundV.bounds;
    [self.backgroundV addSubview:self.requestV];
}

- (void)reloadData {
    [self.webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:NEWSURL(self.model.pid, [Tool shareInstance].user.ID)]]];
    self.errorV.alpha = 0;
    self.requestV.alpha = 1;
    self.webV.alpha = 0;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.errorV.alpha = 0;
    self.requestV.alpha = 0;
    self.webV.alpha = 1;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.errorV.alpha = 1;
    self.requestV.alpha = 0;
    self.webV.alpha = 0;
}

- (void)rightAct {
    [self.webV evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '400%'" completionHandler:nil];
}

@end
