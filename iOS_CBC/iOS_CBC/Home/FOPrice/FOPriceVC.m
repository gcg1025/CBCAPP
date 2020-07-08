//
//  FOPriceVC.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/1.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "FOPriceVC.h"
#import "PriceTypeCollectionCell.h"
#import "FOFPriceTableCell.h"
#import "FOOPriceTableCell.h"
#import "TableTitleV.h"
#import "FOPriceClassV.h"
#import "PriceDetailsVC.h"

@interface FOPriceVC () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *backgroundV;
@property (weak, nonatomic) IBOutlet UILabel *fTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *oTitleLab;
@property (nonatomic, strong) NSArray<PageDataM *> *dataAry;
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UIView *titleBackgroundV;

@property (weak, nonatomic) IBOutlet UIView *tableTitleBackgroundV;

//@property (weak, nonatomic) IBOutlet BaseCV *titleCV;

@property (nonatomic, strong) BaseCV *titleCV;

@property (nonatomic, strong) TableTitleV *tableTitleV;

@property (nonatomic, assign) NSInteger fIndex;
@property (nonatomic, assign) NSInteger oIndex;

@property (nonatomic, strong) FOPriceClassV *priceClassV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;

@end

@implementation FOPriceVC

- (FOPriceClassV *)priceClassV {
    if (!_priceClassV) {
        _priceClassV = [[NSBundle mainBundle] loadNibNamed:@"FOPriceClassV" owner:nil options:nil].firstObject;
        _priceClassV.frame = self.view.bounds;
        _priceClassV.alpha = 0;
        kWeakSelf
        _priceClassV.selectBlock = ^(NSInteger index) {
            if (index != (weakSelf.type ? weakSelf.oIndex : weakSelf.fIndex)) {
                if (weakSelf.type) {
                    weakSelf.oIndex = index;
                } else {
                    weakSelf.fIndex = index;
                }
                [weakSelf resetViews];
            }
        };
        [self.view addSubview:_priceClassV];
    }
    return _priceClassV;
}

- (TableTitleV *)tableTitleV {
    if (!_tableTitleV) {
        _tableTitleV = [[NSBundle mainBundle] loadNibNamed:@"TableTitleV" owner:nil options:nil].firstObject;
        _tableTitleV.frame = self.tableTitleBackgroundV.bounds;
    }
    return _tableTitleV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setViews {
    [self setNavigationBarWithTitle:self.type ? @"机构价格" : @"期货机构" hasBackBtn:true];
    NSString *version= [UIDevice currentDevice].systemVersion;
    if (version.doubleValue < 11) {
        self.topCon.constant = 64;
        [self.view layoutIfNeeded];
    }
//    NoDataV *v = [[[NSBundle mainBundle] loadNibNamed:@"NoDataV" owner:nil options:NULL] lastObject];
//    v.viewType = self.type + 7;
//    v.frame = self.backgroundV.bounds;
//    [self.backgroundV addSubview:v];

    [self.tableTitleBackgroundV addSubview:self.tableTitleV];
    
    self.requestV.frame = self.contentV.bounds;
    [self.contentV addSubview:self.requestV];
    self.errorV.frame = self.contentV.bounds;
    [self.contentV addSubview:self.errorV];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.titleCV = [[BaseCV alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 44, 44) collectionViewLayout:layout];
    self.titleCV.backgroundColor = kHexColor(@"E2EAF8", 1);
    [self.titleBackgroundV addSubview:self.titleCV];
    self.titleCV.delegate = self;
    self.titleCV.dataSource = self;
    [self.titleCV registerNib:[UINib nibWithNibName:@"PriceTypeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"PriceTypeCollectionCell"];

    self.baseTV.frame = CGRectMake(0, 0, kScreenW, kScreenH - kTopVH - 148 - kBottomH);
    [self.baseTV registerNib:[UINib nibWithNibName:@"FOFPriceTableCell" bundle:nil] forCellReuseIdentifier:@"FOFPriceTableCell"];
    [self.baseTV registerNib:[UINib nibWithNibName:@"FOOPriceTableCell" bundle:nil] forCellReuseIdentifier:@"FOOPriceTableCell"];
    [self.contentV addSubview:self.baseTV];
    self.baseTV.backgroundColor = [UIColor clearColor];
    
    [self requestData];
    
    [self resetViews];
}

- (IBAction)selectOrgnizationAct:(id)sender {
    self.priceClassV.dataAry = (NSMutableArray<FOPriceM *> *)self.dataAry[self.type].dataAry;
    [self.priceClassV showView];
}

- (void)requestData {
    PageDataM *model1 = [[PageDataM alloc] init];
    model1.requestType = RequestTypeInit;
    model1.dataAry = [FOPriceM mj_objectArrayWithKeyValuesArray:[Tool futureAry]];
    model1.idsStr = @"4129,4127,4128,8333,6213,7377,8782";
    model1.updatemarktypeStr = @"1,12,17";
    model1.flag = 3;
    PageDataM *model2 = [[PageDataM alloc] init];
    model2.requestType = RequestTypeInit;
    model2.dataAry = [FOPriceM mj_objectArrayWithKeyValuesArray:[Tool orgnizationAry]];
    model2.idsStr = @"10146,8330,4135,14097,4131,4134,6366,4137,7942,8325,15166,8329,8328,15188,15189";
    model2.updatemarktypeStr = @"5,11,13,14,15,16,17";
    model2.flag = 4;
    self.dataAry = @[model1, model2];
}

- (IBAction)selectTitleAct:(UIButton *)sender {
    if (self.type != sender.tag - 30000) {
        self.type = sender.tag - 30000;
        [self resetViews];
    }
}

- (void)resetViews {
    self.navigationView.titleLab.text = self.type ? @"机构价格" : @"期货价格";;
    self.fTitleLab.alpha = self.type ? 0.5 : 1;
    self.oTitleLab.alpha = self.type ? 1 : 0.5;
    [self.titleCV reloadData];
    [self.titleCV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:(self.type ? self.oIndex : self.fIndex) inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:true];
    PageDataM *model = self.dataAry[self.type];
    switch (model.requestType) {
        case RequestTypeInit:
        case RequestTypeGoingReload:
            self.titleBackgroundV.alpha = 0;
            self.tableTitleBackgroundV.alpha = 0;
            self.requestV.alpha = 1;
            self.errorV.alpha = 0;
            self.baseTV.alpha = 0;
            [self reloadData];
            break;
        case RequestTypeSuccessNormal:
        {
            self.titleBackgroundV.alpha = 1;
            self.tableTitleBackgroundV.alpha = 1;
            FOPriceM *classM = (FOPriceM *)model.dataAry[(self.type ? self.oIndex : self.fIndex)];
            NSInteger type = 0;
            if (self.type) {
                type = 10;
                if (classM.ID == 7942) {
                    type = 11;
                } else if (classM.ID == 8325) {
                    type = 12;
                } else if (classM.ID == 8328) {
                    type = 13;
                }
            } else {
                NSString *dateStr = @"";
                NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
                [dayFormatter setDateFormat:@"yyyy/MM/dd"];
                NSDateFormatter *dayFormatterL = [[NSDateFormatter alloc] init];
                [dayFormatterL setDateFormat:@"MM-dd"];
                if (classM.dataAry[0].ID != 0) {
                    NSArray *dateAry = [classM.dataAry[0].valuedate componentsSeparatedByString:@" "];
                    if (dateAry.count == 2) {
                        dateStr = [dayFormatterL stringFromDate:[dayFormatter dateFromString:dateAry[0]]];
                    }
                } else {
                    dateStr = [dayFormatterL stringFromDate:[NSDate date]];
                }
                self.tableTitleV.dateStr = dateStr;
                type = 6;
                if (classM.ID == 6213) {
                    type = 9;
                }
                if (classM.dataAry[0].isLME) {
                    type = 7;
                }
            }
            self.tableTitleV.type = type;
            self.requestV.alpha = 0;
            self.errorV.alpha = 0;
            self.baseTV.alpha = 1;
            self.baseTV.contentOffset = CGPointMake(0, 0);
            [self.baseTV reloadData];
        }
            break;
        case RequestTypeError:
            self.titleBackgroundV.alpha = 0;
            self.tableTitleBackgroundV.alpha = 0;
            self.requestV.alpha = 0;
            self.errorV.alpha = 1;
            self.baseTV.alpha = 0;
            break;
        default:
            break;
    }
}

- (void)reloadData {
    PageDataM *model = self.dataAry[self.type];
    model.requestType = RequestTypeGoingReload;
    kWeakSelf
    [Tool POST:JURISDICATION params:@[@{@"vipid":[Tool shareInstance].user.ID}, @{@"productid":@"476"}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull jurProgress) {
                        
    } success:^(NSDictionary * _Nonnull jurResult) {
        [[Tool shareInstance].user.jurDic setValue:jurResult[@"ViewState"] forKey:@"476"];
        [Tool POST:FOPRICE params:@[@{@"count":@"0"}, @{@"productid_big":@"0"}, @{@"bjjgid":model.idsStr}, @{@"updatemarktype":model.updatemarktypeStr}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull foProgress) {
            
        } success:^(NSDictionary * _Nonnull foResult) {
            NSArray *idsAry = [model.idsStr componentsSeparatedByString:@","];
            [Tool POST:VIEWLOG params:@[@{@"viewid":idsAry.count ? idsAry[0] : @"476"}, @{@"type":@"2"}, @{@"vipid":[Tool shareInstance].user.ID}, @{@"isvip":@"1"}, @{@"issuccess":[[Tool shareInstance].user.jurDic[@(476).stringValue] isEqualToString:@"1"] ? @"1" : @"0"}, @{@"remark":@""}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull logProgress) {

            } success:^(NSDictionary * _Nonnull logResult) {

            } failure:^(NSString * _Nonnull logError) {

            }];
            
            NSArray *infoAry = [PriceFOM mj_objectArrayWithKeyValuesArray:foResult[@"priceparaminfo"]];
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
            
            NSMutableArray<PriceFOM *> *lemAry = @[].mutableCopy;
            for (PriceFOM *foM in infoAry) {
                foM.isFutures = model.flag == 3;
                NSInteger index = -1;
                for (FOPriceM *classM in model.dataAry) {
                    if (index == -1) {
                        if (classM.ID == foM.bjjgid) {
                            index = [model.dataAry indexOfObject:classM];
                            break;
                        }
                    }
                }
                foM.isLME = foM.updatemarktype == 12 || foM.updatemarktype == 17;
                FOPriceM *classM = (FOPriceM *)[model.dataAry objectAtIndex:index];
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
                            priceFoContentM.zdf = [NSString stringWithFormat:@"%.2f", priceFoContentM.zde.floatValue / (priceFoContentM.sale.floatValue - priceFoContentM.zde.floatValue) * 100];
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
                    if (foM.bjjgid == 8328 || foM.bjjgid == 8325) {
                        CGFloat height = 22;
                        NSMutableString *indexStr = (foM.indexstring ? foM.indexstring : @"").mutableCopy;
                        for (NSString *otherStr in otherAry) {
                            [indexStr appendFormat:@";%@", otherStr];
                        }
                        for (NSString *placeStr in placeAry) {
                            [indexStr appendFormat:@"/%@", placeStr];
                        }
                        if (foM.indexstring.length == 0 && indexStr.length > 1) {
                            [indexStr replaceCharactersInRange:NSMakeRange(1, 1) withString:@""];
                        }
                        foM.detailsNameStr = [foM.qname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        if (placeAry.count) {
                            foM.detailsTitleStr = [NSString stringWithFormat:@"%@(%@)", [foM.qname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], placeAry.lastObject];
                        } else {
                            foM.detailsTitleStr = foM.detailsNameStr;
                        }
                        foM.indexstring = indexStr;
                        NSAttributedString *string = [Tool htmlTranslat:[NSString stringWithFormat:@"%@", [foM.qname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]] font:[UIFont systemFontOfSize:15]];
                        foM.qnameAttr = string;
                        height += [Tool heightForString:string.string width:(kScreenW - 245 * weakSelf.kScale - 40) font:[UIFont systemFontOfSize:15]];
                        if (foM.indexstring.length) {
                            height += [Tool heightForString:foM.indexstring width:(kScreenW - 20) font:[UIFont systemFontOfSize:15]] + 11;
                        }
                        foM.cellHeight = height;
                    } else {
                        NSMutableString *title = @"(".mutableCopy;
                        [title appendString:foM.indexstring];
                        for (NSString *otherStr in otherAry) {
                            [title appendFormat:@";%@", otherStr];
                        }
                        for (NSString *placeStr in placeAry) {
                            [title appendFormat:@"/%@", placeStr];
                        }
                        foM.detailsNameStr = [foM.qname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        if (placeAry.count) {
                            foM.detailsTitleStr = [NSString stringWithFormat:@"%@(%@)", [foM.qname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], placeAry.lastObject];
                        } else {
                            foM.detailsTitleStr = foM.detailsNameStr;
                        }
                        if (foM.indexstring.length == 0 && title.length > 1) {
                            [title replaceCharactersInRange:NSMakeRange(1, 1) withString:@""];
                        }
                        [title appendString:@")"];
                        if ([title isEqualToString:@"()"]) {
                            title = @"".mutableCopy;
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
                    }
                    foM.jurID = 476;
                } else {
                    CGFloat hei = 22;
                    NSAttributedString *string = [Tool htmlTranslat:[NSString stringWithFormat:@"%@", [foM.qname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]] font:[UIFont systemFontOfSize:15]];
                    CGFloat w = 25;
                    if (foM.bjjgid == 6213) {
                        w = -34;
                    }
                    CGFloat nameHei = [Tool heightForString:string.string width:kScreenW - (265 + w) * weakSelf.kScale font:[UIFont systemFontOfSize:15]];
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
                    foM.jurID = 476;
                }
                if (foM.updatemarktype != 17) {
                    [classM.dataAry addObject:foM];
                } else {
                    if (foM.isFutures) {
                        [lemAry addObject:foM];
                    } else {
                        [classM.dataAry addObject:foM];
                    }
                }
            }
            FOPriceM *lemClassM = (FOPriceM *)model.dataAry[1];
            if (lemAry.count) {
                PriceFOM *foM = [[PriceFOM alloc] init];
                foM.valuedate = lemAry[0].valuedate;
                foM.cellHeight = 40;
                foM.isTitle = true;
                [lemClassM.dataAry addObject:foM];
                [lemClassM.dataAry addObjectsFromArray:lemAry];
            }
            for (FOPriceM *classM in model.dataAry) {
                if (classM.dataAry.count == 0) {
                    PriceFOM *foM = [[PriceFOM alloc] init];
                    foM.cellHeight = kScreenH - kTopVH - 148 - kBottomH;
                    [classM.dataAry addObject:foM];
                }
            }
            model.requestType = RequestTypeSuccessNormal;
            if ([weakSelf.dataAry indexOfObject:model] == weakSelf.type) {
                [weakSelf resetViews];
            }
        } failure:^(NSString * _Nonnull stoError) {
            model.requestType = RequestTypeError;
            if ([weakSelf.dataAry indexOfObject:model] == weakSelf.type) {
                [weakSelf resetViews];
            }
        }];
    } failure:^(NSString * _Nonnull jurError) {
        model.requestType = RequestTypeError;
        if ([weakSelf.dataAry indexOfObject:model] == weakSelf.type) {
            [weakSelf resetViews];
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataAry[self.type].dataAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PriceTypeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PriceTypeCollectionCell" forIndexPath:indexPath];
    FOPriceM *model = (FOPriceM *)self.dataAry[self.type].dataAry[indexPath.row];
    cell.foModel = model;
    model.isSelect = (self.type ? self.oIndex : self.fIndex) == indexPath.row;
    cell.isCurrentType = (self.type ? self.oIndex : self.fIndex) == indexPath.row;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    FOPriceM *model = (FOPriceM *)self.dataAry[self.type].dataAry[indexPath.row];
    return CGSizeMake([Tool widthForString:model.name font:[UIFont systemFontOfSize:14]] + 40, 44);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ((self.type ? self.oIndex : self.fIndex) != indexPath.row) {
        if (self.type) {
            self.oIndex = indexPath.row;
        } else {
            self.fIndex = indexPath.row;
        }
        [self resetViews];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FOPriceM *model = (FOPriceM *)self.dataAry[self.type].dataAry[(self.type ? self.oIndex : self.fIndex)];
    return model.dataAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FOPriceM *model = (FOPriceM *)self.dataAry[self.type].dataAry[(self.type ? self.oIndex : self.fIndex)];
    return model.dataAry[indexPath.row].cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FOPriceM *model = (FOPriceM *)self.dataAry[self.type].dataAry[(self.type ? self.oIndex : self.fIndex)];
    kWeakSelf
    if (self.dataAry[self.type].flag == 3) {
        PriceFOM *contentM = model.dataAry[indexPath.row];
        if (contentM.ID == 0 && !contentM.isTitle) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            NoDataV *v = [[[NSBundle mainBundle] loadNibNamed:@"NoDataV" owner:nil options:NULL] lastObject];
            v.viewType = NoDataViewTypePrice;
            v.frame = cell.bounds;
            [cell.contentView addSubview:v];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            FOFPriceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FOFPriceTableCell" forIndexPath:indexPath];
            cell.type = FuturePriceTypeNormal;
            if (contentM.isLME) {
                cell.type = FuturePriceTypeLEM;
            }
            if (contentM.bjjgid == 6213) {
                cell.type = FuturePriceTypeTOCOM;
            }
            cell.selectBlock = ^(PriceFOM * _Nonnull selectM) {
                if (selectM) {
                    PriceDetailsM *detailsM = [[PriceDetailsM alloc] init];
                    detailsM.pid = selectM.ID;
                    detailsM.bjjgid = selectM.bjjgid;
                    detailsM.name = selectM.detailsNameStr;
                    detailsM.title = selectM.detailsTitleStr;
                    detailsM.ID = selectM.jurID;
                    PriceDetailsVC *vc = [[PriceDetailsVC alloc] initWithNibName:@"PriceDetailsVC" bundle:nil];
                    vc.model = detailsM;
                    [weakSelf.navigationController pushViewController:vc animated:true];
                }
            };
            cell.model = (PriceFOM *)contentM;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    } else {
        PriceFOM *contentM = model.dataAry[indexPath.row];
        if (contentM.ID) {
            FOOPriceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FOOPriceTableCell" forIndexPath:indexPath];
            cell.isOAll = contentM.bjjgid == 8328 || contentM.bjjgid == 8325;
            cell.model = contentM;
            cell.selectBlock = ^(PriceFOM * _Nonnull selectM) {
                if (selectM) {
                    PriceDetailsM *detailsM = [[PriceDetailsM alloc] init];
                    detailsM.pid = selectM.ID;
                    detailsM.bjjgid = selectM.bjjgid;
                    detailsM.name = selectM.detailsNameStr;
                    detailsM.title = selectM.detailsTitleStr;
                    detailsM.ID = selectM.jurID;
                    PriceDetailsVC *vc = [[PriceDetailsVC alloc] initWithNibName:@"PriceDetailsVC" bundle:nil];
                    vc.model = detailsM;
                    [weakSelf.navigationController pushViewController:vc animated:true];
                }
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            NoDataV *v = [[[NSBundle mainBundle] loadNibNamed:@"NoDataV" owner:nil options:NULL] lastObject];
            v.viewType = NoDataViewTypePrice;
            v.frame = cell.bounds;
            [cell.contentView addSubview:v];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

@end
