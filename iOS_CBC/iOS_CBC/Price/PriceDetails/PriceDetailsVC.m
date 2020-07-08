//
//  PriceDetailsVC.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/8.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "PriceDetailsVC.h"
#import "PriceDetailsInfoV.h"
#import "PriceDetailsTitleV.h"
#import "PriceDetailsTableCell.h"
#import "PriceDetailsTitleV.h"
#import "AAChartKit.h"
#import "PriceLineV.h"

@interface PriceDetailsVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *lineTitleLab;
@property (weak, nonatomic) IBOutlet UIView *backgroundV;
@property (weak, nonatomic) IBOutlet UIView *lineBackgroundV;
@property (weak, nonatomic) IBOutlet UIView *listBackgroundV;
@property (weak, nonatomic) IBOutlet UIView *listTitleBackgroundV;
@property (weak, nonatomic) IBOutlet UILabel *unitLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *listBackgroundVWidCon;

@property (nonatomic, strong) PriceDetailsInfoV *priceDetailsInfoV;

@property (nonatomic, strong) NSMutableArray<PriceDetailsLineM *> *lineModelAry;
@property (nonatomic, assign) NSInteger currentLineIndex;

@property (nonatomic, assign) BOOL isReload;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray<PriceDetailsPriceM *> *dataAry;

@property (nonatomic, assign) BOOL isTryVip;
@property (nonatomic, assign) BOOL viewState;

@property (nonatomic, assign) NSInteger titleType;

@property (nonatomic, strong) PriceDetailsTitleV *priceDetailsTitleV;

@property (nonatomic, strong) AAChartView *chartV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;

@property (nonatomic,assign) BOOL statusHiden;

@property (nonatomic, strong) PriceLineV *lineV;
@property (nonatomic, assign) CGPoint point;

@property (weak, nonatomic) IBOutlet UIButton *priceDetailBtn;

@end

@implementation PriceDetailsVC

- (BOOL)prefersStatusBarHidden {
    return self.statusHiden;
}

- (PriceDetailsInfoV *)priceDetailsInfoV {
    if (!_priceDetailsInfoV) {
        _priceDetailsInfoV = [[NSBundle mainBundle] loadNibNamed:@"PriceDetailsInfoV" owner:nil options:nil].firstObject;
        _priceDetailsInfoV.frame = self.view.bounds;
        _priceDetailsInfoV.alpha = 0;
        _priceDetailsInfoV.model = self.model;
        [self.view addSubview:_priceDetailsInfoV];
    }
    return _priceDetailsInfoV;
}

- (PriceDetailsTitleV *)priceDetailsTitleV {
    if (!_priceDetailsTitleV) {
        _priceDetailsTitleV = [[NSBundle mainBundle] loadNibNamed:@"PriceDetailsTitleV" owner:nil options:nil].firstObject;
    }
    return _priceDetailsTitleV;
}

- (AAChartView *)chartV {
    if (!_chartV) {
        _chartV = [[AAChartView alloc] initWithFrame:CGRectMake(10, 0, kScreenW - 20, 164)];
        _chartV.scrollEnabled = false;
        _chartV.isClearBackgroundColor = true;
        [self.lineBackgroundV addSubview:_chartV];
        [self.lineBackgroundV sendSubviewToBack:_chartV];
    }
    return _chartV;
}

- (PriceLineV *)lineV {
    if (!_lineV) {
        _lineV = [[NSBundle mainBundle] loadNibNamed:@"PriceLineV" owner:nil options:nil].firstObject;
        _lineV.alpha = 0;
        _lineV.tipTitle = self.model.title;
        kWeakSelf
        _lineV.backBlock = ^{
            [weakSelf lineVHideAct];
        };
        _lineV.selectBlock = ^(NSInteger tag) {
            UIButton *btn = [[UIButton alloc] init];
            btn.tag = tag;
            [weakSelf lineSelectAct:btn];
        };
        _lineV.reloadBlock = ^{
            [weakSelf reloadData];
        };
    }
    return _lineV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self requestData];
    [self reloadData];
}

- (void)setViews {
    [self setNavigationBarWithTitle:self.model.title hasBackBtn:true];
    NSString *version= [UIDevice currentDevice].systemVersion;
    if (version.doubleValue < 11) {
        self.topCon.constant = 64;
        [self.view layoutIfNeeded];
    }
    self.lineTitleLab.text = [NSString stringWithFormat:@"%@价格走势图", self.model.name];
    self.lineV.title = [NSString stringWithFormat:@"%@价格走势图", self.model.name];

    self.requestV.frame = self.backgroundV.bounds;
    [self.backgroundV addSubview:self.requestV];
    self.errorV.frame = self.backgroundV.bounds;
    [self.backgroundV addSubview:self.errorV];
    
    self.currentLineIndex = 0;
    [self setBtns];
    
//    RequestV *requestV = [self createRequestV];
//    requestV.frame = self.lineBackgroundV.bounds;
//    requestV.tag = 10000;
//    [self.lineBackgroundV addSubview:requestV];
//    ErrorV *errorV = [self createErrorV];
//    errorV.frame = self.lineBackgroundV.bounds;
//    errorV.tag = 10001;
    kWeakSelf
//    errorV.buttonClick = ^{
//        weakSelf.lineModelAry[weakSelf.currentLineIndex].requestType = RequestTypeInit;
//        weakSelf.isReload = false;
//        [weakSelf requestLineData];
//    };
//    [self.lineBackgroundV addSubview:errorV];
    
    self.baseTV.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    [self.baseTV registerNib:[UINib nibWithNibName:@"PriceDetailsTableCell" bundle:nil] forCellReuseIdentifier:@"PriceDetailsTableCell"];
    self.baseTV.mj_footer = self.baseTV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        weakSelf.isReload = false;
        [weakSelf requestListData];
    }];
    self.baseTV.backgroundColor = [UIColor clearColor];
    [self.listBackgroundV addSubview:self.baseTV];
    
    [self.view addSubview:self.lineV];
}

- (void)lineVHideAct {
    self.statusHiden = false;
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    kWeakSelf
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.lineV.isFull = false;
        weakSelf.lineV.transform = CGAffineTransformMakeRotation(0);
        weakSelf.lineV.frame = CGRectMake(self.point.x, self.point.y, kScreenW, 170);
//        weakSelf.lineV.alpha = 0;
    }];
}

- (void)lineVShowAct {
    self.statusHiden = true;
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    kWeakSelf
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.lineV.isFull = true;
        weakSelf.lineV.transform = CGAffineTransformMakeRotation(M_PI_2);
        weakSelf.lineV.frame = CGRectMake(0, 0, kScreenW, kScreenH);
//        weakSelf.lineV.alpha = 1;
    }];
}

- (IBAction)infoAct:(id)sender {
    [self.priceDetailsInfoV showView];
}

- (IBAction)fullAct:(id)sender {
    [self lineVShowAct];
}

- (void)setBtns {
    for (NSInteger i = 30000; i < 30005; i ++) {
        UIButton *btn = [self.view viewWithTag:i];
        btn.backgroundColor = kHexColor(i - 30000 == self.currentLineIndex ? @"FF9018" : @"E2EAF8", 1);
        [btn setTitleColor:kHexColor(i - 30000 == self.currentLineIndex ? @"FFFFFF" : @"333333", 1) forState:UIControlStateNormal];
    }
}

- (IBAction)lineSelectAct:(UIButton *)sender {
    if (sender.tag > 30000) {
        if (!self.viewState) {
            if (self.lineV.isFull) {
                [self lineVHideAct];
            }
            [self.alertV showView];
            return;
        } else {
            if (self.isTryVip) {
                if (self.lineV.isFull) {
                    [self lineVHideAct];
                }
                [self.alertV showView];
                return;
            }
        }
    }
    if (self.currentLineIndex != sender.tag - 30000) {
        self.currentLineIndex = sender.tag - 30000;
        self.isReload = false;
        [self setBtns];
        [self resetLineV];
        self.lineV.currentLineIndex = self.currentLineIndex;
    }
}

- (void)requestError {
    self.requestV.alpha = 0;
    self.errorV.alpha = 1;
}

- (void)requestData {
    self.lineModelAry = @[].mutableCopy;
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentdata = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    for (NSInteger i = 0; i < 5; i ++) {
        PriceDetailsLineM *model = [[PriceDetailsLineM alloc] init];
        model.endTime = [dayFormatter stringFromDate:currentdata];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        switch (i) {
            case 0:
                [components setMonth:-1];
                break;
            case 1:
                [components setMonth:-3];
                break;
            case 2:
                [components setMonth:-6];
                break;
            case 3:
                [components setYear:-1];
                break;
            case 4:
                [components setYear:-5];
                break;
            default:
                break;
        }
        model.startTime = [dayFormatter stringFromDate:[calendar dateByAddingComponents:components toDate:currentdata options:0]];
        model.requestType = RequestTypeInit;
        [self.lineModelAry addObject:model];
    }
}

- (void)resetViews {
    self.requestV.alpha = 0;
    self.errorV.alpha = 0;
    self.unitLab.text = [NSString stringWithFormat:@"单位: %@", self.model.priceunitname];
    self.lineV.tipUnitStr = self.model.priceunitname;
    [self resetLineV];
    [self resetListV];
}

- (void)resetLineV {
    if (self.lineV.alpha == 0) {
        self.lineV.alpha = 1;
        self.point = [self.lineBackgroundV convertPoint:CGPointMake(0, 0) toView:[UIApplication sharedApplication].windows.lastObject];
        self.lineV.frame = CGRectMake(self.point.x, self.point.y, kScreenW, 170);
    }
    if (self.viewState) {
        PriceDetailsLineM *model = self.lineModelAry[self.currentLineIndex];
            switch (model.requestType) {
                case RequestTypeInit:
                case RequestTypeGoingReload:
                    if (model.requestType == RequestTypeInit) {
                        model.requestType = RequestTypeGoingReload;
                        [self requestLineData];
                    }
                    self.lineV.type = PriceLineVTypeRequest;
//                    [self.lineBackgroundV viewWithTag:10000].alpha = 1;
//                    [self.lineBackgroundV viewWithTag:10001].alpha = 0;
                    break;
                case RequestTypeSuccessNormal:
                {
                    self.lineV.type = PriceLineVTypeSuccess;
                    self.lineV.model = model;
//                    [self.lineBackgroundV viewWithTag:10000].alpha = 0;
//                    [self.lineBackgroundV viewWithTag:10001].alpha = 0;
        //            AAOptions *options = AAObject(AAOptions)
        //            .titleSet(AAObject(AATitle).textSet(@""))
        //            .chartSet(AAObject(AAChart).typeSet(AAChartTypeLine))
        //            .xAxisSet(AAObject(AAXAxis).labelsSet(AAObject(AALabels).distanceSet(@30).stepSet(@(model.xDataAry.count / 3)).styleSet(AAObject(AAStyle).fontSizeSet(@"10").colorSet(@"#000000"))).categoriesSet(model.xDataAry).crosshairSet(AAObject(AACrosshair).widthSet(@(1)).colorSet(@"#245286")))
        //            .yAxisSet(AAObject(AAYAxis).allowDecimalsSet(false).labelsSet(AAObject(AALabels).distanceSet(@30).stepSet(@(model.yDataAry.count / 3)).styleSet(AAObject(AAStyle).fontSizeSet(@"10").colorSet(@"#000000"))))
        //            .seriesSet(@[AAObject(AASeriesElement).colorSet(@"#FF9018").markerSet(AAObject(AAMarker).radiusSet(@(3)).fillColorSet(@"#FF9018")).nameSet(self.model.title).dataSet(model.yDataAry)]);
//                    AAChartModel *charModel = AAObject(AAChartModel)
//                    .chartTypeSet(AAChartTypeLine)
//                    .titleSet(@"")
//                    .subtitleSet(@"")
//                    .legendEnabledSet(false)
//                    .xAxisLabelsFontColorSet(@"#000000")
//                    .xAxisLabelsFontSizeSet(@(10))
//                    .xAxisTickIntervalSet(@(model.xDataAry.count / 4))
//                    .xAxisCrosshairColorSet(@"#245286")
//                    .xAxisCrosshairWidthSet(@(1))
//                    .yAxisLabelsFontSizeSet(@(10))
//                    .yAxisLabelsFontColorSet(@"#000000")
//        //            .yAxisTickIntervalSet(@(model.yDataAry.count / 4))
//                    .yAxisLineWidthSet(@(1))
//                    .yAxisTitleSet(@"")
//                    .yAxisAllowDecimalsSet(false)
//                    .animationTypeSet(AAChartAnimationEaseInQuad)
//                    .animationDurationSet(@(1))
//                    .tooltipValueSuffixSet([NSString stringWithFormat:@"(%@)", self.model.priceunitname])
//                    .categoriesSet(model.xDataAry)
//                    .seriesSet(@[AAObject(AASeriesElement).colorSet(@"#FF9018").markerSet(AAObject(AAMarker).radiusSet(@(3)).fillColorSet(@"#FF9018")).nameSet(self.model.title).dataSet(model.yDataAry)]);
//                    if (self.isReload) {
//                        [self.chartV aa_drawChartWithChartModel:charModel];
//                    } else {
//                        [self.chartV aa_drawChartWithChartModel:charModel];
//                    }
                    
                }
                    break;
                case RequestTypeError:
//                    [self.lineBackgroundV viewWithTag:10000].alpha = 0;
//                    [self.lineBackgroundV viewWithTag:10001].alpha = 1;
                    self.lineV.type = PriceLineVTypefail;
                    break;
                default:
                    break;
            }
    } else {
        self.lineV.type = PriceLineVTypeRequest;
//        [self.lineBackgroundV viewWithTag:10000].alpha = 0;
//        [self.lineBackgroundV viewWithTag:10001].alpha = 0;
        [self.alertV showView];
    }
}

- (void)resetListV {
    [self.baseTV reloadData];
}

- (void)reloadData {
    self.isReload = true;
    self.requestV.alpha = 1;
    self.errorV.alpha = 0;
    self.lineV.alpha = 0;
    self.page = 1;
    [self requestJurisdicationData];
}

- (void)requestJurisdicationData {
    kWeakSelf
    [Tool POST:JURISDICATION params:@[@{@"vipid":[Tool shareInstance].user.ID}, @{@"productid":@(self.model.ID).stringValue}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSDictionary * _Nonnull result) {
        weakSelf.isTryVip = [result[@"IsTryvip"] boolValue];
        weakSelf.viewState = [result[@"ViewState"] boolValue];
        [weakSelf requestInfoData];
    } failure:^(NSString * _Nonnull error) {
        [weakSelf requestError];
    }];
}

- (void)requestInfoData {
    kWeakSelf
    [Tool POST:PRICEINFO params:@[@{@"pid":@(self.model.pid).stringValue}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSDictionary * _Nonnull result) {
        PriceDetailsM *model = [PriceDetailsM mj_objectArrayWithKeyValuesArray:result[@"paraminfo"]].firstObject;
        NSArray<PriceModelM *> *scdAry = [PriceModelM mj_objectArrayWithKeyValuesArray:result[@"paramscd"]];
        NSArray<PriceModelM *> *tradeAry = [PriceModelM mj_objectArrayWithKeyValuesArray:result[@"paramtrade"]];
        if (scdAry.count) {
            weakSelf.model.placePruduct = scdAry[0].typeName;
        }
        if (tradeAry.count) {
            weakSelf.model.placeTrade = tradeAry[0].typeName;
        }
        weakSelf.model.qname = [model.qname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        weakSelf.model.indexstring = model.indexstring;
        weakSelf.model.pricetypename = model.pricetypename;
        weakSelf.model.priceunitname = [model.priceunitname stringByReplacingOccurrencesOfString:@"目录开始" withString:@""];;
        weakSelf.model.istax = model.istax;
        weakSelf.model.iscash = model.iscash;
        weakSelf.model.bjjgname = model.bjjgname;
        weakSelf.model.updatemarktype = model.updatemarktype;
        weakSelf.model.productid_big = model.productid_big;
        weakSelf.model.payFunction = [NSString stringWithFormat:@"%@%@", model.istax ? @"含税" : @"不含税", model.iscash ? @"现款" : @"非现款"];
        if (weakSelf.isReload) {
            NSInteger titleType = 0;
            CGFloat widCon = 0;
            if (weakSelf.model.bjjgid) {
                switch (weakSelf.model.bjjgid) {
                    case 4127:
//                        if (weakSelf.model.productid_big != 10643 && weakSelf.model.productid_big != 10763) {
//                            titleType = 2;
//                        } else {
//                            titleType = 6;
//                        }
                        if (weakSelf.model.updatemarktype == 17) {
                            titleType = 6;
                        } else if (weakSelf.model.updatemarktype == 12) {
                            titleType = 2;
                        }
                        break;
                    case 10146:
                    case 8330:
                    case 4132:
                    case 4134:
                    case 15166:
                    case 8329:
                        titleType = 4;
                        break;
                    case 4135:
                        if (weakSelf.model.updatemarktype == 11) {
                            titleType = 5;
                        } else {
                            titleType = 4;
                        }
                        break;
                    case 14097:
                    case 4131:
                    case 6366:
                    case 4137:
                    case 15188:
                    case 15189:
                        titleType = 3;
                        break;
                    case 7942:
                        titleType = 1;
                        break;
                    case 8325:
                        titleType = 6;
                        break;
                    case 8328:
                        titleType = 8;
                        break;
                    default:
                        titleType = 1;
                        break;
                }
            }
            
            weakSelf.titleType = titleType;
            CGFloat kScale = (kScreenW / 360 < 1 ? 1 : kScreenW / 360);
            CGFloat wid = 80 * kScale;
            switch (titleType) {
                case 1:
                    wid = (kScreenW - 60 * kScale) / 6 > wid ? (kScreenW - 60 * kScale) / 6 : wid;
                    widCon = wid * 6 + 60 *kScale;
                    break;
                case PriceDetailsTitleType2:
                    wid = (kScreenW - 60 * kScale) / 6 > wid ? (kScreenW - 60 * kScale) / 6 : wid;
                    widCon = wid * 6 + 60 *kScale;
                    break;
                case PriceDetailsTitleType3:
                    wid = (kScreenW - 60 * kScale) / 5 > wid ? (kScreenW - 60 * kScale) / 5 : wid;
                    widCon = wid * 5 + 60 * kScale + 0.01;
                    break;
                case PriceDetailsTitleType4:
                    wid = (kScreenW - 60 * kScale) / 4 > wid ? (kScreenW - 60 * kScale) / 4 : wid;
                    widCon = wid * 4 + 60 * kScale + 0.02;
                    break;
                case PriceDetailsTitleType5:
                    wid = (kScreenW - 60 * kScale) / 3 > wid ? (kScreenW - 60 * kScale) / 3 : wid;
                    widCon = wid * 3 + 60 * kScale + 0.03;
                    break;
                case PriceDetailsTitleType6:
                    wid = (kScreenW - 60 * kScale) / 3 > wid ? (kScreenW - 60 * kScale) / 3 : wid;
                    widCon = wid * 3 + 60 * kScale + 0.03;
                    break;
                case PriceDetailsTitleType7:
                    wid = (kScreenW - 60 * kScale) / 6 > wid ? (kScreenW - 60 * kScale) / 6 : wid;
                    widCon = wid * 6 + 60 * kScale;
                    break;
                case PriceDetailsTitleType8:
                    wid = (kScreenW - 60 * kScale) / 3 > wid ? (kScreenW - 60 * kScale) / 3 : wid;
                    widCon = wid * 3 + 60 * kScale + 0.03;
                    break;
                case PriceDetailsTitleType9:
                    wid = (kScreenW - 60 * kScale) / 6 > wid ? (kScreenW - 60 * kScale) / 6 : wid;
                    widCon = wid * 6 + 60 * kScale;
                    break;
                default:
                    wid = (kScreenW - 60 * kScale) / 5 > wid ? (kScreenW - 60 * kScale) / 5 : wid;
                    widCon = wid * 5 + 60 * kScale + 0.01;
                    break;
            }
            weakSelf.listBackgroundVWidCon.constant = widCon;
            [weakSelf.view layoutIfNeeded];
            weakSelf.priceDetailsTitleV.frame = weakSelf.listTitleBackgroundV.bounds;
            weakSelf.priceDetailsTitleV.type = titleType;
            [weakSelf.listTitleBackgroundV addSubview:weakSelf.priceDetailsTitleV];
            weakSelf.baseTV.frame = CGRectMake(0, 0, widCon, kScreenH - kTopVH - kBottomH - 340);
        }
        [weakSelf requestLineData];
    } failure:^(NSString * _Nonnull error) {
        [weakSelf requestError];
    }];
}

- (void)requestLineData {
    PriceDetailsLineM *model = self.lineModelAry[self.currentLineIndex];
    model.requestType = RequestTypeGoingReload;
    kWeakSelf
    [Tool POST:PRICELINE params:@[@{@"pid":@(self.model.pid).stringValue}, @{@"start":model.startTime}, @{@"end":model.endTime}, @{@"updatemarktype":@(self.model.updatemarktype).stringValue}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSDictionary * _Nonnull result) {
        [Tool POST:VIEWLOG params:@[@{@"viewid":@(weakSelf.model.pid).stringValue}, @{@"type":@"3"}, @{@"vipid":[Tool shareInstance].user.ID}, @{@"isvip":@"1"}, @{@"issuccess":weakSelf.viewState ? @"1" : @"0"}, @{@"remark":@""}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull logProgress) {
            
        } success:^(NSDictionary * _Nonnull logResult) {
            
        } failure:^(NSString * _Nonnull logError) {
            
        }];
        model.requestType = RequestTypeSuccessNormal;
        NSArray *priceAry = (NSArray *)result[@"chartprice"];
        model.yDataAry = @[].mutableCopy;
        if (priceAry.count) {
            NSString *priceList = priceAry[0][@"pricelist"];
            NSArray *priceListAry = [priceList componentsSeparatedByString:@","];
            CGFloat max = 0;
            CGFloat min = MAXFLOAT;
            for (NSString *str in priceListAry) {
                max = fmax(max, str.floatValue);
                min = fmin(min, str.floatValue);
                [model.yDataAry addObject:str];
            }
            if (max == min) {
                max += 1;
                min -= 1;
            }
            if (min - (max - min) / 4 < 0) {
                model.yData1 = @(max / 2 * 3).stringValue;
                model.yData2 = @(max).stringValue;
                model.yData3 = @(max / 2).stringValue;
                model.yData4 = @(0).stringValue;
            } else {
                model.yData1 = @(max + (max - min) / 4).stringValue;
                model.yData2 = @(max - (max - min) / 4).stringValue;
                model.yData3 = @(min + (max - min) / 4).stringValue;
                model.yData4 = @(min - (max - min) / 4).stringValue;
            }
            model.yScaleAry = @[].mutableCopy;
            for (NSString *str in priceListAry) {
                [model.yScaleAry addObject:@((str.floatValue - model.yData4.floatValue) / (model.yData1.floatValue - model.yData4.floatValue))];
            }
        }
        NSArray *dateAry = (NSArray *)result[@"chartdate"];
        model.xDataAry = @[].mutableCopy;
        if (dateAry.count) {
            NSString *dateList = dateAry[0][@"datelist"];
            NSArray *dateListAry = [dateList componentsSeparatedByString:@","].mutableCopy;
            for (NSString *str in dateListAry) {
                [model.xDataAry addObject:[str stringByReplacingOccurrencesOfString:@"'" withString:@""]];
            }
            NSInteger dif = (dateListAry.count - 4) / 3;
            model.xData1 = model.xDataAry[0];
            model.xData2 = model.xDataAry[dif + 1];
            model.xData3 = model.xDataAry[dif * 2 + 2];
            model.xData4 = model.xDataAry.lastObject;
        }
        if (weakSelf.isReload) {
            [weakSelf requestListData];
        } else {
            if ([weakSelf.lineModelAry indexOfObject:model] == weakSelf.currentLineIndex) {
                [weakSelf resetLineV];
            }
        }
    } failure:^(NSString * _Nonnull error) {
        if (weakSelf.isReload) {
            [weakSelf requestError];
        } else {
            model.requestType = RequestTypeInit;
            if ([weakSelf.lineModelAry indexOfObject:model] == weakSelf.currentLineIndex) {
                weakSelf.isReload = false;
                [weakSelf requestLineData];
            }
        }
    }];
}

- (void)requestListData {
    kWeakSelf
    [Tool POST:PRICELIST params:@[@{@"pid":@(self.model.pid).stringValue}, @{@"pagesize":@(20).stringValue}, @{@"pageindex":@(self.page).stringValue}, @{@"updatemarktype":@(self.model.updatemarktype).stringValue}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSDictionary * _Nonnull result) {
        if (weakSelf.isReload) {
            weakSelf.dataAry = @[].mutableCopy;
        }
        if (!weakSelf.viewState) {
            PriceDetailsPriceM *model = [[PriceDetailsPriceM alloc] init];
            model.cellHeight = kScreenH - kTopVH - kBottomH - 340 > 500 ? kScreenH - kTopVH - kBottomH - 340 : 500;
            model.isEmpty = true;
            [weakSelf.dataAry addObject:model];
            weakSelf.baseTV.mj_footer = nil;
        } else {
            NSArray *array = [PriceDetailsPriceM mj_objectArrayWithKeyValuesArray:result[@"historyprice"]];
            NSDateComponents *components = [[NSDateComponents alloc] init];
            [components setMonth:-1];
            NSDate *date = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] dateByAddingComponents:components toDate:[NSDate date] options:0];
            NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
            [dayFormatter setDateFormat:@"yyyy/MM/dd"];
            NSDateFormatter *dayFormatterL = [[NSDateFormatter alloc] init];
            [dayFormatterL setDateFormat:@"MM-dd"];
            for (PriceDetailsPriceM *priceModel in array) {
                NSArray *dateAry = [priceModel.valuedate componentsSeparatedByString:@" "];
                if (self.isTryVip) {
                    if (dateAry.count == 2) {
                        if ([dayFormatter dateFromString:dateAry[0]].timeIntervalSince1970 < date.timeIntervalSince1970) {
                            [weakSelf.baseTV.mj_footer endRefreshingWithNoMoreData];
                            break;
                        }
                    }
                }
                if (dateAry.count == 2) {
                    priceModel.price1 = [dayFormatterL stringFromDate:[dayFormatter dateFromString:dateAry[0]]];
                }
                switch (weakSelf.titleType) {
                    case 1:
                    {
                        if (weakSelf.model.updatemarktype == 1) {
                            priceModel.price2 = [Tool transPrice:priceModel.vopen];
                            priceModel.price3 = [Tool transPrice:priceModel.vclose];
                            CGFloat zd = priceModel.vzdf.floatValue;
                            NSString *zdP = [priceModel.vzdf containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceModel.vzdf.floatValue] : priceModel.vzdf;
                            if (!zdP) {
                                zdP = @"0";
                            }
                            zdP = zd > 0 ? [NSString stringWithFormat:@"+%@", zdP] : zdP;
                            priceModel.price4 = zdP;
                            priceModel.color4 = zd ? zd > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
                            priceModel.price5 = [Tool transPrice:priceModel.vjsj];
                            priceModel.price6 = [Tool transPrice:priceModel.vcjl];
                            priceModel.price7 = [Tool transPrice:priceModel.vccl];
                        } else if (weakSelf.model.updatemarktype == 15) {
                            priceModel.price2 = [Tool transPrice:priceModel.price_open];
                            priceModel.price3 = [Tool transPrice:priceModel.price_close];
                            CGFloat zd = priceModel.price_close_zdf.floatValue;
                            NSString *zdP = [priceModel.price_close_zdf containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceModel.price_close_zdf.floatValue] : priceModel.price_close_zdf;
                            if (!zdP) {
                                zdP = @"0";
                            }
                            zdP = zd > 0 ? [NSString stringWithFormat:@"+%@", zdP] : zdP;
                            priceModel.price4 = zdP;
                            priceModel.color4 = zd ? zd > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
                            priceModel.price5 = @"";
                            priceModel.price6 = [Tool transPrice:priceModel.data_cjl];
                            priceModel.price7 = [Tool transPrice:priceModel.data_ccl];
                        }
                    }
                        break;
                    case 2:
                    {
                        priceModel.price2 = [Tool transPrice:priceModel.price_buy];
                        CGFloat zd = priceModel.price_buy_zde.floatValue;
                        NSString *zdP = [priceModel.price_buy_zde containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceModel.price_buy_zde.floatValue] : priceModel.price_buy_zde;
                        if (!zdP) {
                            zdP = @"0";
                        }
                        zdP = zd > 0 ? [NSString stringWithFormat:@"+%@", zdP] : zdP;
                        priceModel.price3 = zdP;
                        priceModel.color3 = zd ? zd > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
                        zdP = [priceModel.price_buy_zdf containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceModel.price_buy_zdf.floatValue] : priceModel.price_buy_zdf;
                        if (!zdP) {
                            zdP = @"0";
                        }
                        zdP = zd > 0 ? [NSString stringWithFormat:@"+%@", zdP] : zdP;
                        priceModel.price4 = zdP;
                        priceModel.color4 = zd ? zd > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
                        priceModel.price5 = priceModel.price_sell;
                        zd = priceModel.price_sell_zde.floatValue;
                        zdP = [priceModel.price_sell_zde containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceModel.price_sell_zde.floatValue] : priceModel.price_sell_zde;
                        if (!zdP) {
                            zdP = @"0";
                        }
                        zdP = zd > 0 ? [NSString stringWithFormat:@"+%@", zdP] : zdP;
                        priceModel.price6 = zdP;
                        priceModel.color6 = zd ? zd > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
                        zdP = [priceModel.price_sell_zdf containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceModel.price_sell_zdf.floatValue] : priceModel.price_sell_zdf;
                        if (!zdP) {
                            zdP = @"0";
                        }
                        zdP = zd > 0 ? [NSString stringWithFormat:@"+%@", zdP] : zdP;
                        priceModel.price7 = zdP;
                        priceModel.color7 = zd ? zd > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
                    }
                        break;
                    case 3:
                    {
                        priceModel.price2 = [Tool transPrice:priceModel.price_min];
                        priceModel.price3 = [Tool transPrice:priceModel.price_max];
                        priceModel.price4 = [Tool transPrice:priceModel.price_avg];
                        CGFloat zd = priceModel.price_zde.floatValue;
                        NSString *zdP = [priceModel.price_zde containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceModel.price_zde.floatValue] : priceModel.price_zde;
                        if (!zdP) {
                            zdP = @"0";
                        }
                        zdP = zd > 0 ? [NSString stringWithFormat:@"+%@", zdP] : zdP;
                        priceModel.price5 = zdP;
                        priceModel.color5 = zd ? zd > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
                        zdP = [priceModel.price_zdf containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceModel.price_zdf.floatValue] : priceModel.price_zdf;
                        if (!zdP) {
                            zdP = @"0";
                        }
                        zdP = zd > 0 ? [NSString stringWithFormat:@"+%@", zdP] : zdP;
                        priceModel.price6 = zdP;
                        priceModel.color6 = zd ? zd > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
                        priceModel.price7 = @"";
                    }
                        break;
                    case 4:
                    {
                        priceModel.price2 = [Tool transPrice:priceModel.price_min];
                        priceModel.price3 = [Tool transPrice:priceModel.price_max];
                        priceModel.price4 = [Tool transPrice:priceModel.price_avg];
                        CGFloat zd = priceModel.price_zde.floatValue;
                        NSString *zdP = [priceModel.price_zde containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceModel.price_zde.floatValue] : priceModel.price_zde;
                        if (!zdP) {
                            zdP = @"0";
                        }
                        zdP = zd > 0 ? [NSString stringWithFormat:@"+%@", zdP] : zdP;
                        priceModel.price5 = zdP;
                        priceModel.color5 = zd ? zd > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
                        priceModel.price6 = @"";
                        priceModel.price7 = @"";
                    }
                        break;
                    case 5:
                    {
                        priceModel.price2 = [Tool transPrice:priceModel.price_dp];
                        priceModel.price3 = [Tool transPrice:priceModel.price_js];
                        CGFloat zd = priceModel.price_jszde.floatValue;
                        NSString *zdP = [priceModel.price_jszde containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceModel.price_jszde.floatValue] : priceModel.price_jszde;
                        if (!zdP) {
                            zdP = @"0";
                        }
                        zdP = zd > 0 ? [NSString stringWithFormat:@"+%@", zdP] : zdP;
                        priceModel.price4 = zdP;
                        priceModel.color4 = zd ? zd > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
                        priceModel.price5 = @"";
                        priceModel.price6 = @"";
                        priceModel.price7 = @"";
                    }
                        break;
                    case 6:
                    {
                        if (weakSelf.model.updatemarktype == 17) {
                            priceModel.price2 = [Tool transPrice:priceModel.price_close];
                            CGFloat zd = priceModel.price_close_zde.floatValue;
                            NSString *zdP = [priceModel.price_close_zde containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceModel.price_close_zde.floatValue] : priceModel.price_close_zde;
                            if (!zdP) {
                                zdP = @"0";
                            }
                            zdP = zd > 0 ? [NSString stringWithFormat:@"+%@", zdP] : zdP;
                            priceModel.price3 = zdP;
                            priceModel.color3 = zd ? zd > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
                            zdP = [priceModel.price_close_zdf containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceModel.price_close_zdf.floatValue] : priceModel.price_close_zdf;
                            if (!zdP) {
                                zdP = @"0";
                            }
                            zdP = zd > 0 ? [NSString stringWithFormat:@"+%@", zdP] : zdP;
                            priceModel.price4 = zdP;
                            priceModel.color4 = zd ? zd > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
                            priceModel.price5 = @"";
                            priceModel.price6 = @"";
                            priceModel.price7 = @"";
                        } else {
                            priceModel.price2 = [Tool transPrice:priceModel.price_close];
                            CGFloat zd = priceModel.price_zde.floatValue;
                            NSString *zdP = [priceModel.price_zde containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceModel.price_zde.floatValue] : priceModel.price_zde;
                            if (!zdP) {
                                zdP = @"0";
                            }
                            zdP = zd > 0 ? [NSString stringWithFormat:@"+%@", zdP] : zdP;
                            priceModel.price3 = zdP;
                            priceModel.color3 = zd ? zd > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
                            zdP = [priceModel.price_zdf containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceModel.price_zdf.floatValue] : priceModel.price_zdf;
                            if (!zdP) {
                                zdP = @"0";
                            }
                            zdP = zd > 0 ? [NSString stringWithFormat:@"+%@", zdP] : zdP;
                            priceModel.price4 = zdP;
                            priceModel.color4 = zd ? zd > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
                            priceModel.price5 = @"";
                            priceModel.price6 = @"";
                            priceModel.price7 = @"";
                        }
                    }
                        break;
                    case 7:
                    {
                        priceModel.price2 = [Tool transPrice:priceModel.price_buy];
                        priceModel.price3 = [Tool transPrice:priceModel.price_sell];
                        priceModel.price4 = [Tool transPrice:priceModel.price_max];
                        priceModel.price5 = [Tool transPrice:priceModel.price_min];
                        priceModel.price6 = [Tool transPrice:priceModel.price_avg];
                        CGFloat zd = priceModel.price_zde.floatValue;
                        NSString *zdP = [priceModel.price_zde containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceModel.price_zde.floatValue] : priceModel.price_zde;
                        if (!zdP) {
                            zdP = @"0";
                        }
                        zdP = zd > 0 ? [NSString stringWithFormat:@"+%@", zdP] : zdP;
                        priceModel.price7 = zdP;
                        priceModel.color7 = zd ? zd > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
                    }
                        break;
                    case 8:
                    {
                        priceModel.price2 = [Tool transPrice:priceModel.price_close];
                        CGFloat zd = priceModel.price_close_zde.floatValue;
                        NSString *zdP = [priceModel.price_close_zde containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceModel.price_close_zde.floatValue] : priceModel.price_close_zde;
                        if (!zdP) {
                            zdP = @"0";
                        }
                        zdP = zd > 0 ? [NSString stringWithFormat:@"+%@", zdP] : zdP;
                        priceModel.price3 = zdP;
                        priceModel.color3 = zd ? zd > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
                        zdP = [priceModel.price_close_zdf containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceModel.price_close_zdf.floatValue] : priceModel.price_close_zdf;
                        if (!zdP) {
                            zdP = @"0";
                        }
                        zdP = zd > 0 ? [NSString stringWithFormat:@"+%@", zdP] : zdP;
                        priceModel.price4 = zdP;
                        priceModel.color4 = zd ? zd > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
                        priceModel.price5 = @"";
                        priceModel.price6 = @"";
                        priceModel.price7 = @"";
                    }
                        break;
                    case 9:
                    {
                        priceModel.price2 = [Tool transPrice:priceModel.price_open];
                        priceModel.price3 = [Tool transPrice:priceModel.price_max];
                        priceModel.price4 = [Tool transPrice:priceModel.price_min];
                        priceModel.price5 = [Tool transPrice:priceModel.price_close];
                        CGFloat zd = priceModel.price_close_zde.floatValue;
                        NSString *zdP = [priceModel.price_close_zde containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceModel.price_close_zde.floatValue] : priceModel.price_close_zde;
                        if (!zdP) {
                            zdP = @"0";
                        }
                        zdP = zd > 0 ? [NSString stringWithFormat:@"+%@", zdP] : zdP;
                        priceModel.price6 = zdP;
                        priceModel.color6 = zd ? zd > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
                        zdP = [priceModel.price_close_zdf containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceModel.price_close_zdf.floatValue] : priceModel.price_close_zdf;
                        if (!zdP) {
                            zdP = @"0";
                        }
                        zdP = zd > 0 ? [NSString stringWithFormat:@"+%@", zdP] : zdP;
                        priceModel.price7 = zdP;
                        priceModel.color7 = zd ? zd > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
                    }
                        break;
                    default:
                    {
                        priceModel.price2 = [Tool transPrice:priceModel.price_min];
                        priceModel.price3 = [Tool transPrice:priceModel.price_max];
                        priceModel.price4 = [Tool transPrice:priceModel.price_avg];
                        CGFloat zd = priceModel.price_zde.floatValue;
                        NSString *zdP = [priceModel.price_zde containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceModel.price_zde.floatValue] : priceModel.price_zde;
                        if (!zdP) {
                            zdP = @"0";
                        }
                        zdP = zd > 0 ? [NSString stringWithFormat:@"+%@", zdP] : zdP;
                        priceModel.price5 = zdP;
                        priceModel.color5 = zd ? zd > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
                        zdP = [priceModel.price_zdf containsString:@"."] ? [NSString stringWithFormat:@"%.2f", priceModel.price_zdf.floatValue] : priceModel.price_zdf;
                        if (!zdP) {
                            zdP = @"0";
                        }
                        zdP = zd > 0 ? [NSString stringWithFormat:@"+%@", zdP] : zdP;
                        priceModel.price6 = zdP;
                        priceModel.color6 = zd ? zd > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
                        priceModel.price7 = @"";
                    }
                        break;
                }
                priceModel.cellHeight = 40;
                [weakSelf.dataAry addObject:priceModel];
            }
            if (weakSelf.dataAry.count) {
                if (weakSelf.dataAry.count < weakSelf.page * 20) {
                    [weakSelf.baseTV.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [weakSelf.baseTV.mj_footer endRefreshing];
                }
            } else {
                PriceDetailsPriceM *model = [[PriceDetailsPriceM alloc] init];
                model.cellHeight = kScreenH - kTopVH - kBottomH - 340 > 500 ? kScreenH - kTopVH - kBottomH - 340 : 500;
                model.isEmpty = true;
                weakSelf.baseTV.mj_footer = nil;
                [weakSelf.dataAry addObject:model];
                weakSelf.baseTV.mj_footer = nil;
            }
        }
        if (weakSelf.isReload) {
            [weakSelf resetViews];
        } else {
            [weakSelf resetListV];
        }
    } failure:^(NSString * _Nonnull error) {
        if (weakSelf.isReload) {
            [weakSelf requestError];
        } else {
            weakSelf.page -= 1;
            [weakSelf.baseTV.mj_footer endRefreshing];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataAry[0].isEmpty) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        NoDataV *v = [[[NSBundle mainBundle] loadNibNamed:@"NoDataV" owner:nil options:NULL] lastObject];
        v.viewType = NoDataViewTypePrice;
        v.frame = cell.bounds;
        [cell.contentView addSubview:v];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        PriceDetailsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PriceDetailsTableCell" forIndexPath:indexPath];
        if (!cell.isSet) {
            cell.type = self.titleType;
        }
        cell.model = self.dataAry[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataAry[indexPath.row].cellHeight;
}

@end
