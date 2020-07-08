//
//  PriceVC.m
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/23.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import "PriceVC.h"
#import "PriceClassV.h"
#import "PriceTitleCollectionCell.h"
#import "PriceTypeCollectionCell.h"
#import "BasePageV.h"
#import "PriceEntClassV.h"
#import "PriceDetailsVC.h"

@interface PriceVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *priceTitleCVBackgroundV;
@property (nonatomic, strong) BaseCV *priceTitleCV;
@property (nonatomic, strong) PriceClassV *priceClassV;
@property (nonatomic, assign) NSInteger priceClassID;
@property (nonatomic, strong) NSArray<PriceClassM *> *priceClassAry;

@property (nonatomic, assign) NSInteger priceTypeIndex;

@property (weak, nonatomic) IBOutlet UIView *priceTypeBackgroundV;
//@property (weak, nonatomic) IBOutlet UICollectionView *priceTypeCV;
@property (nonatomic, strong) UICollectionView *priceTypeCV;
@property (nonatomic, strong) NSArray<PageTitleM *> *priceTypeAry;
@property (nonatomic, strong) NSArray<PageTitleM *> *currentPriceTypeAry;
@property (nonatomic, strong) NSMutableDictionary *priceTypeDataDic;

@property (weak, nonatomic) IBOutlet UIView *pageBackgroundV;

@property (nonatomic, strong) PriceEntClassV *priceEntClassV;

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation PriceVC

- (PriceEntClassV *)priceEntClassV {
    if (!_priceEntClassV) {
        _priceEntClassV = [[NSBundle mainBundle] loadNibNamed:@"PriceEntClassV" owner:nil options:nil].firstObject;
        _priceEntClassV.frame = self.view.bounds;
        _priceEntClassV.alpha = 0;
        kWeakSelf
        _priceEntClassV.selectBlock = ^{
            [weakSelf.basePageV entReolad];
        };
        [self.view addSubview:_priceEntClassV];
    }
    return _priceEntClassV;
}

- (NSMutableDictionary *)priceTypeDataDic {
    if (!_priceTypeDataDic) {
        _priceTypeDataDic = @{}.mutableCopy;
    }
    return _priceTypeDataDic;
}

- (PriceClassV *)priceClassV {
    if (!_priceClassV) {
        _priceClassV = [[NSBundle mainBundle] loadNibNamed:@"PriceClassV" owner:nil options:nil].lastObject;
        _priceClassV.frame = self.view.bounds;
        _priceClassV.alpha = 0;
        kWeakSelf
        _priceClassV.closeBlock = ^{
            [weakSelf requestData];
        };
        _priceClassV.confirmBlock = ^{
            [weakSelf requestData];
        };
    }
    return _priceClassV;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.shouleRefresh) {
        self.shouleRefresh = false;
        self.priceTypeDataDic = @{}.mutableCopy;
        [self requestData];
    }
}

- (void)updateData {
    [super updateData];
    if ([Tool shareInstance].currentViewController == self) {
        if (self.shouleRefresh) {
            self.shouleRefresh = false;
            self.priceTypeDataDic = @{}.mutableCopy;
            [self requestData];
        }
    }
}

- (void)reloadData {
    [super updateData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *selectAry = [Tool newsClassIDAry];
    if (selectAry.count) {
        [self requestData];
    } else {
        [self performSelector:@selector(requestData) withObject:nil afterDelay:0.01];
    }
}

- (void)setViews {
    [self.view addSubview:self.priceClassV];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.priceTitleCV = [[BaseCV alloc] initWithFrame:CGRectMake(0, 0, 100, 44) collectionViewLayout:layout];
    self.priceTitleCV.backgroundColor = kHexColor(kNavBackgroundColorHex, 1);
    [self.priceTitleCVBackgroundV addSubview:self.priceTitleCV];
    self.priceTitleCV.delegate = self;
    self.priceTitleCV.dataSource = self;
    [self.priceTitleCV registerNib:[UINib nibWithNibName:@"PriceTitleCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"PriceTitleCollectionCell"];
    
    self.priceTypeAry = [PageTitleM mj_objectArrayWithKeyValuesArray:@[@{@"name":@"现货价格", @"index":@(0)}, @{@"name":@"企业报价", @"index":@(1)}, @{@"name":@"招标价格", @"index":@(2)}, @{@"name":@"期货价格", @"index":@(3)}, @{@"name":@"机构价格", @"index":@(4)}]];
    
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.minimumLineSpacing = 0;
    layout1.minimumInteritemSpacing = 0;
    layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.priceTypeCV = [[BaseCV alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 44) collectionViewLayout:layout1];
    self.priceTypeCV.backgroundColor = kHexColor(@"E2EAF8", 1);
    [self.priceTypeBackgroundV addSubview:self.priceTypeCV];
    self.priceTypeCV.delegate = self;
    self.priceTypeCV.dataSource = self;
    [self.priceTypeCV registerNib:[UINib nibWithNibName:@"PriceTypeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"PriceTypeCollectionCell"];
    
    self.basePageV.dataType = DataTypePrice;
    self.basePageV.frame = CGRectMake(0, 0, kScreenW, kScreenH - kTopVH - kBottomVH - 88);
    self.basePageV.backgroundColor = [UIColor clearColor];
    kWeakSelf
    self.basePageV.selectBlock = ^(PageDataM * _Nonnull model) {
        NSMutableArray *ary = @[].mutableCopy;
        for (PriceEntBidClassM *m in model.dataAry) {
            PriceModelM *mm = [[PriceModelM alloc] init];
            mm.ID = m.ID;
            mm.productid_small = m.productid_small;
            mm.productSmallName = m.productSmallName;
            [ary addObject:mm];
        }
        weakSelf.priceEntClassV.dataAry = ary;;
        [weakSelf.priceEntClassV showView];
    };
    self.basePageV.scrollBlock = ^(NSInteger index) {
        if (weakSelf.priceTypeIndex != index) {
            weakSelf.priceTypeIndex = index;
            [weakSelf.priceTypeCV reloadData];
        }
    };
    self.basePageV.refreshBlock = ^(NSInteger ID, PageDataM * _Nonnull model, BOOL isReload, PriceContentClassM * _Nullable classM) {
//        model.requestNumber ++;
//        NSInteger requestNumber = model.requestNumber;
        PageDataM *tempModel = model;
        switch (model.flag) {
            case 0:
            {
                if (model.dataAry.count == 0) {
                    [Tool POST:SUBPRICE params:@[@{@"productid":@(ID).stringValue}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull progress) {
                        
                    } success:^(NSDictionary * _Nonnull result) {
                        if (ID != weakSelf.priceClassID || tempModel != model) {
                            return ;
                        }
                        NSMutableArray<PriceContentClassM *> *priceAry = [PriceContentClassM mj_objectArrayWithKeyValuesArray:result[@"product"]];
                        NSMutableArray *ary = [priceAry mutableCopy];
                        for (PriceContentClassM *contentModel in ary) {
                            if (contentModel.ID < 0) {
                                NSMutableArray *subAry = @[].mutableCopy;
                                for (PriceContentClassM *subContentModel in ary) {
                                    if (subContentModel.rootID == contentModel.ID) {
                                        [subAry addObject:subContentModel];
                                        [priceAry removeObject:subContentModel];
                                    }
                                }
                                contentModel.subClass = [subAry copy];
                            }
                        }
                        model.dataAry = (NSMutableArray<BaseM *> *)priceAry;
                        if (model.dataAry.count == 0) {
                            model.requestType = RequestTypeSuccessEmpty;
                            [weakSelf.basePageV setViewWithModel:model];
                        } else {
                            model.requestType = RequestTypeSuccessNormal;
                            [weakSelf requestStoDataWithID:ID model:model isReload:isReload classM:nil];
                        }
                    } failure:^(NSString * _Nonnull error) {
                        if (ID != weakSelf.priceClassID || tempModel != model) {
                            return ;
                        }
                        model.requestType = RequestTypeError;
                        [weakSelf.basePageV setViewWithModel:model];
                    }];
                } else {
                    if (ID != weakSelf.priceClassID || tempModel != model) {
                        return ;
                    }
                    [weakSelf requestStoDataWithID:ID model:model isReload:isReload classM:classM];
                }
            }
                break;
            case 1:
            {
                NSString *key = [NSString stringWithFormat:@"Ent%@", @(ID).stringValue];
                NSString *index = kValueForKey(key);
                PriceEntBidClassM *classM = (PriceEntBidClassM *)model.dataAry[index.integerValue];
                [Tool POST:JURISDICATION params:@[@{@"vipid":[Tool shareInstance].user.ID}, @{@"productid":@(ID).stringValue}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull jurProgress) {
                    
                } success:^(NSDictionary * _Nonnull jurResult) {
                    if (ID != weakSelf.priceClassID || tempModel != model) {
                        return ;
                    }
                    [[Tool shareInstance].user.jurDic setValue:jurResult[@"ViewState"] forKey:@(classM.productid_small == 0 ? classM.productid : classM.productid_small).stringValue];
                    [Tool POST:ENTPRICE params:@[@{@"count":isReload ? @"20" : @"10"}, @{@"productid":@(ID).stringValue}, @{@"date":classM.dataAry.count ? [classM.dataAry[0].valuedate componentsSeparatedByString:@" "][0] : @""}, @{@"compare_id": classM.dataAry.count ? @(classM.dataAry.lastObject.ID).stringValue : @"0"}, @{@"productid_small":@(classM.productid_small).stringValue}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull progress) {
                        
                    } success:^(NSDictionary * _Nonnull result) {
                        if (ID != weakSelf.priceClassID || tempModel != model) {
                            return ;
                        }
                        [Tool POST:VIEWLOG params:@[@{@"viewid":@(classM.productid_small == 0 ? classM.productid : classM.productid_small).stringValue}, @{@"type":@"1"}, @{@"vipid":[Tool shareInstance].user.ID}, @{@"isvip":@"1"}, @{@"issuccess":[[Tool shareInstance].user.jurDic[@(ID).stringValue] isEqualToString:@"1"] ? @"1" : @"0"}, @{@"remark":@""}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull logProgress) {
                            
                        } success:^(NSDictionary * _Nonnull logResult) {
                            
                        } failure:^(NSString * _Nonnull logError) {
                            
                        }];
                        NSArray *smallAry = [PriceModelM mj_objectArrayWithKeyValuesArray:result[@"ccjproduct"]];
                        if (model.dataAry.count == 1) {
                            for (PriceModelM *priceModelM in smallAry) {
                                PriceEntBidClassM *subListModel = [[PriceEntBidClassM alloc] init];
                                subListModel.ID = ID;
                                subListModel.productid = classM.productid;
                                subListModel.productid_small = priceModelM.productid_small;
                                subListModel.productSmallName = [Tool metalNameWithID:priceModelM.productid_small];
                                subListModel.requestType = RequestTypeInit;
                                subListModel.dataAry = @[].mutableCopy;
                                [model.dataAry addObject:subListModel];
                            }
                        }
                        
                        NSArray *priceList = [PriceEntBidM mj_objectArrayWithKeyValuesArray:result[@"ccjpricelist"]];
                        for (PriceEntBidM *priceEntBidM in priceList) {
                            priceEntBidM.isEnt = true;
                            priceEntBidM.jurID = ID;
                            priceEntBidM.qname = [[Tool htmlTranslat:priceEntBidM.qname font:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]].string stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
                            CGFloat nameHei = [Tool heightForString:priceEntBidM.qname width:80 * weakSelf.kScale font:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]];
                            priceEntBidM.comp_simple = [[Tool htmlTranslat:priceEntBidM.comp_simple font:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]].string stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
                            CGFloat comHei = [Tool heightForString:priceEntBidM.comp_simple width:kScreenW - 245 * weakSelf.kScale font:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]];
                            priceEntBidM.price = [priceEntBidM.price containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceEntBidM.price.floatValue] : priceEntBidM.price;
                            CGFloat priceHei = [Tool heightForString:priceEntBidM.price width:75 * weakSelf.kScale font:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]];
                            NSAttributedString *string = [Tool htmlTranslat:[NSString stringWithFormat:@"指标说明：%@", priceEntBidM.indexstring.length ? priceEntBidM.indexstring : @"-"] font:[UIFont systemFontOfSize:15]];
                            priceEntBidM.indexstringAttr = string;
                            priceEntBidM.indexstring = string.string;
                            CGFloat indexHei = [Tool heightForString:priceEntBidM.indexstring width:kScreenW - 20 font:[UIFont systemFontOfSize:15]];
                            CGFloat hei = (nameHei > comHei ? nameHei : comHei);
                            hei = hei > priceHei ? hei : priceHei;
                            priceEntBidM.cellHeight = hei + indexHei + 51;
                        }
                        [classM.dataAry addObjectsFromArray:priceList];
                        classM.requestType = priceList.count ? (priceList.count < (isReload ? 20 : 10) ? RequestTypeSuccessNomoreData : RequestTypeSuccessNormal) : (classM.dataAry.count ? RequestTypeSuccessNomoreData : RequestTypeSuccessEmpty);
                        if (ID == weakSelf.priceClassID) {
                            [weakSelf.basePageV setViewWithModel:model];
                        }
                    } failure:^(NSString * _Nonnull error) {
                        if (ID != weakSelf.priceClassID && tempModel != model) {
                            classM.requestType = classM.dataAry.count ? RequestTypeSuccessNormal : RequestTypeError;
                            [weakSelf.basePageV setViewWithModel:model];
                        }
                    }];
                } failure:^(NSString * _Nonnull jurError) {
                    if (ID == weakSelf.priceClassID && tempModel != model) {
                        classM.requestType = RequestTypeError;
                        [weakSelf.basePageV setViewWithModel:model];
                    }
                }];
            }
                break;
            case 2:
            {
                NSString *key = [NSString stringWithFormat:@"Bid%@", @(ID).stringValue];
                NSString *index = kValueForKey(key);
                PriceEntBidClassM *classM = (PriceEntBidClassM *)model.dataAry[index.integerValue];
                
                [Tool POST:JURISDICATION params:@[@{@"vipid":[Tool shareInstance].user.ID}, @{@"productid":@(ID).stringValue}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull jurProgress) {
                    
                } success:^(NSDictionary * _Nonnull jurResult) {
                    if (ID != weakSelf.priceClassID || tempModel != model) {
                        return ;
                    }
                    [[Tool shareInstance].user.jurDic setValue:jurResult[@"ViewState"] forKey:@(ID).stringValue];
                    
                    [Tool POST:BIDPRICE params:@[@{@"count":isReload ? @"20" : @"10"}, @{@"productid":@(ID).stringValue}, @{@"date":classM.dataAry.count ? [classM.dataAry[0].pdate componentsSeparatedByString:@" "][0] : @""}, @{@"compare_id": classM.dataAry.count ? @(classM.dataAry.lastObject.ID).stringValue : @"0"}, @{@"productid_small":classM.dataAry.count ? @(classM.productid_small).stringValue : @"0"}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull progress) {
                        
                    } success:^(NSDictionary * _Nonnull result) {
                        if (ID != weakSelf.priceClassID || tempModel != model) {
                            return ;
                        }
                        [Tool POST:VIEWLOG params:@[@{@"viewid":@(classM.productid_small == 0 ? classM.productid : classM.productid_small).stringValue}, @{@"type":@"1"}, @{@"vipid":[Tool shareInstance].user.ID}, @{@"isvip":@"1"}, @{@"issuccess":[[Tool shareInstance].user.jurDic[@(ID).stringValue] isEqualToString:@"1"] ? @"1" : @"0"}, @{@"remark":@""}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull logProgress) {
                            
                        } success:^(NSDictionary * _Nonnull logResult) {
                            
                        } failure:^(NSString * _Nonnull logError) {
                            
                        }];
                        NSArray *priceList = [PriceEntBidM mj_objectArrayWithKeyValuesArray:result[@"cgjpricelist"]];
                        for (PriceEntBidM *priceEntBidM in priceList) {
                            priceEntBidM.isEnt = false;
                            priceEntBidM.jurID = ID;
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
                        [classM.dataAry addObjectsFromArray:priceList];
                        classM.requestType = priceList.count ? (priceList.count < (isReload ? 20 : 10) ? RequestTypeSuccessNomoreData : RequestTypeSuccessNormal) : (classM.dataAry.count ? RequestTypeSuccessNomoreData : RequestTypeSuccessEmpty);
                        if (ID == weakSelf.priceClassID) {
                            [weakSelf.basePageV setViewWithModel:model];
                        }
                    } failure:^(NSString * _Nonnull error) {
                        if (ID != weakSelf.priceClassID || tempModel != model) {
                            return ;
                        }
                        classM.requestType = classM.dataAry.count ? RequestTypeSuccessNormal : RequestTypeError;
                        if (ID == weakSelf.priceClassID) {
                            [weakSelf.basePageV setViewWithModel:model];
                        }
                    }];
                    
                } failure:^(NSString * _Nonnull jurError) {
                    if (ID != weakSelf.priceClassID || tempModel != model) {
                        return ;
                    }
                    classM.requestType = RequestTypeError;
                    if (ID == weakSelf.priceClassID) {
                        [weakSelf.basePageV setViewWithModel:model];
                    }
                }];
            }
                break;
            case 3:
            case 4:
            {
                [Tool POST:JURISDICATION params:@[@{@"vipid":[Tool shareInstance].user.ID}, @{@"productid":@(ID).stringValue}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull jurProgress) {
                                    
                } success:^(NSDictionary * _Nonnull jurResult) {
                    if (ID != weakSelf.priceClassID || tempModel != model) {
                        return ;
                    }
                    [[Tool shareInstance].user.jurDic setValue:jurResult[@"ViewState"] forKey:@(ID).stringValue];
                    if ([Tool bjjgIdStringWithID:ID isFutures:model.flag == 3].length) {
                        [Tool POST:FOPRICE params:@[@{@"count":@"0"}, @{@"productid_big":@(ID).stringValue}, @{@"bjjgid":[Tool bjjgIdStringWithID:ID isFutures:model.flag == 3]}, @{@"updatemarktype":[Tool updateMarkTypeStringWithID:ID isFutures:model.flag == 3]}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull foProgress) {
                            
                        } success:^(NSDictionary * _Nonnull foResult) {
                            if (ID != weakSelf.priceClassID || tempModel != model) {
                                return ;
                            }
                            [Tool POST:VIEWLOG params:@[@{@"viewid":@(ID).stringValue}, @{@"type":@"2"}, @{@"vipid":[Tool shareInstance].user.ID}, @{@"isvip":@"1"}, @{@"issuccess":[[Tool shareInstance].user.jurDic[@(ID).stringValue] isEqualToString:@"1"] ? @"1" : @"0"}, @{@"remark":@""}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull logProgress) {
                                
                            } success:^(NSDictionary * _Nonnull logResult) {
                                
                            } failure:^(NSString * _Nonnull logError) {
                                
                            }];
                            
                            NSArray *infoAry = [PriceFOM mj_objectArrayWithKeyValuesArray:foResult[@"priceparaminfo"]];
                            NSMutableArray *dataAry = @[].mutableCopy;
                            NSArray *productAry = [PriceModelM mj_objectArrayWithKeyValuesArray:foResult[@"pricescd"]];
                            NSArray *tradeAry = [PriceModelM mj_objectArrayWithKeyValuesArray:foResult[@"pricetrade"]];
                            NSArray *modelAry = [PriceModelM mj_objectArrayWithKeyValuesArray:foResult[@"pricexinghao"]];
                            
                            NSArray *priceqhlistAry = [PriceFOContentM mj_objectArrayWithKeyValuesArray:foResult[@"priceqhlist"]];
                            NSArray *priceouzhouAry = [PriceFOContentM mj_objectArrayWithKeyValuesArray:foResult[@"priceouzhou"]];
                            NSArray *pricehtbyAry = [PriceFOContentM mj_objectArrayWithKeyValuesArray:foResult[@"pricehtby"]];
                            NSArray *pricelmeAry = [PriceFOContentM mj_objectArrayWithKeyValuesArray:foResult[@"pricelme"]];
                            NSArray *pricenfxgAry = [PriceFOContentM mj_objectArrayWithKeyValuesArray:foResult[@"pricenfxg"]];
                            NSArray *pricenygjsAry = [PriceFOContentM mj_objectArrayWithKeyValuesArray:foResult[@"pricenygjs"]];
                            NSArray *priceshhjAry = [PriceFOContentM mj_objectArrayWithKeyValuesArray:foResult[@"priceshhj"]];
                            NSArray *pricetyAry = [PriceFOContentM mj_objectArrayWithKeyValuesArray:foResult[@"pricety"]];
                            NSArray *priceotherAry = [PriceFOContentM mj_objectArrayWithKeyValuesArray:foResult[@"priceother"]];
                            for (PriceFOM *foM in infoAry) {
                                foM.isFutures = model.flag == 3;
                                NSInteger index = -1;
                                for (PriceFOClassM *classM in dataAry) {
                                    if (index == -1) {
                                        if (classM.ID == foM.bjjgid) {
                                            index = [dataAry indexOfObject:classM];
                                            break;
                                        }
                                    }
                                }
                                PriceFOClassM *classM = [[PriceFOClassM alloc] init];
                                if (index != -1) {
                                    classM = [dataAry objectAtIndex:index];
                                } else {
                                    classM.isDetails = true;
                                    classM.typeName = foM.typeName;
                                    classM.name = [Tool bjjgNameStringWithID:foM.bjjgid isFutures:model.flag == 3];
                                    classM.dataAry = @[].mutableCopy;
                                    classM.isLME = foM.updatemarktype == 12 || foM.updatemarktype == 17;
                                    if (classM.isLME && !(ID == 10643 || ID == 10763 || ID == 10114 || ID == 13889)) {
                                        PriceFOM *tempM = [[PriceFOM alloc] init];
                                        tempM.cellHeight = 40;
                                        [classM.dataAry addObject:tempM];
                                    }
                                    classM.ID = foM.bjjgid;
                                    [dataAry addObject:classM];
                                }
                                foM.isLME = classM.isLME;
                                switch (foM.updatemarktype) {
                                    case 1:
                                    {
                                        for (PriceFOContentM *priceFoContentM in priceqhlistAry) {
                                            if (priceFoContentM.ID == foM.ID) {
                                                priceFoContentM.close = priceFoContentM.vclose;
                                                priceFoContentM.zde = priceFoContentM.vzde;
                                                priceFoContentM.trade = priceFoContentM.vcjl;
                                                foM.priceFoContentM = priceFoContentM;
                                                break;
                                            }
                                        }
                                    }
                                        break;
                                    case 5:
                                    {
                                        for (PriceFOContentM *priceFoContentM in priceouzhouAry) {
                                            if (priceFoContentM.ID == foM.ID) {
                                                priceFoContentM.min = priceFoContentM.price_min;
                                                priceFoContentM.max = priceFoContentM.price_max;
                                                priceFoContentM.avg = priceFoContentM.price_avg;
                                                priceFoContentM.zde = priceFoContentM.price_zde;
                                                foM.priceFoContentM = priceFoContentM;
                                                break;
                                            }
                                        }
                                    }
                                        break;
                                    case 11:
                                    {
                                        for (PriceFOContentM *priceFoContentM in pricehtbyAry) {
                                            if (priceFoContentM.ID == foM.ID) {
                                                priceFoContentM.min = @"";
                                                priceFoContentM.max = @"";
                                                priceFoContentM.avg = priceFoContentM.price_js;
                                                priceFoContentM.zde = priceFoContentM.price_jszde;
                                                foM.priceFoContentM = priceFoContentM;
                                                break;
                                            }
                                        }
                                    }
                                        break;
                                    case 12:
                                    {
                                        for (PriceFOContentM *priceFoContentM in pricelmeAry) {
                                            if (priceFoContentM.ID == foM.ID) {
                                                priceFoContentM.sale = priceFoContentM.price_sell;
                                                priceFoContentM.zde = priceFoContentM.price_sell_zde;
                                                priceFoContentM.zdf = priceFoContentM.price_sell_zdf;
                                                foM.priceFoContentM = priceFoContentM;
                                                break;
                                            }
                                        }
                                    }
                                        break;
                                    case 13:
                                    {
                                        for (PriceFOContentM *priceFoContentM in pricenfxgAry) {
                                            if (priceFoContentM.ID == foM.ID) {
                                                priceFoContentM.min = @"";
                                                priceFoContentM.max = @"";
                                                priceFoContentM.avg = priceFoContentM.price_colse;
                                                priceFoContentM.zde = priceFoContentM.price_zde;
                                                foM.priceFoContentM = priceFoContentM;
                                                break;
                                            }
                                        }
                                    }
                                        break;
                                    case 14:
                                    {
                                        for (PriceFOContentM *priceFoContentM in pricenygjsAry) {
                                            if (priceFoContentM.ID == foM.ID) {
                                                priceFoContentM.min = priceFoContentM.price_min;
                                                priceFoContentM.max = priceFoContentM.price_max;
                                                priceFoContentM.avg = priceFoContentM.price_avg;
                                                priceFoContentM.zde = priceFoContentM.price_zde;
                                                foM.priceFoContentM = priceFoContentM;
                                                break;
                                            }
                                        }
                                    }
                                        break;
                                    case 15:
                                    {
                                        for (PriceFOContentM *priceFoContentM in priceshhjAry) {
                                            if (priceFoContentM.ID == foM.ID) {
                                                priceFoContentM.min = priceFoContentM.price_min;
                                                priceFoContentM.max = priceFoContentM.price_max;
                                                priceFoContentM.avg = priceFoContentM.price_close;
                                                priceFoContentM.zde = priceFoContentM.price_close_zde;
                                                foM.priceFoContentM = priceFoContentM;
                                                break;
                                            }
                                        }
                                    }
                                        break;
                                    case 16:
                                    {
                                        for (PriceFOContentM *priceFoContentM in pricetyAry) {
                                            if (priceFoContentM.ID == foM.ID) {
                                                priceFoContentM.min = priceFoContentM.price_min;
                                                priceFoContentM.max = priceFoContentM.price_max;
                                                priceFoContentM.avg = priceFoContentM.price_avg;
                                                priceFoContentM.zde = priceFoContentM.price_zde;
                                                foM.priceFoContentM = priceFoContentM;
                                                break;
                                            }
                                        }
                                    }
                                        break;
                                    case 17:
                                    for (PriceFOContentM *priceFoContentM in priceotherAry) {
                                        if (priceFoContentM.ID == foM.ID) {
                                            priceFoContentM.min = priceFoContentM.price_min;
                                            priceFoContentM.max = priceFoContentM.price_max;
                                            priceFoContentM.avg = priceFoContentM.price_close;
                                            priceFoContentM.zde = priceFoContentM.price_close_zde;
                                            priceFoContentM.sale = priceFoContentM.price_close;
                                            if (priceFoContentM.zde.length == 0) {
                                                priceFoContentM.zde = priceFoContentM.price_sell_zde;
                                            }
                                            priceFoContentM.zdf = @"";
                                            foM.priceFoContentM = priceFoContentM;
                                            break;
                                        }
                                    }
                                        break;
                                    default:
                                        break;
                                }
                                if (!foM.isFutures) {
                                    NSMutableArray *placeAry = @[].mutableCopy;
                                    NSMutableArray *otherAry = @[].mutableCopy;
                                    for (PriceModelM *priceModelM in productAry) {
                                        if (priceModelM.ID == foM.ID) {
                                            if (![placeAry containsObject:priceModelM.typeName]) {
                                                [placeAry addObject:priceModelM.typeName];
                                            }
                                        }
                                    }
                                    for (PriceModelM *priceModelM in tradeAry) {
                                        if (priceModelM.ID == foM.ID) {
                                            if (![placeAry containsObject:priceModelM.typeName]) {
                                                [placeAry addObject:priceModelM.typeName];
                                            }
                                        }
                                    }
                                    for (PriceModelM *priceModelM in modelAry) {
                                        if (priceModelM.ID == foM.ID) {
                                            if (![otherAry containsObject:priceModelM.typeName]) {
                                                [otherAry addObject:priceModelM.typeName];
                                            }
                                        }
                                    }
                                    NSMutableString *title = @"(".mutableCopy;
                                    [title appendString:foM.indexstring];
                                    for (NSString *otherStr in otherAry) {
                                        [title appendFormat:@";%@", otherStr];
                                    }
                                    for (NSString *placeStr in placeAry) {
                                        [title appendFormat:@"/%@", placeStr];
                                    }
                                    if (foM.indexstring.length == 0 && title.length > 1) {
                                        [title replaceCharactersInRange:NSMakeRange(1, 1) withString:@""];
                                    }
                                    [title appendString:@")"];
                                    if ([title isEqualToString:@"()"]) {
                                        title = @"".mutableCopy;
                                    }
                                    foM.detailsNameStr = [foM.qname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                    if (placeAry.count) {
                                        foM.detailsTitleStr = [NSString stringWithFormat:@"%@(%@)", [foM.qname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], placeAry.lastObject];
                                    } else {
                                        foM.detailsTitleStr = foM.detailsNameStr;
                                    }
                                    CGFloat height = 33;
                                    NSAttributedString *string = [Tool htmlTranslat:[NSString stringWithFormat:@"%@%@", [foM.qname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], title] font:[UIFont systemFontOfSize:15]];
                                    foM.qnameAttr = string;
                                    height += [Tool heightForString:string.string width:(kScreenW - 80 * weakSelf.kScale) font:[UIFont systemFontOfSize:15]] > 22 ? 41 : 20.5;
                                    NSString *minPrice = [foM.priceFoContentM.min containsString:@"."] ? [NSString stringWithFormat:@"%.2f", foM.priceFoContentM.min.floatValue] : foM.priceFoContentM.min;
                                    NSString *maxPrice = [foM.priceFoContentM.max containsString:@"."] ? [NSString stringWithFormat:@"%.2f", foM.priceFoContentM.max.floatValue] : foM.priceFoContentM.max;
                                    NSString *priceStr = [NSString stringWithFormat:@"%@-%@", minPrice, maxPrice];
                                    if (!minPrice && !maxPrice) {
                                        priceStr = @"";
                                    }
                                    if ([Tool heightForString:priceStr width:kScreenW - 230  * weakSelf.kScale font:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]] > 20) {
                                        priceStr = [NSString stringWithFormat:@"%@-\n %@", minPrice, maxPrice];
                                        height += [Tool heightForString:priceStr width:kScreenW - 240 * weakSelf.kScale font:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]];
                                    } else {
                                        height += 18;
                                    }
                                    foM.priceFoContentM.priceStr = priceStr;
                                    foM.cellHeight = height;
                                    foM.jurID = ID;
                                } else {
                                    CGFloat hei = 22;
                                    NSAttributedString *string = [Tool htmlTranslat:[NSString stringWithFormat:@"%@", [foM.qname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]] font:[UIFont systemFontOfSize:15]];
                                    CGFloat nameHei = [Tool heightForString:string.string width:kScreenW - 265 * weakSelf.kScale font:[UIFont systemFontOfSize:15]];
                                    NSString *priceStr = foM.isLME ? [foM.priceFoContentM.sale containsString:@"."] ? [NSString stringWithFormat:@"%.2f", foM.priceFoContentM.sale.floatValue] : foM.priceFoContentM.sale : [foM.priceFoContentM.close containsString:@"."] ? [NSString stringWithFormat:@"%.2f", foM.priceFoContentM.close.floatValue] : foM.priceFoContentM.close;
                                    if (!priceStr) {
                                        priceStr = @"0";
                                    }
                                    foM.priceFoContentM.priceStr = priceStr;
                                    CGFloat priceHei = [Tool heightForString:priceStr width:70 * weakSelf.kScale font:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]];
                                    hei += (priceHei > nameHei ? priceHei : nameHei);
                                    foM.cellHeight = hei;
                                    foM.detailsNameStr = [foM.qname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                    foM.detailsTitleStr = foM.detailsNameStr;
                                    foM.jurID = ID;
                                }
                                [classM.dataAry addObject:foM];
                            }
                            model.dataAry = @[].mutableCopy;
                            PriceFOClassM *lemClassM = nil;
                            for (PriceFOClassM *classM in dataAry) {
                                if (classM.isLME) {
                                    lemClassM = classM;
                                } else {
                                    [model.dataAry addObject:classM];
                                    [model.dataAry addObjectsFromArray:classM.dataAry];
                                }
                            }
                            if (lemClassM) {
                                [model.dataAry addObject:lemClassM];
                                [model.dataAry addObjectsFromArray:lemClassM.dataAry];
                            }
                            model.requestType = infoAry.count ? RequestTypeSuccessNormal : RequestTypeSuccessEmpty;
                            if (ID == weakSelf.priceClassID) {
                                [weakSelf.basePageV setViewWithModel:model];
                            }
                        } failure:^(NSString * _Nonnull stoError) {
                            if (ID != weakSelf.priceClassID || tempModel != model) {
                                return ;
                            }
                            model.requestType = RequestTypeError;
                            if (ID == weakSelf.priceClassID) {
                                [weakSelf.basePageV setViewWithModel:model];
                            }
                        }];
                    } else {
                        if (ID != weakSelf.priceClassID || tempModel != model) {
                            return ;
                        }
                        model.dataAry = @[].mutableCopy;
                        model.requestType = RequestTypeSuccessEmpty;
                        if (ID == weakSelf.priceClassID) {
                            [weakSelf.basePageV setViewWithModel:model];
                        }
                    }
                } failure:^(NSString * _Nonnull jurError) {
                    if (ID != weakSelf.priceClassID || tempModel != model) {
                        return ;
                    }
                    model.requestType = RequestTypeError;
                    if (ID == weakSelf.priceClassID) {
                        [weakSelf.basePageV setViewWithModel:model];
                    }
                }];
            }
                break;
            default:
                break;
        }
    };
    self.basePageV.detailsBlock = ^(PriceDetailsM * _Nonnull model) {
        if (model.ID == 0) {
            [weakSelf.alertV showView];
        } else {
            PriceDetailsVC *vc = [[PriceDetailsVC alloc] initWithNibName:@"PriceDetailsVC" bundle:nil];
            vc.model = model;
            [weakSelf.navigationController pushViewController:vc animated:true];
        }
    };
    [self.pageBackgroundV addSubview:self.basePageV];
}

- (void)resetPriceClassViews {
    CGFloat wid = 0;
    for (PriceClassM *model in self.priceClassAry) {
        wid += ([Tool widthForString:model.name font:[UIFont systemFontOfSize:14]] + 40);
    }
    self.priceTitleCV.frame = CGRectMake(0, 0, wid > kScreenW - 44 ? kScreenW - 44 : wid, 44);
    [self.priceTitleCV reloadData];
}

- (void)requestData {
    NSArray *selectAry = [Tool priceClassIDAry];
    if (selectAry.count == 0) {
        self.isFirst = true;
        kSetValueForKey(@"10114,14086,13923,10198,13955,10477,42344", kPriceClass);
        selectAry = [Tool priceClassIDAry];
    }
    NSMutableArray<PriceClassM *> *dataAry = [PriceClassM mj_objectArrayWithKeyValuesArray:[Tool metalAry]];
    for (PriceClassM *model in dataAry) {
        model.subClass = [PriceClassM mj_objectArrayWithKeyValuesArray:model.subClass];
        for (PriceClassM *subModel in model.subClass) {
            if ([self.priceTypeDataDic.allKeys containsObject:@(subModel.ID).stringValue]) {
                subModel.dataAry = self.priceTypeDataDic[@(subModel.ID).stringValue];
                subModel.priceTypeAry = self.priceTypeDataDic[[NSString stringWithFormat:@"type%@", @(subModel.ID).stringValue]];
            } else {
                NSMutableArray *pageAry = @[].mutableCopy;
                NSMutableArray *typeAry = @[].mutableCopy;
                for (NSInteger i = 0; i < self.priceTypeAry.count; i++) {
                    BOOL shouldAdd = true;
                    switch (i) {
                        case 1:
                        {
                            if ([subModel.str isEqualToString:@"mining"] || [subModel.str isEqualToString:@"fenti"] || [subModel.str isEqualToString:@"naihuo"] || [subModel.str isEqualToString:@"taoci"] || [subModel.str isEqualToString:@"bxg"] || [subModel.str isEqualToString:@"wjy"] || [subModel.str isEqualToString:@"tl"] || [subModel.str isEqualToString:@"hf"] || [subModel.str isEqualToString:@"au"] || [subModel.str isEqualToString:@"pt"] || [subModel.str isEqualToString:@"rh"] || [subModel.str isEqualToString:@"ru"] || [subModel.str isEqualToString:@"ir"] || [subModel.str isEqualToString:@"os"] || [subModel.str isEqualToString:@"waste"]) {
                                shouldAdd = false;
                            }
                        }
                            break;
                        case 2:
                        {
                            if ([subModel.str isEqualToString:@"v"] || [subModel.str isEqualToString:@"cr"] || [subModel.str isEqualToString:@"mn"] || [subModel.str isEqualToString:@"si"] || [subModel.str isEqualToString:@"w"] || [subModel.str isEqualToString:@"mo"] || [subModel.str isEqualToString:@"ti"] || [subModel.str isEqualToString:@"ni"]) {
                            } else {
                                shouldAdd = false;
                            }
                        }
                            break;
                        case 3:
                        {
                            if ([subModel.str isEqualToString:@"pt"] || [subModel.str isEqualToString:@"co"] || [subModel.str isEqualToString:@"si"] || [subModel.str isEqualToString:@"au"] || [subModel.str isEqualToString:@"al"] || [subModel.str isEqualToString:@"mo"] || [subModel.str isEqualToString:@"ni"] || [subModel.str isEqualToString:@"pd"] || [subModel.str isEqualToString:@"pb"] || [subModel.str isEqualToString:@"cu"] || [subModel.str isEqualToString:@"sn"] || [subModel.str isEqualToString:@"zn"] || [subModel.str isEqualToString:@"ag"]) {
                            } else {
                                shouldAdd = false;
                            }
                        }
                            break;
                        case 4:
                        {
                            if ([subModel.str isEqualToString:@"bi"] || [subModel.str isEqualToString:@"pt"] || [subModel.str isEqualToString:@"te"] || [subModel.str isEqualToString:@"v"] || [subModel.str isEqualToString:@"cd"] || [subModel.str isEqualToString:@"cr"] || [subModel.str isEqualToString:@"co"] || [subModel.str isEqualToString:@"si"] || [subModel.str isEqualToString:@"ga"] || [subModel.str isEqualToString:@"au"] || [subModel.str isEqualToString:@"rh"] || [subModel.str isEqualToString:@"ru"] || [subModel.str isEqualToString:@"al"] || [subModel.str isEqualToString:@"mg"] || [subModel.str isEqualToString:@"mn"] || [subModel.str isEqualToString:@"mo"] || [subModel.str isEqualToString:@"ni"] || [subModel.str isEqualToString:@"pd"] || [subModel.str isEqualToString:@"pb"] || [subModel.str isEqualToString:@"as"] || [subModel.str isEqualToString:@"ti"] || [subModel.str isEqualToString:@"ta"] || [subModel.str isEqualToString:@"sb"] || [subModel.str isEqualToString:@"cu"] || [subModel.str isEqualToString:@"w"] || [subModel.str isEqualToString:@"se"] || [subModel.str isEqualToString:@"ree"] || [subModel.str isEqualToString:@"sn"] || [subModel.str isEqualToString:@"zn"] || [subModel.str isEqualToString:@"ir"] || [subModel.str isEqualToString:@"in"] || [subModel.str isEqualToString:@"ag"] || [subModel.str isEqualToString:@"ge"]) {
                            } else {
                                shouldAdd = false;
                            }
                        }
                            break;
                        default:
                            break;
                    }
                    if (shouldAdd) {
                        PageDataM *dataModel = [[PageDataM alloc] init];
                        dataModel.dataAry = @[].mutableCopy;
                        dataModel.flag = self.priceTypeAry[i].index;
                        [pageAry addObject:dataModel];
                        [typeAry addObject:self.priceTypeAry[i]];
                    }
                }
                subModel.dataAry = pageAry;
                subModel.priceTypeAry = typeAry;
//                [self.priceTypeDataDic addEntriesFromDictionary:@{@(subModel.ID).stringValue:pageAry}];
//                [self.priceTypeDataDic addEntriesFromDictionary:@{[NSString stringWithFormat:@"type%@", @(subModel.ID).stringValue]:typeAry}];
            }
        }
    }
    PriceClassM *titleModel = [[PriceClassM alloc] init];
    titleModel.name = @"我的定制金属";
    NSMutableArray<PriceClassM *> *ary = @[].mutableCopy;
    for (NSString *ID in selectAry) {
         for (PriceClassM *model in dataAry) {
             for (PriceClassM *subModel in model.subClass) {
                 if (subModel.ID == ID.integerValue) {
                     subModel.isSelect = true;
                     [ary addObject:subModel];
                 }
             }
         }
    }
    if (![selectAry containsObject:@(self.priceClassID).stringValue]) {
        if (ary.count == 0) {
            PriceClassM *subModel = dataAry[0].subClass[0];
            self.priceClassID = subModel.ID;
            subModel.isSelect = true;
            [ary addObject:subModel];
        } else {
            self.priceClassID = ary[0].ID;
        }
    }
    titleModel.subClass = ary.copy;
    [dataAry insertObject:titleModel atIndex:0];
    self.priceClassAry = titleModel.subClass;
    
    for (PriceClassM *model in self.priceClassAry) {
        if (self.priceClassID == model.ID) {
            [self selectPriceClassAct:[self.priceClassAry indexOfObject:model]];
            break;
        }
    }
    self.priceClassV.dataAry = dataAry.copy;
    if (self.isFirst) {
        self.isFirst = false;
        [self.priceClassV showView];
    }
    [self resetPriceClassViews];
}

- (void)requestStoDataWithID:(NSInteger)ID model:(PageDataM *)model isReload:(BOOL)isReload classM:(PriceContentClassM *)classM {
    PriceContentClassM *priceContentClassM = (PriceContentClassM *)model.dataAry[0];
    if (priceContentClassM.subClass.count) {
        priceContentClassM = (PriceContentClassM *)model.dataAry[0];
    }
    if (classM) {
        priceContentClassM = classM;
    }
    kWeakSelf
    [Tool POST:JURISDICATION params:@[@{@"vipid":[Tool shareInstance].user.ID}, @{@"productid":@(ID).stringValue}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull jurProgress) {
        
    } success:^(NSDictionary * _Nonnull jurResult) {
        if (ID != weakSelf.priceClassID) {
            return ;
        }
        [[Tool shareInstance].user.jurDic setValue:jurResult[@"ViewState"] forKey:@(ID).stringValue];
        [Tool POST:STOPRICE params:@[@{@"count":@"0"}, @{@"productid":@(priceContentClassM.subClass.count ? priceContentClassM.subClass.firstObject.ID : (priceContentClassM.ID == 6 || priceContentClassM.ID == 1 ? 0 : priceContentClassM.ID)).stringValue}, @{@"updatetype":@"0"}, @{@"updatemarktype":@(priceContentClassM.subClass.count ? 0 : (priceContentClassM.ID == 6 ? 6 : 0)).stringValue}, @{@"productid_big":priceContentClassM.subClass.count ? @"" : (priceContentClassM.ID == 6 || priceContentClassM.ID == 1 ? @(ID).stringValue : @"")}, @{@"isjgf":@(priceContentClassM.subClass.count ? 0 : (priceContentClassM.ID == 6 ? 2 : (priceContentClassM.ID == 1 ? 1 : 0))).stringValue}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull stoProgress) {
            
        } success:^(NSDictionary * _Nonnull stoResult) {
            if (ID != weakSelf.priceClassID) {
                return ;
            }
            [Tool POST:VIEWLOG params:@[@{@"viewid":@(priceContentClassM.subClass.count ? priceContentClassM.subClass.firstObject.ID : (priceContentClassM.ID == 6 || priceContentClassM.ID == 1 ? 0 : priceContentClassM.ID)).stringValue}, @{@"type":@"1"}, @{@"vipid":[Tool shareInstance].user.ID}, @{@"isvip":@"1"}, @{@"issuccess":[[Tool shareInstance].user.jurDic[@(ID).stringValue] isEqualToString:@"1"] ? @"1" : @"0"}, @{@"remark":@""}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull logProgress) {
                
            } success:^(NSDictionary * _Nonnull logResult) {
                
            } failure:^(NSString * _Nonnull logError) {
                
            }];
            NSArray *infoAry = [PriceStoM mj_objectArrayWithKeyValuesArray:stoResult[@"priceparaminfo"]];
            NSArray *productAry = [PriceModelM mj_objectArrayWithKeyValuesArray:stoResult[@"pricescd"]];
            NSArray *tradeAry = [PriceModelM mj_objectArrayWithKeyValuesArray:stoResult[@"pricetrade"]];
            NSArray *valueAry = [PriceStoContentM mj_objectArrayWithKeyValuesArray:stoResult[@"pricevaluelist"]];
            NSArray *modelAry = [PriceModelM mj_objectArrayWithKeyValuesArray:stoResult[@"pricexinghao"]];
            for (PriceStoM *priceStoM in infoAry) {
                NSMutableArray *placeAry = @[].mutableCopy;
                NSMutableArray *otherAry = @[].mutableCopy;
                for (PriceModelM *priceModelM in productAry) {
                    if (priceModelM.ID == priceStoM.ID) {
                        if (![placeAry containsObject:priceModelM.typeName]) {
                            [placeAry addObject:priceModelM.typeName];
                        }
                    }
                }
                for (PriceModelM *priceModelM in tradeAry) {
                    if (priceModelM.ID == priceStoM.ID) {
                        if (![placeAry containsObject:priceModelM.typeName]) {
                            [placeAry addObject:priceModelM.typeName];
                        }
                    }
                }
                for (PriceModelM *priceModelM in modelAry) {
                    if (priceModelM.ID == priceStoM.ID) {
                        if (![otherAry containsObject:priceModelM.typeName]) {
                            [otherAry addObject:priceModelM.typeName];
                        }
                    }
                }
                for (PriceStoContentM *priceModelM in valueAry) {
                    if (priceModelM.ID == priceStoM.ID) {
                        priceStoM.priceStoContentM = priceModelM;
                    }
                }
                NSMutableString *title = @"(".mutableCopy;
                [title appendString:priceStoM.indexstring];
                for (NSString *otherStr in otherAry) {
                    [title appendFormat:@";%@", otherStr];
                }
                for (NSString *placeStr in placeAry) {
                    [title appendFormat:@"/%@", placeStr];
                }
                if (priceStoM.indexstring.length == 0 && title.length > 1) {
                    [title replaceCharactersInRange:NSMakeRange(1, 1) withString:@""];
                }
                [title appendString:@")"];
                if ([title isEqualToString:@"()"]) {
                    title = @"".mutableCopy;
                }
                priceStoM.detailsNameStr = [priceStoM.qname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if (placeAry.count) {
                    priceStoM.detailsTitleStr = [NSString stringWithFormat:@"%@(%@)", [priceStoM.qname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], placeAry.lastObject];
                } else {
                    priceStoM.detailsTitleStr = priceStoM.detailsNameStr;
                }
                CGFloat height = 33;
                NSAttributedString *string = [Tool htmlTranslat:[NSString stringWithFormat:@"%@%@", [priceStoM.qname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], title] font:[UIFont systemFontOfSize:15]];
                priceStoM.qnameAttr = string;
                height += [Tool heightForString:string.string width:(kScreenW - 80) font:[UIFont systemFontOfSize:15]] > 22 ? 41 : 20.5;
                NSString *minPrice = [priceStoM.priceStoContentM.price_min containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceStoM.priceStoContentM.price_min.floatValue] : priceStoM.priceStoContentM.price_min;
                NSString *maxPrice = [priceStoM.priceStoContentM.price_max containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceStoM.priceStoContentM.price_max.floatValue] : priceStoM.priceStoContentM.price_max;
                NSString *priceStr = [NSString stringWithFormat:@"%@-%@", minPrice, maxPrice];
                if (!minPrice && !maxPrice) {
                    priceStr = @"";
                }
                if ([Tool heightForString:priceStr width:kScreenW - 230 * weakSelf.kScale font:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]] > 20) {
                    priceStr = [NSString stringWithFormat:@"%@-\n %@", minPrice, maxPrice];
                    height += [Tool heightForString:priceStr width:kScreenW - 240 font:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]];
                } else {
                    height += 18;
                }
                priceStoM.priceStoContentM.priceStr = priceStr;
                priceStoM.cellHeight = height;
                priceStoM.jurID = ID;
            }
            if (infoAry.count == 0) {
                PriceStoM *m = [[PriceStoM alloc] init];
                m.cellHeight = 40;
                m.isRequest = false;
                infoAry = @[m].mutableCopy;
            }
            if (isReload) {
                ((PriceContentClassM *)model.dataAry[0]).isDetails = true;
                priceContentClassM.isDetails = true;
                if (priceContentClassM.subClass.count) {
                    priceContentClassM.subClass[0].dataAry = infoAry;
                    priceContentClassM.subClass[0].isDetails = true;
                    [model.dataAry insertObjects:priceContentClassM.subClass atIndexes:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(1, priceContentClassM.subClass.count)]];
                    [model.dataAry insertObjects:priceContentClassM.subClass[0].dataAry atIndexes:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(2, priceContentClassM.subClass[0].dataAry.count)]];
                } else {
                    priceContentClassM.dataAry = infoAry;
                    [model.dataAry insertObjects:priceContentClassM.dataAry atIndexes:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(1, priceContentClassM.dataAry.count)]];
                }
            } else {
                if ([model.dataAry containsObject:priceContentClassM]) {
                    if ([model.dataAry containsObject:priceContentClassM.dataAry[0]]) {
                        [model.dataAry removeObject:priceContentClassM.dataAry[0]];
                    }
                    priceContentClassM.dataAry = infoAry;
                    if (priceContentClassM.isDetails) {
                        [model.dataAry insertObjects:priceContentClassM.dataAry atIndexes:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange([model.dataAry indexOfObject:priceContentClassM] + 1, priceContentClassM.dataAry.count)]];
                    }
                }
            }
            priceContentClassM.requestType = infoAry.count ? RequestTypeSuccessNormal : RequestTypeSuccessEmpty;
            if (ID == weakSelf.priceClassID) {
                [weakSelf.basePageV setViewWithModel:model];
            }
        } failure:^(NSString * _Nonnull stoError) {
            if (ID != weakSelf.priceClassID) {
                return ;
            }
            priceContentClassM.requestType = RequestTypeInit;
            if (ID == weakSelf.priceClassID) {
                [weakSelf.basePageV setViewWithModel:model];
            }
        }];
    } failure:^(NSString * _Nonnull jurError) {
        if (ID != weakSelf.priceClassID) {
            return ;
        }
        priceContentClassM.requestType = RequestTypeInit;
        if (ID == weakSelf.priceClassID) {
            [weakSelf.basePageV setViewWithModel:model];
        }
    }];
}

- (IBAction)selectClassAct:(id)sender {
    [self.priceClassV showView];
}

- (void)selectPriceClassAct:(NSInteger)index {
    if (self.basePageV.dataAry) {
        if (![self.basePageV.dataAry isEqual:self.priceClassAry[index].dataAry]) {
            self.basePageV.ID = self.priceClassAry[index].ID;
            for (PageDataM *model in self.priceClassAry[index].dataAry) {
                model.requestType = RequestTypeInit;
                model.dataAry = @[].mutableCopy;
            }
            self.basePageV.dataAry = self.priceClassAry[index].dataAry.mutableCopy;
            self.currentPriceTypeAry = self.priceClassAry[index].priceTypeAry;
            self.priceTypeIndex = 0;
            [self.priceTypeCV reloadData];
            [self selectPriceTypeAct];
        }
    } else {
        self.basePageV.ID = self.priceClassAry[index].ID;
        for (PageDataM *model in self.priceClassAry[index].dataAry) {
            model.requestType = RequestTypeInit;
            model.dataAry = @[].mutableCopy;
        }
        self.basePageV.dataAry = self.priceClassAry[index].dataAry.mutableCopy;
        self.currentPriceTypeAry = self.priceClassAry[index].priceTypeAry;
        self.priceTypeIndex = 0;
        [self.priceTypeCV reloadData];
        [self selectPriceTypeAct];
    }
}

- (void)selectPriceTypeAct {
    [self.priceTypeCV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.priceTypeIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:true];
    [self.basePageV scrollToIndex:self.priceTypeIndex];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.priceTitleCV) {
        return self.priceClassAry.count;
    } else if (collectionView == self.priceTypeCV) {
        return self.currentPriceTypeAry.count;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.priceTitleCV) {
        PriceTitleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PriceTitleCollectionCell" forIndexPath:indexPath];
        cell.isCurrentClass = self.priceClassID == self.priceClassAry[indexPath.row].ID;
        cell.model = self.priceClassAry[indexPath.row];
        return cell;
    } else if (collectionView == self.priceTypeCV) {
        PriceTypeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PriceTypeCollectionCell" forIndexPath:indexPath];
        cell.model = self.currentPriceTypeAry[indexPath.row];
        cell.isCurrentType = self.priceTypeIndex == indexPath.row;
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.priceTitleCV) {
        if (self.priceClassID != self.priceClassAry[indexPath.row].ID) {
            self.priceClassID = self.priceClassAry[indexPath.row].ID;
            [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:true];
            [self selectPriceClassAct:indexPath.row];
            [self.priceTitleCV reloadData];
        }
    } else if (collectionView == self.priceTypeCV) {
        if (self.priceTypeIndex != indexPath.row) {
            self.priceTypeIndex = indexPath.row;
            [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:true];
            [self selectPriceTypeAct];
            [self.priceTypeCV reloadData];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.priceTitleCV) {
        return CGSizeMake([Tool widthForString:self.priceClassAry[indexPath.row].name font:[UIFont systemFontOfSize:18]] + 40, 44);
    } else if (collectionView == self.priceTypeCV) {
        return CGSizeMake([Tool widthForString:self.priceTypeAry[indexPath.row].name font:[UIFont systemFontOfSize:16]] + 30, 44);
    }
    return CGSizeMake(1, 1);
}

@end
