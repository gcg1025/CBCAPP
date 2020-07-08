//
//  HomeVC.m
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/21.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import "HomeVC.h"
#import "NewsCell.h"
#import "NewsDetailsVC.h"
#import "SupplyPurchaseListVC.h"
#import "AnalyseVC.h"
#import "CustomizeVC.h"
#import "FOPriceVC.h"
#import "BidVC.h"
#import "AlertUpdateV.h"

@interface HomeVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *backgroundV;
@property (strong, nonatomic) LoginV *loginV;
@property (nonatomic, strong) AlertUpdateV *alertUpdateV;

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) NSArray<NewsM *> *dataAry;

@end

@implementation HomeVC

- (LoginV *)loginV {
    if (!_loginV) {
        _loginV = [[[NSBundle mainBundle] loadNibNamed:@"LoginV" owner:nil options:NULL] firstObject];
        _loginV.alpha = 0;
        kWeakSelf
        _loginV.loginBlock = ^{
            [weakSelf loginAct];
        };
    }
    return _loginV;
}

- (AlertUpdateV *)alertUpdateV {
    if (!_alertUpdateV) {
        _alertUpdateV = [[[NSBundle mainBundle] loadNibNamed:@"AlertUpdateV" owner:nil options:NULL] firstObject];
        _alertUpdateV.frame = UIScreen.mainScreen.bounds;
        kWeakSelf
        _alertUpdateV.updateBlock = ^{
            weakSelf.isRequest = false;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/apple-store/id1502788459?ct=web&mt=8"]];
        };
    }
    return _alertUpdateV;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![Tool isRightVersion]) {
        [self alertUpdateAct];
    } else {
        if ([Tool shareInstance].user) {
            [Tool shareInstance].shouldLogin = false;
        } else {
            if ([Tool shareInstance].shouldLogin) {
                [Tool shareInstance].shouldLogin = false;
                [self loginAct];
            }
        }
        
        if (self.btn) {
            [self selectAct:self.btn];
        }
        if (self.shouleRefresh) {
            self.shouleRefresh = false;
            [self reloadData];
        }
    }
}

- (void)viewDidLoad {
    [Tool shareInstance].isLoaded = true;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertUpdateAct) name:kNoticeAppUpdate object:nil];
    [super viewDidLoad];
    [self reloadData];
    if ([Tool shareInstance].shouldUpdate && !self.isRequest) {
        [self alertUpdateAct];
    }
}

- (void)alertUpdateAct {
    if (!self.isRequest) {
        self.isRequest = true;
        if (![self.alertUpdateV superview]) {
            [self.alertUpdateV showView];
        }
    }
}

- (void)updateData {
    [super updateData];
    if ([Tool shareInstance].currentViewController == self) {
        if (self.shouleRefresh) {
            self.shouleRefresh = false;
            [self reloadData];
        }
    }
}

- (void)setViews {
    self.baseTV.frame = CGRectMake(0, 0, kScreenW, kScreenH - kTopVH - kBottomVH - 170);
    [self.baseTV registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:@"NewsCell"];
    [self.backgroundV addSubview:self.baseTV];
    self.requestV.frame = self.backgroundV.bounds;
    [self.backgroundV addSubview:self.requestV];
    self.errorV.frame = self.backgroundV.bounds;
    self.errorV.alpha = 1;
    [self.backgroundV addSubview:self.errorV];
    self.loginV.frame = self.backgroundV.bounds;
    [self.backgroundV addSubview:self.loginV];
}

- (void)reloadData {
    if (![Tool shareInstance].user) {
        self.baseTV.alpha = 0;
        self.requestV.alpha = 0;
        self.errorV.alpha = 0;
        self.loginV.alpha = 1;
    } else {
        self.baseTV.alpha = 0;
        self.requestV.alpha = 1;
        self.errorV.alpha = 0;
        self.loginV.alpha = 0;
        [self requestData];
    }
}

- (IBAction)selectAct:(UIButton *)sender {
    self.btn = nil;
    if (![Tool shareInstance].user) {
        LoginVC *vc = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
        kWeakSelf
        vc.loginSuccessBlock = ^{
            weakSelf.btn = sender;
        };
        [self.navigationController pushViewController:vc animated:true];
    } else {
        switch (sender.tag) {
            case 30000:
                self.tabBarController.selectedIndex = 1;
                break;
            case 30001:
                self.tabBarController.selectedIndex = 2;
                break;
            case 30002:
            {
                SupplyPurchaseListVC *vc = [[SupplyPurchaseListVC alloc] initWithNibName:@"SupplyPurchaseListVC" bundle:nil];
                [self.navigationController pushViewController:vc animated:true];
            }
                break;
            case 30003:
            case 30004:
            {
                FOPriceVC *vc = [[FOPriceVC alloc] initWithNibName:@"FOPriceVC" bundle:nil];
                vc.type = sender.tag - 30003;
                [self.navigationController pushViewController:vc animated:true];
            }
                break;
            case 30005:
            {
                AnalyseVC *vc = [[AnalyseVC alloc] initWithNibName:@"AnalyseVC" bundle:nil];
                [self.navigationController pushViewController:vc animated:true];
            }
                break;
            case 30006:
            {
                CustomizeVC *vc = [[CustomizeVC alloc] initWithNibName:@"CustomizeVC" bundle:nil];
                [self.navigationController pushViewController:vc animated:true];
            }
                break;
            case 30007:
            {
                BidVC *vc = [[BidVC alloc] initWithNibName:@"BidVC" bundle:nil];
                [self.navigationController pushViewController:vc animated:true];
            }
                break;
            default:
                break;
        }
    }
    
}

- (void)requestData {
    kWeakSelf
    [Tool POST:NEWS params:@[@{@"count":@"20"}, @{@"productid":@""}, @{@"typeid":@"-1"}, @{@"minid":@"0"}, @{@"maxid":@"0"}, @{@"keyname":@"newslist"}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSDictionary * _Nonnull result) {
        if (result[@"newslist"]) {
            weakSelf.dataAry = [NewsM mj_objectArrayWithKeyValuesArray:result[@"newslist"]];
        }
        weakSelf.baseTV.alpha = 1;
        [weakSelf.baseTV reloadData];
        weakSelf.requestV.alpha = 0;
        weakSelf.errorV.alpha = 0;
        weakSelf.loginV.alpha = 0;
    } failure:^(NSString * _Nonnull error) {
        weakSelf.baseTV.alpha = 0;
        weakSelf.requestV.alpha = 0;
        weakSelf.errorV.alpha = 1;
        weakSelf.loginV.alpha = 0;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    cell.model = self.dataAry[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [Tool heightForString:self.dataAry[indexPath.row].title width:kScreenW - 32 font:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]] + 45;
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:false animated:true];
//    NewsDetailsVC *vc = [[NewsDetailsVC alloc] initWithNibName:@"NewsDetailsVC" bundle:nil];
    NewsDetailsVC *vc = [[NewsDetailsVC alloc] init];
    vc.type = NewsTypeNormal;
    vc.model = self.dataAry[indexPath.row];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
