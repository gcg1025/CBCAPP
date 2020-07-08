//
//  OrderDetailsVC.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/24.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "OrderDetailsVC.h"
#import "OrderDetailsTopTableCell.h"
#import "OrderDetailsInfoTableCell.h"
#import "OrderDetailsVIPTopTableCell.h"
#import "OrderDetailsVIPContentCell.h"

@interface OrderDetailsVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *backgroundV;
@property (weak, nonatomic) IBOutlet UIView *botV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *botVHeiCon;
@property (nonatomic, strong) NSMutableArray<OrderCellM *> *dataAry;

@property (nonatomic, assign) NSInteger timeIndex;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, assign) NSInteger functionIndex;
@property (nonatomic, strong) OrderInfoM *model;

@property (weak, nonatomic) IBOutlet UILabel *priceTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;

@end

@implementation OrderDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
}

- (void)setViews {
    [self setNavigationBarWithTitle:@"订单详情" hasBackBtn:true];
    
    NSString *version= [UIDevice currentDevice].systemVersion;
    if (version.doubleValue < 11) {
        self.topCon.constant = 64;
        [self.view layoutIfNeeded];
    }
    
    self.baseTV.frame = CGRectMake(0, 0, kScreenW, kScreenH - kTopVH - kBottomH - 60);
    self.baseTV.backgroundColor = kHexColor(@"EEEEEE", 1);
    [self.baseTV registerNib:[UINib nibWithNibName:@"OrderDetailsTopTableCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailsTopTableCell"];
    [self.baseTV registerNib:[UINib nibWithNibName:@"OrderDetailsInfoTableCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailsInfoTableCell"];
    [self.baseTV registerNib:[UINib nibWithNibName:@"OrderDetailsVIPTopTableCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailsVIPTopTableCell"];
    [self.baseTV registerNib:[UINib nibWithNibName:@"OrderDetailsVIPContentCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailsVIPContentCell"];
    [self.backgroundV addSubview:self.baseTV];
    self.requestV.frame = self.backgroundV.bounds;
    [self.backgroundV addSubview:self.requestV];
    self.errorV.frame = self.backgroundV.bounds;
    [self.backgroundV addSubview:self.errorV];
}

- (void)resetViews {
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSArray<NSString *> *dateAry = [self.model.privacyModel.enddate componentsSeparatedByString:@" "];
    BOOL hasBot = false;
    if (self.model.privacyModel.state.integerValue == 1) {
        self.priceLab.alpha = 0;
        self.priceTitleLab.alpha = 0;
        if (dateAry.count) {
            NSTimeInterval endT = [dayFormatter dateFromString:dateAry[0]].timeIntervalSince1970;
            NSTimeInterval currentT = [dayFormatter dateFromString:[dayFormatter stringFromDate:[NSDate date]]].timeIntervalSince1970;
            if (endT <= currentT + 30 * 24 * 3600) {
                hasBot = true;
                [self.payBtn setTitle:@"立即续费" forState:UIControlStateNormal];
            }
        }
    } else {
        hasBot = true;
        self.priceLab.alpha = 1;
        self.priceTitleLab.alpha = 1;
        self.priceLab.text = [NSString stringWithFormat:@"¥%@", self.model.privacyModel.payMoney];
        [self.payBtn setTitle:@"立即结算" forState:UIControlStateNormal];
    }
    self.botVHeiCon.constant = hasBot ? 60 : 0.01;
    self.baseTV.frame = CGRectMake(0, 0, kScreenW, kScreenH - kTopVH - kBottomH - (hasBot ? 60 : 0.01));
    self.botV.alpha = hasBot ? 1 : 0;
}

- (void)reloadData {
    self.requestV.alpha = 1;
    self.errorV.alpha = 0;
    self.baseTV.alpha = 0;
    self.botV.alpha = 0;
    self.dataAry = @[].mutableCopy;
    [self requestData];
}

- (void)requestData {
    kWeakSelf
    [Tool POST:ORDERINFO params:@[@{@"ordernumber":self.orderNum}, @{@"pass":PASS}] progress:^(NSProgress * _Nonnull infoProgress) {
                
            } success:^(NSDictionary * _Nonnull infoResult) {
                OrderPrivacyInfoM *privacyM = [[OrderPrivacyInfoM alloc] init];
                OrderPrivacyInfoM *tempModel = [OrderPrivacyInfoM mj_objectArrayWithKeyValuesArray:infoResult[@"orderinfo1"]].firstObject;
                privacyM.payMoney = [Tool decryptString:tempModel.payMoney];
                privacyM.payType = [Tool decryptString:tempModel.payType];
                privacyM.state = [Tool decryptString:tempModel.state];
                privacyM.systemDate = [Tool decryptString:tempModel.systemDate];
                tempModel = [OrderPrivacyInfoM mj_objectArrayWithKeyValuesArray:infoResult[@"orderinfo2"]].firstObject;
                privacyM.productname = [Tool decryptString:tempModel.productname];
                privacyM.enddate = [Tool decryptString:tempModel.enddate];
                privacyM.qxlx = [Tool decryptString:tempModel.qxlx];
                privacyM.startdate = [Tool decryptString:tempModel.startdate];
                privacyM.title = [Tool decryptString:tempModel.title];
                [Tool POST:ORDERVIPINFO params:@[@{@"pass":PASS}] progress:^(NSProgress * _Nonnull progress) {
                    
                } success:^(NSDictionary * _Nonnull result) {
                    OrderInfoM *model = [OrderInfoM mj_objectArrayWithKeyValuesArray:result[@"app_qx_info"]].firstObject;
                    privacyM.duration = @([privacyM.enddate componentsSeparatedByString:@"/"].firstObject.integerValue - [privacyM.startdate componentsSeparatedByString:@"/"].firstObject.integerValue).stringValue;
                    model.title = [NSString stringWithFormat:@"%@%@年", privacyM.title, [Tool transYear:privacyM.duration]];
                    model.orderNumber = weakSelf.orderNum;
                    weakSelf.model = model;
                    weakSelf.model.privacyModel = privacyM;
                    if (model.jieshao.length) {
                        for (NSString *str in [model.jieshao componentsSeparatedByString:@"、"]) {
                            OrderCellM *contentM = [[OrderCellM alloc] init];
                            contentM.content = str;
                            contentM.type = 1;
                            contentM.cellHeight = 6 + [Tool heightForString:str width:kScreenW - 55 font:[UIFont systemFontOfSize:14]];
                            [weakSelf.dataAry addObject:contentM];
                        }
                        [weakSelf.baseTV reloadData];
                        weakSelf.baseTV.alpha = 1;
                        weakSelf.requestV.alpha = 0;
                        weakSelf.errorV.alpha = 0;
                        weakSelf.botV.alpha = 1;
                        weakSelf.priceLab.text = [NSString stringWithFormat:@"¥%@", model.price1_new];
                        [weakSelf resetViews];
                    } else {
                        weakSelf.baseTV.alpha = 0;
                        weakSelf.requestV.alpha = 0;
                        weakSelf.errorV.alpha = 1;
                        weakSelf.botV.alpha = 0;
                    }
                } failure:^(NSString * _Nonnull error) {
                    weakSelf.baseTV.alpha = 0;
                    weakSelf.requestV.alpha = 0;
                    weakSelf.errorV.alpha = 1;
                    weakSelf.botV.alpha = 0;
                }];
            } failure:^(NSString * _Nonnull infoError) {
                weakSelf.baseTV.alpha = 0;
                weakSelf.requestV.alpha = 0;
                weakSelf.errorV.alpha = 1;
                weakSelf.botV.alpha = 0;
            }];
}

- (IBAction)payAct:(id)sender {
    if (self.model.privacyModel.state.integerValue == 1) {
        [self toOrderAct];
    } else {
        OrderPayVC *vc = [[OrderPayVC alloc] initWithNibName:@"OrderPayVC" bundle:nil];
        vc.isNew = false;
        vc.orderNum = self.model.orderNumber;
        vc.duration = self.model.duration;
        vc.name = self.model.title;
        vc.payMoney = self.model.privacyModel.payMoney;
        vc.systemDate = self.model.privacyModel.systemDate;
        [self.navigationController pushViewController:vc animated:true];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count + 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        OrderDetailsTopTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailsTopTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.model;
        return cell;
    } else if (indexPath.row == 1) {
        OrderDetailsInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailsInfoTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.model;
        return cell;
    } else if (indexPath.row == 2) {
        OrderDetailsVIPTopTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailsVIPTopTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        OrderDetailsVIPContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailsVIPContentCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataAry[indexPath.row - 3];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 50 + [Tool heightForString:self.model.title width:kScreenW - 157 font:[UIFont systemFontOfSize:16]];
    } else if (indexPath.row == 1) {
        return 195;
    } else if (indexPath.row == 2) {
        return 44.5;
    } else {
        return self.dataAry[indexPath.row - 3].cellHeight + (indexPath.row - 3 == self.dataAry.count - 1 ? 11 : 0);
    }
}

@end
