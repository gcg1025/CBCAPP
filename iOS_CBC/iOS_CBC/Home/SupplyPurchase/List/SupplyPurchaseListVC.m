//
//  SupplyPurchaseListVC.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/26.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "SupplyPurchaseListVC.h"
#import "SupplyPurchaseCollectionCell.h"
#import "SupplyPurchaseTableCell.h"
#import "SupplyPurchaseDetailsVC.h"

@interface SupplyPurchaseListVC () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *classBackgroundV;
@property (weak, nonatomic) IBOutlet UILabel *supplyTitleLab;
@property (weak, nonatomic) IBOutlet UIView *supplyLineV;
@property (weak, nonatomic) IBOutlet UILabel *purchaseTitleLab;
@property (weak, nonatomic) IBOutlet UIView *purchaseLineV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *classBackgroundVHeiCon;

@property (weak, nonatomic) IBOutlet UIView *backgroundV;

@property (nonatomic, strong) NSMutableArray<DistributionClassM *> *classAry;
@property (nonatomic, strong) NSMutableArray<DistributionM *> *dataAry;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSString *proID;
@property (nonatomic, assign) NSInteger classIndex;
@property (nonatomic, assign) CGFloat classVHei;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;


@end

@implementation SupplyPurchaseListVC

- (void)viewDidLoad {
    [self setAry];
    [super viewDidLoad];
    [self reloadData];
}

- (void)setAry {
    self.classAry = [DistributionClassM mj_objectArrayWithKeyValuesArray:[Tool supplyPurchaseAry]];
//    self.classVHei = 5;
//    NSInteger row = (self.classAry.count - 1) / 5;
//    for (NSInteger i = 0; i <= row; i ++) {
//        CGFloat hei = 46;
//        for (NSInteger j = 0; j < 5; j ++) {
//            if (j + i * 5 < self.classAry.count) {
//                DistributionClassM *model = self.classAry[j + i * 5];
//                CGFloat nameHei = [Tool heightForString:model.name width:(kScreenW - 10) / 5 - 20 font:[UIFont systemFontOfSize:15]] + 28;
//                if (nameHei > hei) {
//                    hei = nameHei;
//                }
//            }
//
//        }
//        for (NSInteger j = 0; j < 5; j ++) {
//            if (j + i * 5 < self.classAry.count) {
//                self.classAry[j + i * 5].cellHeight = hei;
//            }
//        }
//        self.classVHei += hei;
//    }
    self.classAry[0].isSelect = true;
}

- (void)setViews {
    [self setNavigationBarWithTitle:@"供求信息" hasBackBtn:true];
    NSString *version= [UIDevice currentDevice].systemVersion;
    if (version.doubleValue < 11) {
        self.topCon.constant = 64;
        [self.view layoutIfNeeded];
    }
//    self.topCon.constant =
//    self.classBackgroundVHeiCon.constant = self.classVHei;
//    [self.view layoutIfNeeded];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize  = CGSizeMake((kScreenW - 10) / 5, 40);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.baseCV = [[BaseCV alloc] initWithFrame:CGRectMake(5, 5, kScreenW - 10, 165) collectionViewLayout:layout];
    self.baseCV.backgroundColor = [UIColor whiteColor];
    self.baseCV.delegate = self;
    self.baseCV.dataSource = self;
    [self.baseCV registerNib:[UINib nibWithNibName:@"SupplyPurchaseCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"SupplyPurchaseCollectionCell"];
    [self.classBackgroundV addSubview:self.baseCV];
    [self.baseCV reloadData];
    self.proID = self.classAry[0].IDS;
    self.baseTV.frame = CGRectMake(0, 0, kScreenW, kScreenH - kTopVH - kBottomH - 165 - 44);
    kWeakSelf
    self.baseTV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
    [self.baseTV registerNib:[UINib nibWithNibName:@"SupplyPurchaseTableCell" bundle:nil] forCellReuseIdentifier:@"SupplyPurchaseTableCell"];
    if (@available(iOS 11.0, *)) {
        self.baseTV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
         self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.backgroundV addSubview:self.baseTV];
    self.requestV.frame = self.backgroundV.bounds;
    [self.backgroundV addSubview:self.requestV];
    self.errorV.frame = self.backgroundV.bounds;
    [self.backgroundV addSubview:self.errorV];
}

- (void)reloadData {
    self.baseTV.contentOffset = CGPointMake(0, 0);
    self.requestV.alpha = 1;
    self.errorV.alpha = 0;
    self.baseTV.alpha = 0;
    self.dataAry = @[].mutableCopy;
    kWeakSelf
    self.baseTV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
    [self requestData];
}

- (void)requestData {
    kWeakSelf
    NSString *proID = self.proID;
    NSInteger pageIndex = self.pageIndex;
    [Tool POST:SUPPLYPURCHASE params:@[@{@"count":@"20"}, @{@"productid":self.proID}, @{@"gqtype":@(self.pageIndex + 1).stringValue}, @{@"date":self.dataAry.count ? self.dataAry.lastObject.sysdate : @""}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSDictionary * _Nonnull result) {
        if ([proID isEqualToString:weakSelf.proID] && pageIndex == weakSelf.pageIndex) {
            if (weakSelf.baseTV.alpha) {
                if (weakSelf.baseTV.mj_footer) {
                    [weakSelf.baseTV.mj_footer endRefreshing];
                }
            }
            NSArray *ary = [DistributionM mj_objectArrayWithKeyValuesArray:result[@"mallslist"]];
            for (DistributionM *model in ary) {
                model.cellHeight = [Tool heightForString:model.infotitle width:kScreenW - 116 font:[UIFont systemFontOfSize:15]] + 22;
            }
            if (ary.count < 20) {
                [weakSelf.baseTV.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelf.dataAry addObjectsFromArray:ary];
            if (weakSelf.dataAry.count == 0) {
                DistributionM *model = [[DistributionM alloc] init];
                model.cellHeight = kScreenH - kTopVH - kBottomH - 243;
                [weakSelf.dataAry addObject:model];
                weakSelf.baseTV.mj_footer = nil;
            }
            weakSelf.requestV.alpha = 0;
            weakSelf.errorV.alpha = 0;
            weakSelf.baseTV.alpha = 1;
            [weakSelf.baseTV reloadData];
        }
    } failure:^(NSString * _Nonnull error) {
        if ([proID isEqualToString:weakSelf.proID] && pageIndex == weakSelf.pageIndex) {
            if (weakSelf.dataAry.count) {
                [weakSelf.baseTV.mj_footer endRefreshing];
            } else {
                weakSelf.errorV.alpha = 1;
                weakSelf.requestV.alpha = 0;
                weakSelf.baseTV.alpha = 0;
            }
        }
    }];
}

- (IBAction)pageSelectAct:(UIButton *)sender {
    [self pageSelectWithIndex:sender.tag - 30000];
}

- (void)pageSelectWithIndex:(NSInteger)index {
    if (self.pageIndex != index) {
        self.pageIndex = index;
        self.supplyTitleLab.textColor = kHexColor(self.pageIndex ? @"000000" : kNavBackgroundColorHex, 1);
        self.supplyLineV.backgroundColor = kHexColor(self.pageIndex ? @"BBBBBB" : kNavBackgroundColorHex, 1);
        self.purchaseTitleLab.textColor = kHexColor(self.pageIndex ? kNavBackgroundColorHex : @"000000", 1);
        self.purchaseLineV.backgroundColor = kHexColor(self.pageIndex ? kNavBackgroundColorHex : @"BBBBBB", 1);
        [self reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataAry.count) {
        DistributionM *model = self.dataAry[indexPath.row];
        if (model.ID == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            NoDataV *v = [[[NSBundle mainBundle] loadNibNamed:@"NoDataV" owner:nil options:NULL] lastObject];
            v.viewType = self.pageIndex + 3;
            v.frame = cell.bounds;
            [cell.contentView addSubview:v];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            SupplyPurchaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupplyPurchaseTableCell" forIndexPath:indexPath];
            cell.model = self.dataAry[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataAry.count) {
        if (self.dataAry[0].ID == 0) {
            return self.dataAry[indexPath.row].cellHeight;
        } else {
            return 63;
        }
    } else {
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataAry.count) {
        if (self.dataAry[0].ID != 0) {
            SupplyPurchaseDetailsVC *vc = [[SupplyPurchaseDetailsVC alloc] init];
            vc.model = self.dataAry[indexPath.row];
            [self.navigationController pushViewController:vc animated:true];
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.classAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SupplyPurchaseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SupplyPurchaseCollectionCell" forIndexPath:indexPath];
    cell.model = self.classAry[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenW - 10) / 5, 40);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.classIndex != indexPath.row) {
        self.classAry[self.classIndex].isSelect = false;
        self.classAry[indexPath.row].isSelect = true;
        self.classIndex = indexPath.row;
        self.proID = self.classAry[indexPath.row].IDS;
        [self.baseCV reloadData];
        [self reloadData];
    }
    
}

@end
