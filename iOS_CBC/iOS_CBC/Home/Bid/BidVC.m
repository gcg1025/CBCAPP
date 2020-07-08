//
//  BidVC.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/11.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "BidVC.h"
#import "SupplyPurchaseCollectionCell.h"
#import "EntBidPriceTableCell.h"
#import "NewsCell.h"
#import "NewsDetailsVC.h"
#import "TableTitleV.h"

@interface BidVC () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *logImgV;
@property (weak, nonatomic) IBOutlet UIView *classBackgroundV;
@property (weak, nonatomic) IBOutlet UILabel *supplyTitleLab;
@property (weak, nonatomic) IBOutlet UIView *supplyLineV;
@property (weak, nonatomic) IBOutlet UILabel *purchaseTitleLab;
@property (weak, nonatomic) IBOutlet UIView *purchaseLineV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *classBackgroundVHeiCon;

@property (weak, nonatomic) IBOutlet UIView *backgroundV;
@property (weak, nonatomic) IBOutlet UIView *backgroundTitleV;
@property (weak, nonatomic) IBOutlet UIView *backgroundContentV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundTitleVHeiCon;

@property (nonatomic, strong) NSMutableArray<DistributionClassM *> *classAry;
@property (nonatomic, strong) NSMutableArray<BaseM *> *dataAry;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSString *proID;
@property (nonatomic, assign) NSInteger classIndex;
@property (nonatomic, assign) CGFloat classVHei;
@property (nonatomic, strong) TableTitleV *tableTitleV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;

@end

@implementation BidVC

- (void)viewDidLoad {
    [self setAry];
    [super viewDidLoad];
    [self reloadData];
}

- (void)setAry {
    self.classAry = [DistributionClassM mj_objectArrayWithKeyValuesArray:[Tool bidAry]];
    self.classAry[0].isSelect = true;
}

- (void)setViews {
    [self setNavigationBarWithTitle:@"钢厂招标" hasBackBtn:true];
    NSString *version= [UIDevice currentDevice].systemVersion;
    if (version.doubleValue < 11) {
        self.topCon.constant = 64;
        [self.view layoutIfNeeded];
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize  = CGSizeMake((kScreenW - 10) / 5, 40);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.classBackgroundVHeiCon.constant = 165;
    [self loadViewIfNeeded];
    self.baseCV = [[BaseCV alloc] initWithFrame:CGRectMake(5, 5, kScreenW - 10, 165) collectionViewLayout:layout];
    self.baseCV.backgroundColor = [UIColor whiteColor];
    self.baseCV.delegate = self;
    self.baseCV.dataSource = self;
    [self.baseCV registerNib:[UINib nibWithNibName:@"SupplyPurchaseCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"SupplyPurchaseCollectionCell"];
    [self.classBackgroundV addSubview:self.baseCV];
    [self.baseCV reloadData];
    self.proID = self.classAry[0].IDS;
    self.tableTitleV = [[NSBundle mainBundle] loadNibNamed:@"TableTitleV" owner:nil options:nil].firstObject;
    self.tableTitleV.frame = self.backgroundTitleV.bounds;
    self.tableTitleV.type = 2;
    [self.backgroundTitleV addSubview:self.tableTitleV];
    self.baseTV.frame = CGRectMake(0, 0, kScreenW, kScreenH - kTopVH - kBottomH - 165 - 84);
    self.baseTV.backgroundColor = [UIColor clearColor];
    kWeakSelf
    self.baseTV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
    [self.baseTV registerNib:[UINib nibWithNibName:@"EntBidPriceTableCell" bundle:nil] forCellReuseIdentifier:@"EntBidPriceTableCell"];
    [self.baseTV registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:@"NewsCell"];
    [self.backgroundContentV addSubview:self.baseTV];
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
    if (pageIndex == 0) {
        [Tool POST:JURISDICATION params:@[@{@"vipid":[Tool shareInstance].user.ID}, @{@"productid":[proID isEqualToString:@"000000"] ? @"476" : proID}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull jurProgress) {
            
        } success:^(NSDictionary * _Nonnull jurResult) {
            [[Tool shareInstance].user.jurDic setValue:jurResult[@"ViewState"] forKey:proID];
            NSMutableArray<PriceEntBidM *> *dataAry = @[].mutableCopy;
            if (weakSelf.dataAry.count) {
                if ([weakSelf.dataAry[0] isKindOfClass:[PriceEntBidM class]]) {
                    dataAry =  (NSMutableArray<PriceEntBidM *> *)weakSelf.dataAry;
                }
            }
            [Tool POST:BIDPRICE params:@[@{@"count":weakSelf.dataAry.count == 0 ? @"20" : @"10"}, @{@"productid":self.proID}, @{@"date":dataAry.count ? [dataAry[0].pdate componentsSeparatedByString:@" "][0] : @""}, @{@"compare_id": dataAry.count ? @(dataAry.lastObject.ID).stringValue : @"0"}, @{@"productid_small":@"0"}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull progress) {
                
            } success:^(NSDictionary * _Nonnull result) {
                [Tool POST:VIEWLOG params:@[@{@"viewid":proID}, @{@"type":@"1"}, @{@"vipid":[Tool shareInstance].user.ID}, @{@"isvip":@"1"}, @{@"issuccess":[[Tool shareInstance].user.jurDic[weakSelf.proID] isEqualToString:@"1"] ? @"1" : @"0"}, @{@"remark":@""}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull logProgress) {
                    
                } success:^(NSDictionary * _Nonnull logResult) {
                    
                } failure:^(NSString * _Nonnull logError) {
                    
                }];
                if ([proID isEqualToString:weakSelf.proID] && pageIndex == weakSelf.pageIndex) {
                    NSArray *priceList = [PriceEntBidM mj_objectArrayWithKeyValuesArray:result[@"cgjpricelist"]];
                    if (weakSelf.baseTV.alpha) {
                        if (weakSelf.baseTV.mj_footer) {
                            [weakSelf.baseTV.mj_footer endRefreshing];
                        }
                    }
                    if (priceList.count < (weakSelf.dataAry.count == 0 ? 20 : 10)) {
                        [weakSelf.baseTV.mj_footer endRefreshingWithNoMoreData];
                    }
                    for (PriceEntBidM *priceEntBidM in priceList) {
                        priceEntBidM.isEnt = false;
                        priceEntBidM.jurIDStr = proID;
                        priceEntBidM.productid_name = [[Tool htmlTranslat:priceEntBidM.productid_name font:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]].string stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
                        CGFloat nameHei = [Tool heightForString:priceEntBidM.productid_name width:80 * weakSelf.kScale font:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]];
                        priceEntBidM.companyname = [[Tool htmlTranslat:priceEntBidM.companyname font:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]].string stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
                        CGFloat comHei = [Tool heightForString:priceEntBidM.companyname width:kScreenW - 240 * weakSelf.kScale font:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]];
                        priceEntBidM.cg_str = [NSString stringWithFormat:@"%@%@", priceEntBidM.cg_number, priceEntBidM.cg_unit];
                        CGFloat cgHei = [Tool heightForString:priceEntBidM.companyname width:65 * weakSelf.kScale font:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]];
                        priceEntBidM.price_average = [priceEntBidM.price_average containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceEntBidM.price_average.floatValue] : priceEntBidM.price_average;
                        CGFloat priceHei = [Tool heightForString:priceEntBidM.price_average width:70 * weakSelf.kScale font:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]];
                        NSAttributedString *string = [Tool htmlTranslat:[NSString stringWithFormat:@"指标说明：%@", priceEntBidM.index_string.length ? priceEntBidM.index_string : @"-"] font:[UIFont systemFontOfSize:15]];
                        priceEntBidM.indexstringAttr = string;
                        priceEntBidM.indexstring = string.string;
                        CGFloat indexHei = [Tool heightForString:priceEntBidM.indexstring width:kScreenW - 20 font:[UIFont systemFontOfSize:15]];
                        CGFloat hei = (nameHei > comHei ? nameHei : comHei);
                        hei = hei > cgHei ? hei : cgHei;
                        hei = hei > priceHei ? hei : priceHei;
                        priceEntBidM.cellHeight = hei + indexHei + 51;
                    }
                    [weakSelf.dataAry addObjectsFromArray:priceList];
                    if (weakSelf.dataAry.count == 0) {
                        PriceEntBidM *model = [[PriceEntBidM alloc] init];
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
        } failure:^(NSString * _Nonnull jurError) {
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
    } else {
        NSString *minid = @"0";
        if (self.dataAry.count) {
            NewsM *newsM = (NewsM *)self.dataAry.lastObject;
            minid = newsM.aid;
        }
        [Tool POST:NEWS params:@[@{@"count":self.dataAry.count == 0 ? @"20" : @"10"}, @{@"productid":[self.proID isEqualToString:@"000000"] ? @"0" : self.proID}, @{@"typeid":@"5"}, @{@"minid":minid}, @{@"maxid":@"0"}, @{@"keyname":@"newslist"}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull progress) {
            
        } success:^(NSDictionary * _Nonnull result) {
            if ([proID isEqualToString:weakSelf.proID] && pageIndex == weakSelf.pageIndex) {
                NSArray *ary = [NewsM mj_objectArrayWithKeyValuesArray:result[@"newslist"]];
                if (weakSelf.baseTV.alpha) {
                    if (weakSelf.baseTV.mj_footer) {
                        [weakSelf.baseTV.mj_footer endRefreshing];
                    }
                }
                if (ary.count < (weakSelf.dataAry.count == 0 ? 20 : 10)) {
                    [weakSelf.baseTV.mj_footer endRefreshingWithNoMoreData];
                }
                [weakSelf.dataAry addObjectsFromArray:ary];
                if (weakSelf.dataAry.count == 0) {
                    NewsM *model = [[NewsM alloc] init];
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
        self.logImgV.alpha = self.pageIndex ? 0 : 0.15;
        self.backgroundTitleVHeiCon.constant = self.pageIndex ? 0.01 : 40;
        self.baseTV.frame = CGRectMake(0, 0, kScreenW, kScreenH - kTopVH - kBottomH - 165 - 44 - (self.pageIndex ? 0 : 40));
        self.tableTitleV.alpha = self.pageIndex ? 0 : 1;
//        [self.view layoutIfNeeded]
        [self reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    kWeakSelf
    if (indexPath.row < self.dataAry.count) {
        if (self.pageIndex == 0) {
            PriceEntBidM *model = (PriceEntBidM *)self.dataAry[indexPath.row];
            if (model.ID == 0) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                NoDataV *v = [[[NSBundle mainBundle] loadNibNamed:@"NoDataV" owner:nil options:NULL] lastObject];
                v.viewType = NoDataViewTypePrice;
                v.frame = cell.bounds;
                [cell.contentView addSubview:v];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            } else {
                EntBidPriceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntBidPriceTableCell" forIndexPath:indexPath];
                cell.model = model;
                cell.selectBlock = ^{
                    [weakSelf.alertV showView];
                };
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        } else {
            NewsM *model = (NewsM *)self.dataAry[indexPath.row];
            if (model.pid.length == 0) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                NoDataV *v = [[[NSBundle mainBundle] loadNibNamed:@"NoDataV" owner:nil options:NULL] lastObject];
                v.viewType = self.pageIndex + 3;
                v.frame = cell.bounds;
                [cell.contentView addSubview:v];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            } else {
                NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataAry.count) {
        if (self.pageIndex == 0) {
            PriceEntBidM *model = (PriceEntBidM *)self.dataAry[indexPath.row];
            return model.cellHeight;
        } else {
            NewsM *model = (NewsM *)self.dataAry[indexPath.row];
            if (model.pid.length == 0) {
                return kScreenH - kTopVH - kBottomH - 243;
            } else {
                return 80;
            }
        }
    } else {
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataAry.count) {
        if (self.pageIndex == 1) {
            NewsDetailsVC *vc = [[NewsDetailsVC alloc] init];
            vc.type = NewsTypeBid;
            vc.model = (NewsM *)self.dataAry[indexPath.row];
            [self.navigationController pushViewController:vc animated:true];
        } else {
            NSString *key = [self.proID isEqualToString:@"000000"] ? @"476" : self.proID;
            if (![[Tool shareInstance].user.jurDic[key] boolValue]) {
                [self.alertV showView];
            }
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
