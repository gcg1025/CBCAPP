//
//  MineVC.m
//  iOS_CBC
//
//  Created by SDB_Mac on 2020/1/3.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "MineVC.h"
#import "MineTableCell.h"
#import "AboutVC.h"
#import "CustomizeVC.h"
#import "MyOrderVC.h"

@interface MineVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *userLab;
@property (weak, nonatomic) IBOutlet UILabel *timeTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIView *backgroundV;
@property (weak, nonatomic) IBOutlet UIButton *loginOutBtn;
@property (nonatomic, strong) NSMutableArray *dataAry;

@property (nonatomic, assign) NSInteger type;

@end

@implementation MineVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.type) {
        [self selectAct:self.type];
    }
    if (!self.isRequest) {
        kWeakSelf
        if ([Tool shareInstance].user) {
            self.isRequest = true;
            [Tool POST:LOGIN params:@[@{@"loginname":[Tool shareInstance].user ? [Tool userPhone] : @"phone"}, @{@"loginpass":[Tool shareInstance].user ? [Tool userPassword] : @"password"}, @{@"pass":PASS}] progress:^(NSProgress * _Nonnull progress) {
                
            } success:^(NSDictionary * _Nonnull result) {
                if (result) {
                    if ([result.allKeys containsObject:@"logininfo"]) {
                        UserM *model = [UserM mj_objectArrayWithKeyValuesArray:result[@"logininfo"]].firstObject;
                        if (model.ID) {
                            kSetValueForKey([model mj_JSONString], model.ID);
                            [Tool shareInstance].user = model;
                            [weakSelf reloadData];
                        }
                        weakSelf.isRequest = false;
                    }
                }
            } failure:^(NSString * _Nonnull error) {
                weakSelf.isRequest = false;
            }];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataAry = @[@"我的订单", @"关于我们", @"我的定制", @"客服热线"].mutableCopy;
}

- (void)setViews {
    self.baseTV.bounces = false;
    self.baseTV.frame = CGRectMake(0, 0, kScreenW, kScreenH - kTopVH - kBottomVH - 160);
    [self.baseTV registerNib:[UINib nibWithNibName:@"MineTableCell" bundle:nil] forCellReuseIdentifier:@"MineTableCell"];
    [self.backgroundV addSubview:self.baseTV];
    [self reloadData];
}

- (void)reloadData {
    if ([Tool shareInstance].user) {
        NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
        [dayFormatter setDateFormat:@"yyyy/MM/dd"];
        NSDateFormatter *dayFormatterL = [[NSDateFormatter alloc] init];
        [dayFormatterL setDateFormat:@"yyyy-MM-dd"];
        self.userLab.text = [Tool userPhone];
        self.timeLab.text = [dayFormatterL stringFromDate:[dayFormatter dateFromString:[[Tool shareInstance].user.enddate componentsSeparatedByString:@" "][0]]];
        self.timeLab.alpha = 1;
        self.loginOutBtn.alpha = 1;
        self.timeTitleLab.alpha = 1;
    } else {
        self.userLab.text = @"点击登录/注册";
        self.timeLab.alpha = 0;
        self.loginOutBtn.alpha = 0;
        self.timeTitleLab.alpha = 0;
    }
}

- (IBAction)loginAct:(id)sender {
    if (![Tool shareInstance].user) {
        [self loginAct];
    }
}

- (IBAction)logoutAct:(id)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"CBC金属网" message:@"确定要退出当前登录吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [Tool logOut];
    }]];
    [self presentViewController:alertVC animated:true completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineTableCell" forIndexPath:indexPath];
    cell.name = self.dataAry[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:false animated:true];
    if (indexPath.row == 0 || indexPath.row == 2) {
        if ([Tool shareInstance].user) {
            [self selectAct:indexPath.row + 1];
        } else {
            LoginVC *vc = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
            kWeakSelf
            vc.loginSuccessBlock = ^{
                weakSelf.type = indexPath.row + 1;
            };
            [self.navigationController pushViewController:vc animated:true];
        }
    } else {
        [self selectAct:indexPath.row + 1];
    }
}

- (void)selectAct:(NSInteger)type {
    self.type = 0;
    switch (type - 1) {
        case 0:
        {
            MyOrderVC *vc = [[MyOrderVC alloc] initWithNibName:@"MyOrderVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case 1:
        {
            AboutVC *vc = [[AboutVC alloc] initWithNibName:@"AboutVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case 2:
        {
            CustomizeVC *vc = [[CustomizeVC alloc] initWithNibName:@"CustomizeVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case 3:
        {
            if ([Tool shareInstance].user.kfphone.length > 5) {
                NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", [Tool shareInstance].user.kfphone];
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:str]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                }
            } else {
                [Tool showStatusDark:@"暂无客服"];
            }
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


@end
