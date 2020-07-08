//
//  NewsDetailsVC.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/25.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "NewsDetailsVC.h"
#import <WebKit/WebKit.h>
#import "NewsDetailsFontV.h"
#import "ShareV.h"
#import <ShareSDK/ShareSDK.h>

@interface NewsDetailsVC () <WKNavigationDelegate, WKUIDelegate>

//@property (weak, nonatomic) IBOutlet WKWebView *webV;
@property (nonatomic, strong) WKWebView *webV;
//@property (weak, nonatomic) IBOutlet UIView *backgroundV;
@property (nonatomic, strong) NewsDetailsFontV *fontV;
@property (nonatomic, strong) ShareV *shareV;
@property (nonatomic, strong) NSMutableArray<NSString *> *URLStrAry;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIView *shareLineV;

@end

@implementation NewsDetailsVC

- (ShareV *)shareV {
    if (!_shareV) {
        _shareV = [[NSBundle mainBundle] loadNibNamed:@"ShareV" owner:nil options:nil].firstObject;
        _shareV.frame = self.view.bounds;
        _shareV.alpha = 0;
        kWeakSelf
        _shareV.shareBlock = ^(ShareType type) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params SSDKSetupShareParamsByText:weakSelf.model.title images:kImage(@"app_icon") url:[NSURL URLWithString:SHARESURL(weakSelf.model.pid)]
                                         title:weakSelf.model.title
                                          type:SSDKContentTypeAuto];

            [ShareSDK share:type ? SSDKPlatformSubTypeWechatTimeline : SSDKPlatformSubTypeWechatSession  parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                switch (state) {
                    case SSDKResponseStateSuccess:
                        [Tool showStatusDark:@"分享成功"];
                        break;
                    case SSDKResponseStateFail:
                        [Tool showStatusDark:@"分享失败"];
                        break;
                    case SSDKResponseStateCancel:
                        [Tool showStatusDark:@"取消分享"];
                        break;
                    default:
                        break;
                }
            }];
        };
    }
    return _shareV;
}

- (NewsDetailsFontV *)fontV {
    if (!_fontV) {
        _fontV = [[NSBundle mainBundle] loadNibNamed:@"NewsDetailsFontV" owner:nil options:nil].firstObject;
        _fontV.frame = self.view.bounds;
        _fontV.alpha = 0;
        kWeakSelf
        _fontV.selectBlock = ^(NSInteger index) {
            kSetValueForKey(@(index).stringValue, @"newsFont");
            [weakSelf.webV evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@%%'", @[@"100", @"110", @"120", @"130"][index]] completionHandler:nil];
        };
    }
    return _fontV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
}

- (void)setViews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBarWithTitle:self.model.title hasBackBtn:true];
    [self.navigationView.rightBtn setImage:kImage(@"news_details_font") forState:UIControlStateNormal];
    self.navigationView.rightBtn.alpha = 1;
    
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
    
    self.webV = [[WKWebView alloc] initWithFrame:CGRectMake(0, kTopVH, kScreenW,  kScreenH - kTopVH - kBottomVH) configuration:config];
    self.webV.navigationDelegate = self;
    self.webV.UIDelegate = self;
    [self.view addSubview:self.webV];
    self.errorV.frame = CGRectMake(0, kTopVH, kScreenW,  kScreenH - kTopVH - kBottomVH);
    [self.view addSubview:self.errorV];
    self.requestV.frame = CGRectMake(0, kTopVH, kScreenW,  kScreenH - kTopVH - kBottomVH);
    [self.view addSubview:self.requestV];
    
    self.shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenH - kBottomVH, kScreenW, kTabbarH)];
    self.shareBtn.backgroundColor = [UIColor whiteColor];
    [self.shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [self.shareBtn setTitleColor:kHexColor(@"434343", 1) forState:UIControlStateNormal];
    self.shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.shareBtn];
    [self.shareBtn addTarget:self action:@selector(shareAct) forControlEvents:UIControlEventTouchUpInside];
    self.shareLineV = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH - kBottomVH - 0.5, kScreenW, 0.5)];
    self.shareLineV.backgroundColor = kHexColor(@"9A9A9A", 1);
    [self.view addSubview:self.shareLineV];
    
    [self.view addSubview:self.shareV];
    [self.view addSubview:self.fontV];
}

- (void)reloadData {
    NSString *url = [NSString stringWithFormat:@"%@%@", NEWSURL(self.model.pid, [Tool shareInstance].user.ID), self.type ? (self.type == NewsTypeAnalyse ? @"&type=scfx" : @"&type=zbgg") : @""];
    self.URLStrAry = @[url].mutableCopy;
    [self.webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    self.errorV.alpha = 0;
    self.requestV.alpha = 1;
    self.webV.alpha = 0;
    self.shareBtn.alpha = 0;
    self.shareLineV.alpha = 0;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.errorV.alpha = 0;
    self.requestV.alpha = 0;
    if (!kValueForKey(@"newsFont")) {
        kSetValueForKey(@"0", @"newsFont");
    };
    NSString *index = kValueForKey(@"newsFont");
    self.fontV.index = index.integerValue;
    [webView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@%%'", @[@"100", @"110", @"120", @"130"][index.integerValue]] completionHandler:nil];
    kWeakSelf
    [webView evaluateJavaScript:@"document.body.innerText" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if ([result isKindOfClass:[NSString class]]) {
            if ([result containsString:@"您还没有访问权限，如需帮助请联系客服!"]) {
                if (!weakSelf.isRequest) {
                    weakSelf.isRequest = true;
                    [weakSelf.alertV showView];
                }
            }
        }
    }];
//    [webView evaluateJavaScript:[NSString stringWithFormat:@"var script = document.createElement('script');"
//    "script.type = 'text/javascript';"
//    "script.text = \"function ResizeImages() { "
//    "var myimg,oldwidth;"
//    "var maxwidth = %@;"
//    "for(i=0;i <document.images.length;i++){"
//    "myimg = document.images[i];"
//    "oldwidth = myimg.width;"
//    "myimg.width = maxwidth;"
//    "}"
//    "}\";"
//    "document.getElementsByTagName('head')[0].appendChild(script);ResizeImages();", @(kScreenW - 100).stringValue] completionHandler:nil];
    [webView evaluateJavaScript:@"function getImages(){"
    "var objs = document.getElementsByTagName(\"img\");"
    "var imgScr = '';"
    "for(var i=0;i<objs.length;i++){"
    "imgScr = imgScr + objs[i].src + '+';"
    "};"
    "return imgScr;"
     "};" completionHandler:nil];
    [webView evaluateJavaScript:@"getImages()" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        NSString *imageUrl = data;
        NSMutableArray *urlArry = [imageUrl componentsSeparatedByString:@"+"].mutableCopy;
        [urlArry removeLastObject];
        //        self.imgUrlArray.addObjects(from: urlArry)
        //        for url in self.imgUrlArray{
        //            let photo = SKPhoto.photoWithImageURL(url as! String)
        //            photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
        //            self.images.append(photo)
        //        }
    }];
//       var jsClickImage:String
//       jsClickImage =
//           "function registerImageClickAction(){" +
//           "var imgs=document.getElementsByTagName('img');" +
//           "var length=imgs.length;" +
//           "for(var i=0;i<length;i++){" +
//           "img=imgs[i];" +
//           "img.οnclick=function(){" +
//           "window.location.href='image-preview:'+this.src}" +
//           "}" +
//           "}"
//       webView.evaluateJavaScript(jsClickImage, completionHandler: nil)
//       webView.evaluateJavaScript("registerImageClickAction()", completionHandler: nil)
    self.webV.alpha = 1;
    self.shareBtn.alpha = 1;
    self.shareLineV.alpha = 1;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.errorV.alpha = 1;
    self.requestV.alpha = 0;
    self.webV.alpha = 0;
    self.shareBtn.alpha = 0;
    self.shareLineV.alpha = 0;
}

- (void)rightAct {
    if (self.webV.alpha == 1) {
        [self.fontV showView];
    }
}

- (void)shareAct {
    [self.shareV showView];
}


- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *str = [NSString stringWithFormat:@"%@",URL];
    if (![self.URLStrAry.lastObject isEqualToString:str]) {
        [self.URLStrAry addObject:str];
    }
    if ([str containsString:@"myweb:imageClick:"]) {
        decisionHandler(WKNavigationActionPolicyCancel); // 必须实现 不加载
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);  // 必须实现 加载
    }
}

- (void)backAct {
    if (self.URLStrAry.count > 1) {
        [self.URLStrAry removeLastObject];
        [self.webV goBack];
    } else {
        [self.navigationController popViewControllerAnimated:true];
    }
}

@end
