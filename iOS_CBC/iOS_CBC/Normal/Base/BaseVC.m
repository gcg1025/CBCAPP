#import "BaseVC.h"

@interface BaseVC () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (assign, nonatomic) BOOL canBack;

@end

@implementation BaseVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [Tool shareInstance].currentViewController = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (AlertV *)alertV {
    if (!_alertV) {
        _alertV = [[NSBundle mainBundle] loadNibNamed:@"AlertV" owner:nil options:nil].firstObject;
        _alertV.frame = self.view.bounds;
        _alertV.alpha = 0;
        [self.view addSubview:_alertV];
    }
    return _alertV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kNoticeUserLogIn object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kNoticeUserLogOut object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:kNoticeUserUpdate object:nil];
    [self setViews];
    [self setText];
}

- (void)setNavigationBarWithTitle:(NSString *)title hasBackBtn:(BOOL)hasOrNot {
    self.navigationController.navigationBar.hidden = true;
    if (![self.view.subviews containsObject:self.navigationView]) {
        self.navigationView = [NaviV navigationViewWithFrame:CGRectMake(0, 0, kScreenW, kTopVH) title:title hasBackBtn:hasOrNot];
        self.canBack = hasOrNot;
        [self.view addSubview:self.navigationView];
    }
    self.navigationView.titleLab.text = title;
}

- (ErrorV *)errorV {
    if (!_errorV) {
        _errorV = [[[NSBundle mainBundle] loadNibNamed:@"ErrorV" owner:nil options:NULL] lastObject];
        kWeakSelf
        _errorV.buttonClick = ^{
            [weakSelf reloadData];
        };
        _errorV.alpha = 0;
    }
    return _errorV;
}
- (ErrorV *)createErrorV {
    return [[[NSBundle mainBundle] loadNibNamed:@"ErrorV" owner:nil options:NULL] firstObject];
}

- (RequestV *)requestV {
    if (!_requestV) {
        _requestV = [[[NSBundle mainBundle] loadNibNamed:@"RequestV" owner:nil options:NULL] firstObject];
        _requestV.alpha = 0;
    }
    return _requestV;
}

- (BasePageV *)basePageV {
    if (!_basePageV) {
        _basePageV = [[BasePageV alloc] init];
    }
    return _basePageV;
}

- (BaseTV *)baseTV {
    if (!_baseTV) {
        _baseTV = [[BaseTV alloc] init];
        _baseTV.delegate = self;
        _baseTV.dataSource = self;
    }
    return _baseTV;
}

- (BaseCV *)baseCV {
    if (!_baseCV) {
        _baseCV = [[BaseCV alloc] init];
        _baseCV.delegate = self;
        _baseCV.dataSource = self;
    }
    return _baseCV;
}

- (RequestV *)createRequestV {
    return [[[NSBundle mainBundle] loadNibNamed:@"RequestV" owner:nil options:NULL] firstObject];
}

- (void)setViews {
//    self.view.backgroundColor = NAV_THEMECOLOR;
}

- (void)setText {}

- (void)resetViews {}

- (void)resignAct {}

- (void)shareAct {}
 
- (void)reloadData {}

- (void)requestData {}

- (void)requestError {}

- (void)updateData {
    self.shouleRefresh = true;
}

- (void)rightAct {}

- (void)loginAct {
    LoginVC *vc = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)logOutAct {}

- (void)loginVCLoginSuccess:(void (^)(void))loginSuccess {
//    if (kValueForKey(@"user")) {
//        loginSuccess();
//    } else {
//        LoginVC *vc = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
//        vc.loginSuccess = loginSuccess;
//        vc.rvc = [[RegisterVC alloc] initWithNibName:@"RegisterVC" bundle:nil];
//        vc.rvc.loginSuccess = loginSuccess;
//        UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
//        navc.navigationBarHidden = true;
//        navc.modalPresentationStyle = 0;
//        [self presentViewController:navc animated:true completion:^{
//
//        }];
//    }
}

- (void)toOrderAct {
    OrderPayVC *vc = [[OrderPayVC alloc] initWithNibName:@"OrderPayVC" bundle:nil];
    vc.isNew = true;
    [self.navigationController pushViewController:vc animated:true];
}

- (void)alertTitle:(NSString *)title message:(NSString *)message sureActionTitle:(NSString *)sureTitle sureAction:(void (^ __nullable)(UIAlertAction *action))sureAction cacelActionTitle:(NSString *)cancelTitle cancelAction:(void (^ __nullable)(UIAlertAction *action))cancelAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction  actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:sureAction]];
    [alert addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:cancelAction]];
    [self presentViewController:alert animated:true completion:^{
        
    }];
}
- (void)alertTitle:(NSString *)title message:(NSString *)message destructiveActionTitle:(NSString *)destructiveTitle destructiveAction:(void (^)(UIAlertAction * _Nonnull))destructiveAction cacelActionTitle:(NSString *)cancelTitle cancelAction:(void (^)(UIAlertAction * _Nonnull))cancelAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction  actionWithTitle:destructiveTitle style:UIAlertActionStyleDestructive handler:destructiveAction]];
    [alert addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:cancelAction]];
    [self presentViewController:alert animated:true completion:^{
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([[touches anyObject].view isKindOfClass:[NaviV class]]) {
        CGPoint p = [[touches anyObject] locationInView:[touches anyObject].view];
        if (p.x < 44 && p.y > kStatusH) {
            if (self.canBack) {
                [self backAct];
            }
        }
        if (p.x > kScreenW - 92 && p.x < kScreenW - 12 && p.y > kStatusH + 5 && p.y < kStatusH + 30) {
            [self rightAct];
        }
    }
    [self resignAct];
}

- (void)backAct {
    [self resignAct];
    [self.navigationController popViewControllerAnimated:true];
}

- (CGFloat)kScale {
    return (kScreenW / 360 < 1 ? 1 : kScreenW / 360);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
