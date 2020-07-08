#import "MainTBC.h"

@interface MainTBC () <UITabBarControllerDelegate>

@end

@implementation MainTBC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([tabBarController.viewControllers indexOfObject:viewController] && [tabBarController.viewControllers indexOfObject:viewController] != 4) {
        if (![Tool shareInstance].user) {
            LoginVC *vc = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
            vc.loginSuccessBlock = ^{
                tabBarController.selectedIndex = [tabBarController.viewControllers indexOfObject:viewController];
            };
            [tabBarController.selectedViewController.navigationController pushViewController:vc animated:true];
            return false;
        }
    }
    return true;
}

@end
