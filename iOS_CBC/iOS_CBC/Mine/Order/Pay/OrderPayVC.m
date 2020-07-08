//
//  OrderPayVC.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/21.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "OrderPayVC.h"
#import "OrderPayTopTableCell.h"
#import "OrderPayTimeTableCell.h"
#import "OrderPayFunctionTableCell.h"
#import "OrderPayNoTimeTableCell.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "OrderPayResultVC.h"
#import "OrderPayResultV.h"

@interface OrderPayVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *backgroundV;
@property (weak, nonatomic) IBOutlet UIView *botV;
@property (nonatomic, strong) NSMutableArray *dataAry;

@property (nonatomic, assign) NSInteger timeIndex;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, assign) NSInteger functionIndex;
@property (nonatomic, strong) OrderInfoM *model;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (nonatomic, strong) OrderPayResultV *resultV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;

@end

@implementation OrderPayVC

- (OrderPayResultV *)resultV {
    if (!_resultV) {
        _resultV = [[NSBundle mainBundle] loadNibNamed:@"OrderPayResultV" owner:nil options:nil].firstObject;
        _resultV.frame = self.view.bounds;
        _resultV.alpha = 0;
        kWeakSelf
        _resultV.closeBlock = ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeUserUpdate object:nil];
            [weakSelf backAct];
//            [weakSelf refreshOrder];
        };
        [self.view addSubview:_resultV];
    }
    return _resultV;
}

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrder) name:kNoticeOrderRefresh object:nil];
    [super viewDidLoad];
    [self reloadData];
}

- (void)setViews {
    [self setNavigationBarWithTitle:@"会员购买" hasBackBtn:true];
    NSString *version= [UIDevice currentDevice].systemVersion;
    if (version.doubleValue < 11) {
        self.topCon.constant = 64;
        [self.view layoutIfNeeded];
    }
    self.baseTV.frame = CGRectMake(0, 0, kScreenW, kScreenH - kTopVH - kBottomH - 60);
    self.baseTV.backgroundColor = kHexColor(@"EEEEEE", 1);
    [self.baseTV registerNib:[UINib nibWithNibName:@"OrderPayTopTableCell" bundle:nil] forCellReuseIdentifier:@"OrderPayTopTableCell"];
    [self.baseTV registerNib:[UINib nibWithNibName:@"OrderPayTimeTableCell" bundle:nil] forCellReuseIdentifier:@"OrderPayTimeTableCell"];
    [self.baseTV registerNib:[UINib nibWithNibName:@"OrderPayNoTimeTableCell" bundle:nil] forCellReuseIdentifier:@"OrderPayNoTimeTableCell"];
    [self.baseTV registerNib:[UINib nibWithNibName:@"OrderPayFunctionTableCell" bundle:nil] forCellReuseIdentifier:@"OrderPayFunctionTableCell"];
    [self.backgroundV addSubview:self.baseTV];
    self.requestV.frame = self.backgroundV.bounds;
    [self.backgroundV addSubview:self.requestV];
    self.errorV.frame = self.backgroundV.bounds;
    [self.backgroundV addSubview:self.errorV];
}

- (void)resetViews {
    if (self.functionIndex == 0) {
        self.botV.alpha = 1;
        self.priceLab.textColor = kHexColor(@"FF8400", 1);
        self.payBtn.backgroundColor = kHexColor(@"FF8400", 1);
    } else {
        self.botV.alpha = 0.6;
        self.priceLab.textColor = [UIColor darkGrayColor];
        self.payBtn.backgroundColor = kHexColor(@"333333", 1);
    }
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
    [Tool POST:ORDERVIPINFO params:@[@{@"pass":PASS}] progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSDictionary * _Nonnull result) {
        OrderInfoM *model = [OrderInfoM mj_objectArrayWithKeyValuesArray:result[@"app_qx_info"]].firstObject;
        model.tip = [NSString stringWithFormat:@"打款后，会有专门的客服联系您！也可以拨打客服电话咨询，%@", [Tool shareInstance].user.kfphone];
        weakSelf.model = model;
        if (model.jieshao.length) {
            OrderCellM *topM = [[OrderCellM alloc] init];
            model.oriTitle = model.title;
            if (!weakSelf.duration) {
                weakSelf.duration = @"1";
            }
            model.title = weakSelf.isNew ? [NSString stringWithFormat:@"%@%@年", model.oriTitle, [Tool transYear:weakSelf.duration]] : weakSelf.name;
            topM.content = model.title;
            topM.type = 0;
            topM.cellHeight = 50 + [Tool heightForString:model.title width:kScreenW - 32 font:[UIFont systemFontOfSize:16]];
            [weakSelf.dataAry addObject:topM];
            for (NSString *str in [model.jieshao componentsSeparatedByString:@"、"]) {
                OrderCellM *contentM = [[OrderCellM alloc] init];
                contentM.content = str;
                contentM.type = 1;
                contentM.cellHeight = 6 + [Tool heightForString:str width:kScreenW - 76 font:[UIFont systemFontOfSize:14]];
                [weakSelf.dataAry addObject:contentM];
            }
            OrderCellM *botM = [[OrderCellM alloc] init];
            botM.type = 2;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDateFormatter *dateFormatte1 = [[NSDateFormatter alloc] init];
            [dateFormatte1 setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            if (weakSelf.isNew) {
                botM.content = [dateFormatter stringFromDate:[NSDate date]];
            } else {
                botM.content = [dateFormatter stringFromDate:[dateFormatte1 dateFromString:weakSelf.systemDate]];
            }
            botM.cellHeight = 40;
            [weakSelf.dataAry addObject:botM];
            [weakSelf.dataAry addObject:model];
            [weakSelf.baseTV reloadData];
            weakSelf.baseTV.alpha = 1;
            weakSelf.requestV.alpha = 0;
            weakSelf.errorV.alpha = 0;
            weakSelf.botV.alpha = 1;
            if (!weakSelf.payMoney) {
                weakSelf.payMoney = model.price1_new;
            }
            weakSelf.priceLab.text = [NSString stringWithFormat:@"¥%@", weakSelf.payMoney];
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
}

- (IBAction)payAct:(id)sender {
    if (self.functionIndex == 0) {
        if (self.isNew) {
            kWeakSelf
            [Tool showProgressDark];
            NSString *year = @[self.model.year1, self.model.year2, self.model.year3][self.timeIndex];

            [Tool POST:ORDERADD params:@[@{@"vipid":[Tool shareInstance].user.ID}, @{@"type":@"1"}, @{@"year":year}, @{@"paymoney":self.payMoney}, @{@"pass":PASS}] progress:^(NSProgress * _Nonnull progress) {
                
            } success:^(NSDictionary * _Nonnull result) {
                if ([result[@"Vip_OrderNumber"] isKindOfClass:[NSArray class]]) {
                    NSArray<OrderInfoM *> *ary = [OrderInfoM mj_objectArrayWithKeyValuesArray:result[@"Vip_OrderNumber"]];
                    if (ary.count) {
                        weakSelf.orderNum = ary[0].ordernumber;
                        [weakSelf toPayAct];
                    } else {
                        [Tool showStatusDark:@"请求失败"];
                    }
                } else {
                    [Tool showStatusDark:@"请求失败"];
                }
            } failure:^(NSString * _Nonnull error) {
                [Tool showStatusDark:@"请求失败"];
            }];
        } else {
            [self toPayAct];
        }
    }
}

- (void)toPayAct {
    [Tool showProgressDark];
    [Tool POST:ORDERPAYINFO params:@[@{@"vipid":[Tool shareInstance].user.ID}, @{@"loginname":[Tool shareInstance].user.phone}, @{@"ordernumber":self.orderNum}, @{@"ip":@""}, @{@"money":self.payMoney}, @{@"spmemo":@"IOS支付"}, @{@"keyname":@"wxzhifuinfo"}, @{@"pass":PASS}] progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSDictionary * _Nonnull result) {
        PayReq *request = [PayReq mj_objectArrayWithKeyValuesArray:result[@"wxzhifuinfo"]].firstObject;
        request.partnerId = @"1487051292";
        request.package = @"Sign=WXPay";
        [WXApi sendReq:request completion:^(BOOL success) {
            if (success) {
                [Tool dismiss];
                [Tool shareInstance].shouldRequestOrder = true;
            } else {
                [Tool showStatusDark:@"请求失败"];
            }
        }];
    } failure:^(NSString * _Nonnull error) {
        [Tool showStatusDark:@"请求失败"];
    }];
}

- (void)refreshOrder {
    [Tool showProgressDark];
    [self performSelector:@selector(refreshAct) withObject:nil afterDelay:1];
}

- (void)refreshAct {
    kWeakSelf
    [Tool POST:ORDERINFO params:@[@{@"ordernumber":self.orderNum}, @{@"pass":PASS}] progress:^(NSProgress * _Nonnull infoProgress) {
                    
    } success:^(NSDictionary * _Nonnull infoResult) {
        OrderPrivacyInfoM *tempModel = [OrderPrivacyInfoM mj_objectArrayWithKeyValuesArray:infoResult[@"orderinfo1"]].firstObject;
        NSString *state = [Tool decryptString:tempModel.state];
        if ([state isEqualToString:@"0"]) {
            if (weakSelf.isNew) {
                [Tool dismiss];
                [weakSelf.resultV showView];
            } else {
                [Tool showStatusDark:@"支付失败"];
            }
        } else {
            [Tool dismiss];
            OrderPayResultVC *vc = [[OrderPayResultVC alloc] initWithNibName:@"OrderPayResultVC" bundle:nil];
            OrderInfoM *model = [[OrderInfoM alloc] init];
            model.oriTitle = weakSelf.model.oriTitle;
            model.jieshao = weakSelf.model.jieshao;
            model.duration = weakSelf.duration;
            model.payMoney = weakSelf.payMoney;
            vc.model = model;
            [weakSelf.navigationController pushViewController:vc animated:true];
        }
    } failure:^(NSString * _Nonnull infoError) {
        [weakSelf refreshOrder];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count + 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    kWeakSelf
    if (indexPath.row < self.dataAry.count) {
        BaseM *model = self.dataAry[indexPath.row];
        if ([model isKindOfClass:[OrderCellM class]]) {
            OrderPayTopTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPayTopTableCell" forIndexPath:indexPath];
            cell.model = (OrderCellM *)model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            if (self.isNew) {
                OrderPayTimeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPayTimeTableCell" forIndexPath:indexPath];
                cell.index = self.timeIndex;
                cell.model = (OrderInfoM *)model;
                cell.selectBlock = ^(NSInteger index, NSString *timeStr) {
                    OrderCellM *topM = weakSelf.dataAry[0];
                    weakSelf.model.duration = @[weakSelf.model.year1, weakSelf.model.year2, weakSelf.model.year3][index];
                    weakSelf.duration = weakSelf.model.duration;
                    weakSelf.model.title = [NSString stringWithFormat:@"%@%@年", weakSelf.model.oriTitle, [Tool transYear:weakSelf.model.duration]];
                    topM.content = weakSelf.model.title;
                    topM.type = 0;
                    topM.cellHeight = 48 + [Tool heightForString:weakSelf.model.title width:kScreenW - 32 font:[UIFont systemFontOfSize:15]];
                    [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                    weakSelf.timeIndex = index;
                    weakSelf.timeStr = timeStr;
                    weakSelf.payMoney = weakSelf.timeStr;
                    weakSelf.priceLab.text = [NSString stringWithFormat:@"¥%@", timeStr];
                };
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            } else {
                OrderPayNoTimeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPayNoTimeTableCell" forIndexPath:indexPath];
                cell.duration = self.duration;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
        }
    } else {
        OrderPayFunctionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPayFunctionTableCell" forIndexPath:indexPath];
        if (indexPath.row == self.dataAry.count + 2) {
            cell.isChoice = self.functionIndex == 2;
            cell.type = OrderPayFunctionTypeBank;
            cell.model = self.model;
        } else if (indexPath.row == self.dataAry.count + 1) {
            cell.isChoice = self.functionIndex == 1;
            cell.type = OrderPayFunctionTypeAli;
            cell.model = self.model;
        } else if (indexPath.row == self.dataAry.count) {
            cell.isChoice = self.functionIndex == 0;
            cell.type = OrderPayFunctionTypeWechat;
            cell.model = self.model;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataAry.count) {
        BaseM *model = self.dataAry[indexPath.row];
        if ([model isKindOfClass:[OrderCellM class]]) {
            return ((OrderCellM *)model).cellHeight;
        } else {
            return self.isNew ? 166 : 123.5;
        }
    } else {
        if (indexPath.row == self.dataAry.count + 2) {
            return self.functionIndex == 2 ? 126 + [Tool heightForString:self.model.zhname width:kScreenW - 125 font:[UIFont systemFontOfSize:13]] + [Tool heightForString:self.model.account width:kScreenW - 125 font:[UIFont systemFontOfSize:13]] + [Tool heightForString:self.model.bank width:kScreenW - 125 font:[UIFont systemFontOfSize:13]] + [Tool heightForString:self.model.tip width:kScreenW - 52 font:[UIFont systemFontOfSize:12]] : 50;
        } else {
            return 50;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > self.dataAry.count - 1) {
        if (indexPath.row - self.dataAry.count == 1) {
            return;
        }
        if (self.functionIndex != indexPath.row - self.dataAry.count) {
            self.functionIndex = indexPath.row - self.dataAry.count;
            [self resetViews];
            [UIView setAnimationsEnabled:false];
//            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:true];
//            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataAry.count inSection:0], [NSIndexPath indexPathForRow:self.dataAry.count + 1 inSection:0], [NSIndexPath indexPathForRow:self.dataAry.count + 2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadData];
            [UIView setAnimationsEnabled:true];
        }
    }
}

@end
