//
//  OrderPayResultVC.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/25.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "OrderPayResultVC.h"
#import "OrderPayResultTableCell.h"
#import "MyOrderVC.h"
#import "OrderPayVC.h"

@interface OrderPayResultVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *backgroundV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;

@end

@implementation OrderPayResultVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setViews {
    [self setNavigationBarWithTitle:@"支付成功" hasBackBtn:true];
    NSString *version= [UIDevice currentDevice].systemVersion;
    if (version.doubleValue < 11) {
        self.topCon.constant = 64;
        [self.view layoutIfNeeded];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeUserUpdate object:nil];
    self.baseTV.frame = CGRectMake(0, 0, kScreenW, kScreenH - kTopVH - kBottomH);
    [self.baseTV registerNib:[UINib nibWithNibName:@"OrderPayResultTableCell" bundle:nil] forCellReuseIdentifier:@"OrderPayResultTableCell"];
    [self.backgroundV addSubview:self.baseTV];
    [self.baseTV reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderPayResultTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPayResultTableCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.model;
    kWeakSelf
    cell.backBlock = ^{
        [weakSelf backAct];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat hei = 475;
    hei += [Tool heightForString:[NSString stringWithFormat:@"%@(%@年)", self.model.oriTitle, [Tool transYear:self.model.duration]] width:kScreenW - 32 font:[UIFont systemFontOfSize:16]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    hei += [Tool heightForString:[NSString stringWithFormat:@"开始日期：%@", [dateFormatter stringFromDate:[NSDate date]]] width:kScreenW - 32 font:[UIFont systemFontOfSize:14]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:self.model.duration.integerValue];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    hei += [Tool heightForString:[NSString stringWithFormat:@"到期日期：%@", [dateFormatter stringFromDate:[calendar dateByAddingComponents:components toDate:[NSDate date] options:0]]] width:kScreenW - 32 font:[UIFont systemFontOfSize:14]];
    hei += [Tool heightForString:[NSString stringWithFormat:@"具体权限：%@", self.model.jieshao] width:kScreenW - 32 font:[UIFont systemFontOfSize:13]];
    return hei;
}

- (void)backAct {
    BOOL toOrderList = false;
    BaseVC *popVC = [[BaseVC alloc] init];
    for (BaseVC *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[MyOrderVC class]]) {
            toOrderList = true;
            popVC = vc;
            break;
        }
    }
    BOOL toOrderPay = false;
    if (!toOrderList) {
        for (BaseVC *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[OrderPayVC class]]) {
                toOrderPay = true;
                popVC = self.navigationController.viewControllers[[self.navigationController.viewControllers indexOfObject:(UIViewController *)vc] - 1];
                break;
            }
        }
    }
    if (toOrderList || toOrderPay) {
        [self.navigationController popToViewController:popVC animated:true];
    } else {
        [self.navigationController popViewControllerAnimated:true];
    }
}


@end
