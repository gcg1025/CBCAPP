//
//  MyOrderVC.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/24.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "MyOrderVC.h"
#import "MyOrderTableCell.h"
#import "OrderDetailsVC.h"

@interface MyOrderVC () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleL;
@property (weak, nonatomic) IBOutlet UIView *leftTitleLineV;
@property (weak, nonatomic) IBOutlet UILabel *middleTitleL;
@property (weak, nonatomic) IBOutlet UIView *middleTitleLineV;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleL;
@property (weak, nonatomic) IBOutlet UIView *rightTitleLineV;
@property (assign, nonatomic) NSInteger selectIndex;

@property (strong, nonatomic) BaseTV *leftTV;
@property (weak, nonatomic) IBOutlet UIView *leftBGV;
@property (strong, nonatomic) NSMutableArray *leftAry;
@property (strong, nonatomic) RequestV *leftRequestV;
@property (strong, nonatomic) ErrorV *leftErrorV;

@property (strong, nonatomic) BaseTV *middleTV;
@property (weak, nonatomic) IBOutlet UIView *middleBGV;
@property (assign, nonatomic) NSInteger middlePage;
@property (strong, nonatomic) NSMutableArray *middleAry;
@property (strong, nonatomic) RequestV *middleRequestV;
@property (strong, nonatomic) ErrorV *middleErrorV;

@property (strong, nonatomic) BaseTV *rightTV;
@property (weak, nonatomic) IBOutlet UIView *rightBGV;
@property (assign, nonatomic) NSInteger rightPage;
@property (strong, nonatomic) NSMutableArray *rightAry;
@property (strong, nonatomic) RequestV *rightRequestV;
@property (strong, nonatomic) ErrorV *rightErrorV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;

@end

@implementation MyOrderVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.shouleRefresh) {
        self.shouleRefresh = false;
        [self reloadData];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectIndex = 0;
    [self resetViews];
    [self reloadData];
}

- (void)resetViews {
    [self setViewWithIndex];
    self.scrollView.contentOffset = CGPointMake(self.selectIndex * kScreenW, 0);
}

- (void)setViews {
    [self setNavigationBarWithTitle:@"我的订单" hasBackBtn:true];
    
    NSString *version= [UIDevice currentDevice].systemVersion;
    if (version.doubleValue < 11) {
        self.topCon.constant = 64;
        [self.view layoutIfNeeded];
    }
    
    self.leftTV = [[BaseTV alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTopVH - kBottomH - 44)];
    self.leftTV.backgroundColor = kHexColor(@"eeeeee", 1);
    self.leftTV.delegate = self;
    self.leftTV.dataSource = self;
    [self.leftTV registerNib:[UINib nibWithNibName:@"MyOrderTableCell" bundle:nil] forCellReuseIdentifier:@"MyOrderTableCell"];
    self.leftTV.alpha = 0;
    [self.leftBGV addSubview:self.leftTV];
    kWeakSelf
    self.leftTV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
    self.leftRequestV = [self createRequestV];
    self.leftRequestV.frame = self.leftBGV.bounds;
    self.leftRequestV.alpha = 0;
    [self.leftBGV addSubview:self.leftRequestV];
    self.leftErrorV = [self createErrorV];
    [self.leftBGV addSubview:self.leftErrorV];
    self.leftErrorV.frame = self.leftBGV.bounds;
    self.leftErrorV.buttonClick = ^{
        [weakSelf reloadData];
    };
    self.leftErrorV.alpha = 0;
    
    self.middleTV = [[BaseTV alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTopVH - kBottomH - 44)];
    self.middleTV.backgroundColor = kHexColor(@"eeeeee", 1);
    self.middleTV.delegate = self;
    self.middleTV.dataSource = self;
    [self.middleTV registerNib:[UINib nibWithNibName:@"MyOrderTableCell" bundle:nil] forCellReuseIdentifier:@"MyOrderTableCell"];
    self.middleTV.alpha = 0;
    [self.middleBGV addSubview:self.middleTV];
    self.middleRequestV = [self createRequestV];
    self.middleRequestV.frame = self.middleBGV.bounds;
    self.middleRequestV.alpha = 0;
    [self.middleBGV addSubview:self.middleRequestV];
    self.middleErrorV = [self createErrorV];
    self.middleErrorV.frame = self.middleBGV.bounds;
    self.middleErrorV.alpha = 0;
    self.middleErrorV.buttonClick = ^{
        [weakSelf reloadData];
    };
    [self.middleBGV addSubview:self.middleErrorV];
    
    self.rightTV = [[BaseTV alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTopVH - kBottomH - 44)];
    self.rightTV.backgroundColor = kHexColor(@"eeeeee", 1);
    self.rightTV.delegate = self;
    self.rightTV.dataSource = self;
    [self.rightTV registerNib:[UINib nibWithNibName:@"MyOrderTableCell" bundle:nil] forCellReuseIdentifier:@"MyOrderTableCell"];
    self.rightTV.alpha = 0;
    [self.rightBGV addSubview:self.rightTV];
    self.rightRequestV = [self createRequestV];
    self.rightRequestV.frame = self.rightBGV.bounds;
    self.rightRequestV.alpha = 0;
    [self.rightBGV addSubview:self.rightRequestV];
    self.rightErrorV = [self createErrorV];
    self.rightErrorV.frame = self.rightBGV.bounds;
    self.rightErrorV.alpha = 0;
    self.rightErrorV.buttonClick = ^{
        [weakSelf reloadData];
    };
    [self.rightBGV addSubview:self.rightErrorV];
}

- (void)reloadData {
    if (![Tool shareInstance].user) {
        return;
    }
    if (![Tool shareInstance].user.ID) {
        return;
    }
    self.leftTV.alpha = 0;
    self.leftRequestV.alpha = 1;
    self.leftErrorV.alpha = 0;
    self.middleTV.alpha = 0;
    self.middleRequestV.alpha = 1;
    self.middleErrorV.alpha = 0;
    self.rightTV.alpha = 0;
    self.rightRequestV.alpha = 1;
    self.rightErrorV.alpha = 0;
    [self requestData];
}

- (void)requestData {
    kWeakSelf
    [Tool POST:ORDERLIST params:@[@{@"vipid":[Tool shareInstance].user.ID}, @{@"keyname":@"orderlist"}, @{@"pass":PASS}] progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSDictionary * _Nonnull result) {
        [weakSelf.leftTV.mj_header endRefreshing];
        weakSelf.leftAry = @[].mutableCopy;
        weakSelf.middleAry = @[].mutableCopy;
        weakSelf.rightAry = @[].mutableCopy;
        NSMutableArray<OrderInfoM *> *dataAry = [OrderInfoM mj_objectArrayWithKeyValuesArray:result[@"orderlist"]];
        for (OrderInfoM *model in dataAry) {
            model.duration = @([model.vipdate componentsSeparatedByString:@"/"].firstObject.integerValue - [model.startdate componentsSeparatedByString:@"/"].firstObject.integerValue).stringValue;
            model.title = [NSString stringWithFormat:@"%@%@年", model.title, [Tool transYear:model.duration]];
            
            NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
            [dayFormatter setDateFormat:@"yyyy/MM/dd"];
            NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
            [timeFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            NSArray<NSString *> *dateAry = [model.vipdate componentsSeparatedByString:@" "];
            model.cellHeight = 185 + [Tool heightForString:model.title width:kScreenW - 112 font:[UIFont systemFontOfSize:17]];
            if (model.state == 1) {
                if (dateAry.count) {
                    NSTimeInterval endT = [dayFormatter dateFromString:dateAry[0]].timeIntervalSince1970;
                    NSTimeInterval currentT = [dayFormatter dateFromString:[dayFormatter stringFromDate:[NSDate date]]].timeIntervalSince1970;
                    if (endT > currentT + 30 * 24 * 3600) {
                        model.cellHeight = 145 + [Tool heightForString:model.title width:kScreenW - 112 font:[UIFont systemFontOfSize:17]];
                    }
                }
            }
            if (model.state) {
                [weakSelf.rightAry addObject:model];
            } else {
                [weakSelf.middleAry addObject:model];
            }
            [weakSelf.leftAry addObject:model];
        }
        if (weakSelf.leftAry.count == 0) {
            OrderInfoM *infoM = [[OrderInfoM alloc] init];
            infoM.cellHeight = kScreenH - kTopVH - kBottomH - 40;
            [weakSelf.leftAry addObject:infoM];
        }
        if (weakSelf.middleAry.count == 0) {
            OrderInfoM *infoM = [[OrderInfoM alloc] init];
            infoM.cellHeight = kScreenH - kTopVH - kBottomH - 40;
            [weakSelf.middleAry addObject:infoM];
        }
        if (weakSelf.rightAry.count == 0) {
            OrderInfoM *infoM = [[OrderInfoM alloc] init];
            infoM.cellHeight = kScreenH - kTopVH - kBottomH - 40;
            [weakSelf.rightAry addObject:infoM];
        }
        [weakSelf.leftTV reloadData];
        weakSelf.leftTV.alpha = 1;
        weakSelf.leftRequestV.alpha = 0;
        weakSelf.leftErrorV.alpha = 0;
        [weakSelf.middleTV reloadData];
        weakSelf.middleTV.alpha = 1;
        weakSelf.middleRequestV.alpha = 0;
        weakSelf.middleErrorV.alpha = 0;
        [weakSelf.rightTV reloadData];
        weakSelf.rightTV.alpha = 1;
        weakSelf.rightRequestV.alpha = 0;
        weakSelf.rightErrorV.alpha = 0;
    } failure:^(NSString * _Nonnull error) {
        [weakSelf.leftTV.mj_header endRefreshing];
        [weakSelf requestError];
    }];
}

- (void)requestError {
    self.leftTV.alpha = 0;
    self.leftRequestV.alpha = 0;
    self.leftErrorV.alpha = 1;
    self.middleTV.alpha = 0;
    self.middleRequestV.alpha = 0;
    self.middleErrorV.alpha = 1;
    self.rightTV.alpha = 0;
    self.rightRequestV.alpha = 0;
    self.rightErrorV.alpha = 1;
}

#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTV) {
        return self.leftAry.count;
    } else if (tableView == self.middleTV) {
        return self.middleAry.count;
    } else if (tableView == self.rightTV) {
        return self.rightAry.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderInfoM *model = [[OrderInfoM alloc] init];
    if (tableView == self.leftTV) {
        if (indexPath.row < self.leftAry.count) {
            model = self.leftAry[indexPath.row];
        }
    } else if (tableView == self.middleTV) {
        if (indexPath.row < self.middleAry.count) {
            model = self.middleAry[indexPath.row];
        }
    } else if (tableView == self.rightTV) {
        if (indexPath.row < self.rightAry.count) {
            model = self.rightAry[indexPath.row];
        }
    }
    if (model.title.length) {
        kWeakSelf
        MyOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        cell.selectBlock = ^(OrderInfoM * _Nonnull model) {
            if (model.state) {
                [weakSelf toOrderAct];
            } else {
                OrderPayVC *vc = [[OrderPayVC alloc] initWithNibName:@"OrderPayVC" bundle:nil];
                vc.isNew = false;
                vc.orderNum = model.orderNumber;
                vc.duration = model.duration;
                vc.name = model.title;
                vc.payMoney = model.payMoney;
                vc.systemDate = model.systemDate;
                [self.navigationController pushViewController:vc animated:true];
            }
        };
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        NoDataV *v = [[[NSBundle mainBundle] loadNibNamed:@"NoDataV" owner:nil options:NULL] lastObject];
        v.viewType = NoDataViewTypeOrder;
        v.frame = cell.bounds;
        [cell.contentView addSubview:v];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderInfoM *model = [[OrderInfoM alloc] init];
    if (tableView == self.leftTV) {
        if (indexPath.row < self.leftAry.count) {
            model = self.leftAry[indexPath.row];
        }
    } else if (tableView == self.middleTV) {
        if (indexPath.row < self.middleAry.count) {
            model = self.middleAry[indexPath.row];
        }
    } else if (tableView == self.rightTV) {
        if (indexPath.row < self.rightAry.count) {
            model = self.rightAry[indexPath.row];
        }
    }
    if (model.orderNumber) {
        OrderDetailsVC *vc = [[OrderDetailsVC alloc] initWithNibName:@"OrderDetailsVC" bundle:nil];
        vc.orderNum = model.orderNumber;
        [self.navigationController pushViewController:vc animated:true];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderInfoM *model = [[OrderInfoM alloc] init];
    if (tableView == self.leftTV) {
        if (indexPath.row < self.leftAry.count) {
            model = self.leftAry[indexPath.row];
        }
    } else if (tableView == self.middleTV) {
        if (indexPath.row < self.middleAry.count) {
            model = self.middleAry[indexPath.row];
        }
    } else if (tableView == self.rightTV) {
        if (indexPath.row < self.rightAry.count) {
            model = self.rightAry[indexPath.row];
        }
    }
    return model.cellHeight ? model.cellHeight : 1;
}

- (IBAction)selectAct:(UIButton *)sender {
    if (self.selectIndex != sender.tag - 30000) {
        self.selectIndex = sender.tag - 30000;
        [self setViewWithIndex];
        kWeakSelf
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.scrollView.contentOffset = CGPointMake(weakSelf.selectIndex * kScreenW, 0);
        }];
    }
}

- (void)setViewWithIndex {
    self.leftTitleL.textColor = self.selectIndex == 0 ? kHexColor(@"000000", 1) : [UIColor darkGrayColor];
    self.leftTitleLineV.alpha = self.selectIndex == 0 ? 1 : 0;
    self.middleTitleL.textColor = self.selectIndex == 1 ? kHexColor(@"000000", 1) : [UIColor darkGrayColor];
    self.middleTitleLineV.alpha = self.selectIndex == 1 ? 1 : 0;
    self.rightTitleL.textColor = self.selectIndex == 2 ? kHexColor(@"000000", 1) : [UIColor darkGrayColor];
    self.rightTitleLineV.alpha = self.selectIndex == 2 ? 1 : 0;
}

#pragma mark scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        if (scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x < kScreenW ) {
            if (self.selectIndex != 0) {
                self.selectIndex = 0;
                [self setViewWithIndex];
            }
        } else if (scrollView.contentOffset.x >= kScreenW && scrollView.contentOffset.x < kScreenW * 2) {
            if (self.selectIndex != 1) {
                self.selectIndex = 1;
                [self setViewWithIndex];
            }
        } else if (scrollView.contentOffset.x >= kScreenW * 2 && scrollView.contentOffset.x < kScreenW * 3) {
            if (self.selectIndex != 2) {
                self.selectIndex = 2;
                [self setViewWithIndex];
            }
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
