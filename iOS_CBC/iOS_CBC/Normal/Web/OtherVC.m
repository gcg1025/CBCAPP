#import "OtherVC.h"
#import <WebKit/WebKit.h>

@interface OtherVC () <WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet WKWebView *webV;

@end

@implementation OtherVC

//- (UIStatusBarStyle)preferredStatusBarStyle {
//   return UIStatusBarStyleDarkContent;
//}

- (void)viewDidLoad {
    [self.webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    self.webV.navigationDelegate = self;
    [Tool showProgressDark];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [Tool dismiss];
}
@end
