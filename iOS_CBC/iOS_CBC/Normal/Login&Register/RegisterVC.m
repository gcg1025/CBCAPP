#import "RegisterVC.h"

@interface RegisterVC () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneT;
@property (weak, nonatomic) IBOutlet UITextField *codeT;
@property (weak, nonatomic) IBOutlet UITextField *passwordT;
@property (weak, nonatomic) IBOutlet UIButton *codeB;
@property (weak, nonatomic) IBOutlet UILabel *codeL;

@property (weak, nonatomic) IBOutlet UIButton *registerB;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger time;

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViews];
}

- (void)setViews {
    [self setNavigationBarWithTitle:@"注册" hasBackBtn:true];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.phoneT == textField) {
        if (str.length > 11) {

        } else {
            self.phoneT.text = str;
        }
    } else if (self.codeT == textField) {
        if (str.length > 6) {
            
        } else {
            self.codeT.text = str;
        }
    } else if (self.passwordT == textField) {
        if (str.length > 20) {
            
        } else {
            self.passwordT.text = str;
        }
    }
    return false;
}

- (IBAction)sendCodeAct:(id)sender {
    [self resignAct];
    if (self.isRequest) {
        return;
    }
    if (![Tool isPhoneNumber:self.phoneT.text]) {
        [Tool showStatusDark:@"请输入正确的手机号码"];
        return;
    }
    [Tool showProgressDark];
    self.isRequest = true;
    kWeakSelf
    [Tool POST:SENDCODE params:@[@{@"phone":self.phoneT.text}, @{@"pass":PASS}] progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSDictionary * _Nonnull result) {
        NSString *string = result[@"smsCheckState"];
        weakSelf.isRequest = false;
        if ([string isEqualToString: @"1"]) {
            [Tool showStatusDark:@"发送成功"];
            weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setCodeT) userInfo:nil repeats:true];
            weakSelf.time = 61;
            weakSelf.codeB.userInteractionEnabled = false;
            [weakSelf setCodeT];
        } else if ([string isEqualToString: @"2"]) {
            [Tool showStatusDark:@"手机号已注册"];
        } else {
            [Tool showStatusDark:@"发送失败"];
        }
    } failure:^(NSString * _Nonnull error) {
        weakSelf.isRequest = false;
        [Tool showStatusDark:@"发送失败"];
    }];
}

- (void)setCodeT {
    self.time -= 1;
    if (self.time == 0) {
        self.codeB.userInteractionEnabled = true;
        self.codeL.text = @"重新获取";
        self.time = 60;
        [self.timer invalidate];
        self.timer = nil;
    } else {
        self.codeL.text = [NSString stringWithFormat:@"%@S", @(self.time).stringValue];
    }
}

- (IBAction)registerAct:(UIButton *)sender {
    [self resignAct];
    if (self.isRequest) {
        return;
    }
    if (![Tool isPhoneNumber:self.phoneT.text]) {
        [Tool showStatusDark:@"请输入正确的手机号码"];
        return;
    }
    if (self.codeT.text.length != 4) {
        [Tool showStatusDark:@"验证码错误"];
        return;
    }
    if (self.passwordT.text.length < 6 || self.passwordT.text.length > 20) {
        [Tool showStatusDark:@"请输入密码6-20位"];
        return;
    }
    [Tool showProgressDark];
    self.isRequest = true;
    kWeakSelf
    [Tool POST:REGISTER params:@[@{@"phone":self.phoneT.text}, @{@"smscode":self.codeT.text}, @{@"regpass":self.passwordT.text}, @{@"regsource":@"IOS"},@{@"pass":PASS}] progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSDictionary * _Nonnull result) {
        NSString *string = result[@"RegState"];
        weakSelf.isRequest = false;
        if ([string isEqualToString: @"1"]) {
            [Tool showStatusDark:@"注册成功, 即将返回登录"];
            [weakSelf performSelector:@selector(backAct) withObject:nil afterDelay:1];
        } else if ([string isEqualToString: @"2"]) {
            [Tool showStatusDark:@"手机验证码错误"];
        } else if ([string isEqualToString: @"3"]) {
            [Tool showStatusDark:@"账号已存在, 请直接登录"];
        } else {
            [Tool showStatusDark:@"请求失败"];
        }
    } failure:^(NSString * _Nonnull error) {
        weakSelf.isRequest = false;
        [Tool showStatusDark:@"请求失败"];
    }];
}

- (void)backAct {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)resignTap:(UITapGestureRecognizer *)sender {
    [self resignAct];
}

- (void)resignAct {
    [self.phoneT resignFirstResponder];
    [self.codeT resignFirstResponder];
    [self.passwordT resignFirstResponder];
}

@end
