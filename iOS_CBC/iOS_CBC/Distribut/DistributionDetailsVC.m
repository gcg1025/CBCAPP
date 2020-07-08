//
//  DistributionDetailsVC.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/26.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "DistributionDetailsVC.h"
#import <WebKit/WebKit.h>

@interface DistributionDetailsVC () <WKNavigationDelegate>

//@property (weak, nonatomic) IBOutlet WKWebView *webV;
@property (nonatomic, strong) WKWebView *webV;
//@property (weak, nonatomic) IBOutlet UIView *backgroundV;

@end

@implementation DistributionDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
}

- (void)setViews {
    [self setNavigationBarWithTitle:@"发布" hasBackBtn:true];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = true;
    if (@available(iOS 9.0, *)) {
        config.allowsPictureInPictureMediaPlayback = true;
    }
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:true];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    config.userContentController = wkUController;
    
    self.webV = [[WKWebView alloc] initWithFrame:CGRectMake(0, kTopVH, kScreenW,  kScreenH - kTopVH - kBottomH) configuration:config];
    self.webV.navigationDelegate = self;
    [self.view addSubview:self.webV];
    self.errorV.frame = CGRectMake(0, kTopVH, kScreenW,  kScreenH - kTopVH - kBottomH);
    [self.view addSubview:self.errorV];
    self.requestV.frame = CGRectMake(0, kTopVH, kScreenW,  kScreenH - kTopVH - kBottomH);
    [self.view addSubview:self.requestV];
}

- (void)reloadData {
    [self.webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:DISTRIBUTIONURL(@(self.model.ID).stringValue)]]];
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

@end
