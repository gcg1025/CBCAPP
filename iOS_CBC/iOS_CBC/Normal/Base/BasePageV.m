//
//  BasePageV.m
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/27.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import "BasePageV.h"
#import "NewsCell.h"
#import "TableTitleV.h"
#import "StoPriceTitleTableCell.h"
#import "StoPriceTableCell.h"
#import "FOFPriceTitleTableCell.h"
#import "FOFPriceTableCell.h"
#import "FOOPriceTitleTableCell.h"
#import "FOOPriceTableCell.h"
#import "EntBidPriceTableCell.h"

@interface BasePageV () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *viewAry;
@property (nonatomic, strong) UIScrollView *scrollV;
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger scrollIndex;
@property (nonatomic, assign) CGRect currentFrame;

@end

@implementation BasePageV

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentIndex = -1;
    }
    return self;
}

- (NSMutableArray *)viewAry {
    if (!_viewAry) {
        _viewAry = @[].mutableCopy;
    }
    return _viewAry;
}

- (UIScrollView *)scrollV {
    if (!_scrollV) {
        _scrollV = [[UIScrollView alloc] init];
        _scrollV.pagingEnabled = true;
        _scrollV.showsVerticalScrollIndicator = false;
        _scrollV.showsHorizontalScrollIndicator = false;
        _scrollV.delegate = self;
    }
    return _scrollV;
}

- (void)setDataAry:(NSMutableArray<PageDataM *> *)dataAry {
    _dataAry = dataAry;
    if (!self.scrollV.superview) {
        self.scrollV.frame = self.bounds;
        [self addSubview:self.scrollV];
    }
    if (self.viewAry.count != dataAry.count) {
        kWeakSelf
        if (self.viewAry.count < dataAry.count) {
            for (NSInteger i = self.viewAry.count; i < dataAry.count; i ++) {
                self.currentFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                UIView *view = [[UIView alloc] initWithFrame:self.currentFrame];
                view.tag = 1000 + i;
                [self.scrollV addSubview:view];
                [self.viewAry addObject:view];
                RequestV *requestV = [[NSBundle mainBundle] loadNibNamed:@"RequestV" owner:nil options:nil].firstObject;
                requestV.frame = self.currentFrame;
                requestV.tag = 10001;
                [view addSubview:requestV];
                view.frame = CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                ErrorV *errorV = [[NSBundle mainBundle] loadNibNamed:@"ErrorV" owner:nil options:nil].firstObject;
                errorV.frame = self.currentFrame;
                errorV.buttonClick = ^{
                    PageDataM *model = weakSelf.dataAry[i];
                    if (model.flag == 1 || model.flag == 2) {
                        NSString *key = [NSString stringWithFormat:@"Ent%@", @(self.ID).stringValue];
                        if (model.flag == 2) {
                            key = [NSString stringWithFormat:@"Bid%@", @(self.ID).stringValue];
                        }
                        NSString *index = kValueForKey(key);
                        ((PriceEntBidClassM *)model.dataAry[index.integerValue]).requestType = RequestTypeInit;
                    }
                    model.requestType = RequestTypeInit;
                    [weakSelf setViewWithIndex:i requestType:RequestTypeInit];
                    [weakSelf requestData];
                };
                errorV.tag = 10002;
                [view addSubview:errorV];
                BaseTV *baseTV = [[BaseTV alloc] initWithFrame:CGRectMake(0, self.dataType == DataTypePrice ? 40 : 0, self.frame.size.width, self.frame.size.height - (self.dataType == DataTypePrice ? 40 : 0))];
                baseTV.backgroundColor = [UIColor clearColor];
                [baseTV registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:@"NewsCell"];
                [baseTV registerNib:[UINib nibWithNibName:@"StoPriceTitleTableCell" bundle:nil] forCellReuseIdentifier:@"StoPriceTitleTableCell"];
                [baseTV registerNib:[UINib nibWithNibName:@"StoPriceTableCell" bundle:nil] forCellReuseIdentifier:@"StoPriceTableCell"];
                [baseTV registerNib:[UINib nibWithNibName:@"FOFPriceTitleTableCell" bundle:nil] forCellReuseIdentifier:@"FOFPriceTitleTableCell"];
                [baseTV registerNib:[UINib nibWithNibName:@"FOFPriceTableCell" bundle:nil] forCellReuseIdentifier:@"FOFPriceTableCell"];
                [baseTV registerNib:[UINib nibWithNibName:@"FOOPriceTitleTableCell" bundle:nil] forCellReuseIdentifier:@"FOOPriceTitleTableCell"];
                [baseTV registerNib:[UINib nibWithNibName:@"FOOPriceTableCell" bundle:nil] forCellReuseIdentifier:@"FOOPriceTableCell"];
                [baseTV registerNib:[UINib nibWithNibName:@"EntBidPriceTableCell" bundle:nil] forCellReuseIdentifier:@"EntBidPriceTableCell"];
                baseTV.delegate = self;
                baseTV.dataSource = self;
                baseTV.tag = 10003;
                if (self.dataType == DataTypeNews) {
                    baseTV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                        if (weakSelf.refreshBlock) {
                            if (weakSelf.dataAry[i].requestType != RequestTypeGoingReload) {
                                weakSelf.dataAry[i].requestType = RequestTypeGoingReload;
                                weakSelf.refreshBlock(self.ID, weakSelf.dataAry[i], true, nil);
                            }
                        }
                    }];
                }
                [view addSubview:baseTV];
                
                if (self.dataType == DataTypePrice) {
                    TableTitleV *tableTitleV = [[NSBundle mainBundle] loadNibNamed:@"TableTitleV" owner:nil options:nil].firstObject;
                    tableTitleV.frame = CGRectMake(0, 0, self.frame.size.width, 40);
                    tableTitleV.type = self.dataAry[i].flag;
                    tableTitleV.selectBlock = ^{
                        if (weakSelf.selectBlock) {
                            weakSelf.selectBlock(weakSelf.dataAry[i]);
                        }
                    };
                    tableTitleV.tag = 10004;
                    [view addSubview:tableTitleV];
                }
                
            }
        } else {
            NSInteger count = self.viewAry.count;
            NSMutableArray *viewAry = self.viewAry.mutableCopy;
            for (NSInteger i = dataAry.count; i < count; i ++) {
                [viewAry[i] removeFromSuperview];
                [self.viewAry removeObject:viewAry[i]];
            }
        }
    }
    self.scrollV.contentSize = CGSizeMake(kScreenW * self.viewAry.count, self.frame.size.height);
    if (self.dataType == DataTypePrice) {
        self.scrollV.contentOffset = CGPointMake(0, 0);
    }
    kWeakSelf
    for (PageDataM *model in dataAry) {
        BaseTV *baseTV = [self.viewAry[[dataAry indexOfObject:model]] viewWithTag:10003];
        if (baseTV) {
            baseTV.contentOffset = CGPointMake(0, 0);
        }
        [self setViewWithIndex:[dataAry indexOfObject:model] requestType:model.requestType];
        if (self.dataType == DataTypePrice) {
            TableTitleV *tableTitleV = [self.viewAry[[dataAry indexOfObject:model]] viewWithTag:10004];
            tableTitleV.type = model.flag;
            tableTitleV.selectBlock = ^{
                if (weakSelf.selectBlock) {
                    weakSelf.selectBlock(model);
                }
            };
        }
    }
}

- (void)setViewWithModel:(PageDataM *)model {
    if ([self.dataAry containsObject:model]) {
        [self setViewWithIndex:[self.dataAry indexOfObject:model] requestType:model.requestType];
    }
}

- (void)setViewWithIndex:(NSInteger)index requestType:(RequestType)requestType {
    if (index < self.viewAry.count) {
        UIView *view = self.viewAry[index];
        PageDataM *model = self.dataAry[index];
        if (self.dataType == DataTypePrice) {
            if (model.flag == 1 || model.flag == 2) {
                NSString *key = [NSString stringWithFormat:@"Ent%@", @(self.ID).stringValue];
                if (model.flag == 2) {
                    key = [NSString stringWithFormat:@"Bid%@", @(self.ID).stringValue];
                }
                NSString *dataIndex = kValueForKey(key);
                if (model.dataAry.count) {
                    PriceEntBidClassM *classM = (PriceEntBidClassM *)model.dataAry[dataIndex.integerValue];
                    requestType = classM.requestType;
                }
            }
        }
        kWeakSelf
        switch (requestType) {
            case RequestTypeInit:
            {
                [view viewWithTag:10001].alpha = 1;
                [view viewWithTag:10002].alpha = 0;
                [view viewWithTag:10003].alpha = 0;
                if ([view viewWithTag:10004]) {
                    [view viewWithTag:10004].alpha = 0;
                }
            }
                break;
            case RequestTypeGoingReload:
            {
                [view viewWithTag:10001].alpha = 1;
                [view viewWithTag:10002].alpha = 0;
                [view viewWithTag:10003].alpha = 0;
            }
                break;
            case RequestTypeGoingRefresh:
            {
                [view viewWithTag:10001].alpha = 0;
                [view viewWithTag:10002].alpha = 0;
                BaseTV *baseTV = [view viewWithTag:10003];
                baseTV.alpha = 1;
                [baseTV reloadData];
                [baseTV.mj_header beginRefreshing];
            }
                break;
            case RequestTypeGoingRequest:
            {
                [view viewWithTag:10001].alpha = 0;
                [view viewWithTag:10002].alpha = 0;
                BaseTV *baseTV = [view viewWithTag:10003];
                baseTV.alpha = 1;
                [baseTV reloadData];
                if (!baseTV.mj_footer) {
                    baseTV.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
                        if (weakSelf.refreshBlock) {
                            if (weakSelf.dataAry[index].requestType != RequestTypeGoingRequest) {
                                weakSelf.dataAry[index].requestType = RequestTypeGoingRequest;
                                weakSelf.refreshBlock(self.ID, weakSelf.dataAry[index], false, nil);
                            }
                        }
                    }];
                }
                [baseTV.mj_footer beginRefreshing];
            }
                break;
            case RequestTypeSuccessEmpty:
            {
                [view viewWithTag:10001].alpha = 0;
                [view viewWithTag:10002].alpha = 0;
                BaseTV *baseTV = [view viewWithTag:10003];
                baseTV.alpha = 1;
                [baseTV reloadData];
                if ([view viewWithTag:10004]) {
                    [view viewWithTag:10004].alpha = 0;
                }
                if (baseTV.mj_header) {
                    [baseTV.mj_header endRefreshing];
                }
                baseTV.mj_footer = nil;
            }
                break;
            case RequestTypeSuccessNormal:
            {
                [view viewWithTag:10001].alpha = 0;
                [view viewWithTag:10002].alpha = 0;
                BaseTV *baseTV = [view viewWithTag:10003];
                baseTV.alpha = 1;
                [baseTV reloadData];
                if ([view viewWithTag:10004]) {
                    [view viewWithTag:10004].alpha = 1;
                }
                if (self.dataType == DataTypeNews || model.flag == 1 || model.flag == 2) {
                    if (baseTV.mj_header) {
                        [baseTV.mj_header endRefreshing];
                    }
                    if (!baseTV.mj_footer) {
                        if (self.dataType == DataTypeNews) {
                            baseTV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                                if (weakSelf.refreshBlock) {
                                    if (weakSelf.dataAry[index].requestType != RequestTypeGoingRequest) {
                                        weakSelf.dataAry[index].requestType = RequestTypeGoingRequest;
                                        weakSelf.refreshBlock(self.ID, weakSelf.dataAry[index], false, nil);
                                    }
                                }
                            }];
                        } else {
                            baseTV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                                if (weakSelf.refreshBlock) {
                                    weakSelf.refreshBlock(self.ID, weakSelf.dataAry[index], false, nil);
                                }
                            }];
                        }
                    }
                    [baseTV.mj_footer endRefreshing];
                } else {
                    baseTV.mj_footer = nil;
                }
            }
                break;
            case RequestTypeSuccessNomoreData:
            {
                [view viewWithTag:10001].alpha = 0;
                [view viewWithTag:10002].alpha = 0;
                BaseTV *baseTV = [view viewWithTag:10003];
                baseTV.alpha = 1;
                [baseTV reloadData];
                if ([view viewWithTag:10004]) {
                    [view viewWithTag:10004].alpha = 1;
                }
                if (baseTV.mj_header) {
                    [baseTV.mj_header endRefreshing];
                }
                if (!baseTV.mj_footer) {
                    baseTV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        if (weakSelf.dataAry[index].requestType != RequestTypeGoingRequest) {
                            if (weakSelf.refreshBlock) {
                                weakSelf.dataAry[index].requestType = RequestTypeGoingRequest;
                                weakSelf.refreshBlock(self.ID, weakSelf.dataAry[index], false, nil);
                            }
                        }
                    }];
                }
                [baseTV.mj_footer endRefreshingWithNoMoreData];
            }
                break;
            case RequestTypeError:
            {
                [view viewWithTag:10001].alpha = 0;
                [view viewWithTag:10002].alpha = 1;
                [view viewWithTag:10003].alpha = 0;
            }
                break;
            default:
                break;
        }
    }
}

- (void)scrollToIndex:(NSInteger)index {
    self.scrollIndex = index;
    if (self.scrollV.contentOffset.x / self.frame.size.width != index) {
        [self.scrollV setContentOffset:CGPointMake(self.frame.size.width * index, 0) animated:true];
    } else {
        if (self.scrollIndex < self.dataAry.count) {
            if (self.currentIndex != self.scrollIndex) {
                if (self.currentIndex >= 0 && self.currentIndex < self.dataAry.count) {
                    self.dataAry[self.currentIndex].requestType = RequestTypeInit;
                    self.dataAry[self.currentIndex].dataAry = @[].mutableCopy;
                    [self setViewWithIndex:self.currentIndex requestType:RequestTypeInit];
                }
                self.currentIndex = self.scrollIndex;
            }
            [self requestData];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.scrollIndex < self.dataAry.count) {
        if (self.currentIndex != self.scrollIndex) {
            if (self.currentIndex >= 0 && self.currentIndex < self.dataAry.count) {
                PageDataM *model = [[PageDataM alloc] init];
                model.flag = self.dataAry[self.currentIndex].flag;
                model.dataAry = @[].mutableCopy;
                self.dataAry[self.currentIndex] = model;
                [self setViewWithIndex:self.currentIndex requestType:RequestTypeInit];
            }
            self.currentIndex = self.scrollIndex;
        }
        [self requestData];
    }
}

- (void)requestData {
    PageDataM *model = self.dataAry[self.currentIndex];
    if (self.dataType == DataTypeNews) {
        if (model.requestType == RequestTypeInit) {
            if (self.refreshBlock) {
                self.refreshBlock(self.ID, model, true, nil);
            }
        }
    } else {
        switch (model.flag) {
            case 0:
            {
                if (model.requestType == RequestTypeInit) {
                    model.requestType = RequestTypeGoingReload;
                    BaseTV *baseTV = [self.viewAry[self.currentIndex] viewWithTag:10003];
                    [baseTV scrollsToTop];
                    if (self.refreshBlock) {
                        self.refreshBlock(self.ID, model, true, nil);
                    }
                }
            }
                break;
            case 1:
            case 2:
            {
                NSString *key = [NSString stringWithFormat:@"Ent%@", @(self.ID).stringValue];
                if (model.flag == 2) {
                    key = [NSString stringWithFormat:@"Bid%@", @(self.ID).stringValue];
                }
                if (model.dataAry.count == 0) {
                    PriceEntBidClassM *listModel = [[PriceEntBidClassM alloc] init];
                    listModel.ID = self.ID;
                    listModel.productid = self.ID;
                    listModel.productid_small = 0;
                    listModel.productSmallName = @"全部";
                    listModel.requestType = RequestTypeInit;
                    listModel.dataAry = @[].mutableCopy;
                    [model.dataAry addObject:listModel];
                    kSetValueForKey(@"0", key);
                }
                NSString *index = kValueForKey(key);
                if (((PriceEntBidClassM *)model.dataAry[index.integerValue]).requestType == RequestTypeInit) {
                    ((PriceEntBidClassM *)model.dataAry[index.integerValue]).requestType = RequestTypeGoingReload;
                    model.requestType = RequestTypeGoingReload;
                    if (self.refreshBlock) {
                        self.refreshBlock(self.ID, model, true, nil);
                    }
                }
            }
                break;
            case 3:
            case 4:
            {
                if (model.requestType == RequestTypeInit) {
                    model.requestType = RequestTypeGoingReload;
                    if (self.refreshBlock) {
                        self.refreshBlock(self.ID, model, true, nil);
                    }
                }
            }
                break;
            default:
                break;
        }
    }
}

- (void)entReolad {
    [self setViewWithModel:self.dataAry[self.currentIndex]];
    [self requestData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UITableView class]]) {
        NSInteger index = scrollView.contentOffset.x / self.frame.size.width;
        if (self.scrollBlock) {
            self.scrollBlock(index);
        }
        if (index < self.dataAry.count) {
            if (self.currentIndex != index) {
                if (self.currentIndex >= 0 && self.currentIndex < self.dataAry.count) {
                    self.dataAry[self.currentIndex].requestType = RequestTypeInit;
                    self.dataAry[self.currentIndex].dataAry = @[].mutableCopy;
                    [self setViewWithIndex:self.currentIndex requestType:RequestTypeInit];
                }
                self.currentIndex = index;
            }
            [self requestData];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger index = [self.viewAry indexOfObject:[tableView superview]];
    if (self.dataType == DataTypeNews) {
        return (self.dataAry[index].requestType == RequestTypeSuccessEmpty) ? 1 : self.dataAry[index].dataAry.count;
    } else {
        if (self.dataAry[index].flag != 1 && self.dataAry[index].flag != 2) {
            return self.dataAry[index].dataAry.count ? self.dataAry[index].dataAry.count : 1;
        }
        NSString *key = [NSString stringWithFormat:@"Ent%@", @(self.ID).stringValue];
        if (self.dataAry[index].flag == 2) {
            key = [NSString stringWithFormat:@"Bid%@", @(self.ID).stringValue];
        }
        NSString *dataIndex = kValueForKey(key);
        if (self.dataAry[index].dataAry.count) {
            PriceEntBidClassM *classM = (PriceEntBidClassM *)self.dataAry[index].dataAry[dataIndex.integerValue];
            return (classM.requestType == RequestTypeSuccessEmpty) ? 1 : classM.dataAry.count;
        } else {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    kWeakSelf
    if (self.dataType == DataTypeNews) {
        if (self.dataAry[[self.viewAry indexOfObject:[tableView superview]]].requestType == RequestTypeSuccessEmpty) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            NoDataV *v = [[[NSBundle mainBundle] loadNibNamed:@"NoDataV" owner:nil options:NULL] lastObject];
            v.viewType = NoDataViewTypeNews;
            v.frame = cell.bounds;
            [cell.contentView addSubview:v];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            if (indexPath.row < self.dataAry[[self.viewAry indexOfObject:[tableView superview]]].dataAry.count) {
                if ([self.dataAry[[self.viewAry indexOfObject:[tableView superview]]].dataAry[indexPath.row] isKindOfClass:[NewsM class]]) {
                    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
                    cell.model = (NewsM *)self.dataAry[[self.viewAry indexOfObject:[tableView superview]]].dataAry[indexPath.row];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }
        }
    } else {
        PageDataM *model = self.dataAry[[self.viewAry indexOfObject:[tableView superview]]];
        switch (model.flag) {
            case 0:
            {
                if (indexPath.row < model.dataAry.count) {
                    BaseM *contentM = model.dataAry[indexPath.row];
                    if ([contentM isKindOfClass:[PriceContentClassM class]]) {
                        StoPriceTitleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoPriceTitleTableCell" forIndexPath:indexPath];
                        cell.model = (PriceContentClassM *)contentM;
                        cell.selectBlock = ^(PriceContentClassM * _Nonnull classM) {
                            NSInteger index = [model.dataAry indexOfObject:classM];
                            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:true];
                            NSMutableArray *ary = @[].mutableCopy;
                            if (classM.subClass.count) {
                                for (PriceContentClassM *subClassM in classM.subClass) {
                                    [ary addObject:subClassM];
                                    if (subClassM.isDetails) {
                                        if (subClassM.dataAry.count == 0) {
                                            PriceStoM *m = [[PriceStoM alloc] init];
                                            m.cellHeight = 40;
                                            m.isRequest = subClassM.requestType == RequestTypeInit;
                                            subClassM.dataAry = @[m].mutableCopy;
                                        }
                                        [ary addObjectsFromArray:subClassM.dataAry];
                                    }
                                }
                            } else {
                                if (classM.dataAry.count == 0) {
                                    PriceStoM *m = [[PriceStoM alloc] init];
                                    m.cellHeight = 40;
                                    m.isRequest = classM.requestType == RequestTypeInit;
                                    if (m.isRequest && weakSelf.refreshBlock) {
                                        weakSelf.refreshBlock(weakSelf.ID, model, false, classM);
                                    }
                                    classM.dataAry = @[m].mutableCopy;
                                }
                                [ary addObjectsFromArray:classM.dataAry];
                            }
                            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index + 1, ary.count)];
                            NSMutableArray *indexAry = @[].mutableCopy;
                            [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                                [indexAry addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
                            }];
                            [UIView setAnimationsEnabled:false];
                            if (classM.isDetails) {
                                [model.dataAry insertObjects:ary atIndexes:indexSet];
                                [tableView insertRowsAtIndexPaths:indexAry withRowAnimation:UITableViewRowAnimationTop];
                            } else {
                                [model.dataAry removeObjectsInArray:ary];
                                [tableView deleteRowsAtIndexPaths:indexAry withRowAnimation:UITableViewRowAnimationTop];
                            }
                            [UIView setAnimationsEnabled:true];
                        };
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
                    } else {
                        StoPriceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoPriceTableCell" forIndexPath:indexPath];
                        PriceStoM *stoM = (PriceStoM *)contentM;
                        if (stoM.ID) {
                            cell.model = (PriceStoM *)contentM;
                            cell.selectBlock = ^(PriceStoM * _Nonnull selectM) {
                                if (selectM) {
                                    PriceDetailsM *detailsM = [[PriceDetailsM alloc] init];
                                    detailsM.pid = selectM.ID;
                                    detailsM.bjjgid = selectM.bjjg.integerValue;
                                    detailsM.name = selectM.detailsNameStr;
                                    detailsM.title = selectM.detailsTitleStr;
                                    detailsM.ID = selectM.jurID;
                                    if (weakSelf.detailsBlock) {
                                        weakSelf.detailsBlock(detailsM);
                                    }
                                }
                            };
                        } else {
                            cell.requestOrNodataIsRequest = stoM.isRequest;
                        }
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
                    }
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
                break;
            case 1:
            case 2:
            {
                NSString *key = [NSString stringWithFormat:@"Ent%@", @(self.ID).stringValue];
                if (model.flag == 2) {
                    key = [NSString stringWithFormat:@"Bid%@", @(self.ID).stringValue];
                }
                NSString *dataIndex = kValueForKey(key);
                if (model.dataAry.count) {
                    PriceEntBidClassM *classM = (PriceEntBidClassM *)model.dataAry[dataIndex.integerValue];
                    if (classM.requestType == RequestTypeSuccessEmpty) {
                        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                        NoDataV *v = [[[NSBundle mainBundle] loadNibNamed:@"NoDataV" owner:nil options:NULL] lastObject];
                        v.viewType = NoDataViewTypePrice;
                        v.frame = cell.bounds;
                        [cell.contentView addSubview:v];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
                    } else {
                        EntBidPriceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntBidPriceTableCell" forIndexPath:indexPath];
                        cell.model = classM.dataAry[indexPath.row];
                        cell.selectBlock = ^{
                            PriceDetailsM *detailsM = [[PriceDetailsM alloc] init];
                            if (weakSelf.detailsBlock) {
                                weakSelf.detailsBlock(detailsM);
                            }
                        };
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
                    }
                } else {
                    return [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                }
            }
                break;
            case 3:
            {
                if (indexPath.row < model.dataAry.count) {
                    BaseM *contentM = model.dataAry[indexPath.row];
                    if ([contentM isKindOfClass:[PriceFOClassM class]]) {
                        FOFPriceTitleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FOFPriceTitleTableCell" forIndexPath:indexPath];
                        cell.model = (PriceFOClassM *)contentM;
                        cell.selectBlock = ^(PriceFOClassM * _Nonnull classM) {
                            NSInteger index = [model.dataAry indexOfObject:classM];
                            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:true];
                            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index + 1, classM.dataAry.count)];
                            NSMutableArray *indexAry = @[].mutableCopy;
                            [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                                [indexAry addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
                            }];
                            [UIView setAnimationsEnabled:false];
                            if (classM.isDetails) {
                                [model.dataAry insertObjects:classM.dataAry atIndexes:indexSet];
                                [tableView insertRowsAtIndexPaths:indexAry withRowAnimation:UITableViewRowAnimationTop];
                            } else {
                                [model.dataAry removeObjectsInArray:classM.dataAry];
                                [tableView deleteRowsAtIndexPaths:indexAry withRowAnimation:UITableViewRowAnimationTop];
                            }
                            [UIView setAnimationsEnabled:true];
                        };
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
                    } else {
                        FOFPriceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FOFPriceTableCell" forIndexPath:indexPath];
                        cell.model = (PriceFOM *)contentM;
                        cell.selectBlock = ^(PriceFOM * _Nonnull selectM) {
                            if (selectM) {
                                PriceDetailsM *detailsM = [[PriceDetailsM alloc] init];
                                detailsM.pid = selectM.ID;
                                detailsM.bjjgid = selectM.bjjgid;
                                detailsM.name = selectM.detailsNameStr;
                                detailsM.title = selectM.detailsTitleStr;
                                detailsM.ID = selectM.jurID;
                                if (weakSelf.detailsBlock) {
                                    weakSelf.detailsBlock(detailsM);
                                }
                            }
                        };
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
                    }
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
                break;
            case 4:
            {
                if (indexPath.row < model.dataAry.count) {
                    BaseM *contentM = model.dataAry[indexPath.row];
                    if ([contentM isKindOfClass:[PriceFOClassM class]]) {
                        FOOPriceTitleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FOOPriceTitleTableCell" forIndexPath:indexPath];
                        cell.model = (PriceFOClassM *)contentM;
                        cell.selectBlock = ^(PriceFOClassM * _Nonnull classM) {
                            NSInteger index = [model.dataAry indexOfObject:classM];
                            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:true];
                            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index + 1, classM.dataAry.count)];
                            NSMutableArray *indexAry = @[].mutableCopy;
                            [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                                [indexAry addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
                            }];
                            [UIView setAnimationsEnabled:false];
                            if (classM.isDetails) {
                                [model.dataAry insertObjects:classM.dataAry atIndexes:indexSet];
                                [tableView insertRowsAtIndexPaths:indexAry withRowAnimation:UITableViewRowAnimationTop];
                            } else {
                                [model.dataAry removeObjectsInArray:classM.dataAry];
                                [tableView deleteRowsAtIndexPaths:indexAry withRowAnimation:UITableViewRowAnimationTop];
                            }
                            [UIView setAnimationsEnabled:true];
                        };
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
                    } else {
                        FOOPriceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FOOPriceTableCell" forIndexPath:indexPath];
                        cell.model = (PriceFOM *)contentM;
                        cell.selectBlock = ^(PriceFOM * _Nonnull selectM) {
                            if (selectM) {
                                PriceDetailsM *detailsM = [[PriceDetailsM alloc] init];
                                detailsM.pid = selectM.ID;
                                detailsM.bjjgid = selectM.bjjgid;
                                detailsM.name = selectM.detailsNameStr;
                                detailsM.title = selectM.detailsTitleStr;
                                detailsM.ID = selectM.jurID;
                                if (weakSelf.detailsBlock) {
                                    weakSelf.detailsBlock(detailsM);
                                }
                            }
                        };
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
                    }
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
                break;
            default:
                return nil;
                break;
        }
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataType == DataTypePrice) {
        PageDataM *model = self.dataAry[[self.viewAry indexOfObject:[tableView superview]]];
        switch (model.flag) {
            case 0:
            {
                if (indexPath.row < model.dataAry.count) {
                    BaseM *contentM = model.dataAry[indexPath.row];
                    if ([contentM isKindOfClass:[PriceContentClassM class]]) {
                        return 40;
                    } else {
                        PriceStoM *stoM = (PriceStoM *)contentM;
                        if (stoM.ID) {
                            return stoM.cellHeight;
                        } else {
                            return 40;
                        }
                    }
                } else {
                    return kScreenH - kTopVH - kBottomVH - 128;
                }
            }
                break;
            case 1:
            case 2:
            {
                NSString *key = [NSString stringWithFormat:@"Ent%@", @(self.ID).stringValue];
                if (model.flag == 2) {
                    key = [NSString stringWithFormat:@"Bid%@", @(self.ID).stringValue];
                }
                NSString *dataIndex = kValueForKey(key);
                if (model.dataAry.count) {
                    PriceEntBidClassM *classM = (PriceEntBidClassM *)model.dataAry[dataIndex.integerValue];
                    if (classM.requestType == RequestTypeSuccessEmpty) {
                        return kScreenH - kTopVH - kBottomVH - 128;
                    } else {
                        return classM.dataAry[indexPath.row].cellHeight;
                    }
                } else {
                    return 1;
                }
            }
                break;
            case 3:
            case 4:
            {
                if (indexPath.row < model.dataAry.count) {
                    BaseM *contentM = model.dataAry[indexPath.row];
                    if ([contentM isKindOfClass:[PriceFOClassM class]]) {
                        return 40;
                    } else {
                        PriceFOM *foM = (PriceFOM *)contentM;
                        return foM.cellHeight;
                    }
                } else {
                    return kScreenH - kTopVH - kBottomVH - 128;
                }
            }
                break;
            default:
                break;
        }
    } else if (self.dataType == DataTypeNews) {
        if (self.dataAry[[self.viewAry indexOfObject:[tableView superview]]].requestType == RequestTypeSuccessEmpty) {
            return kScreenH - kTopVH - kBottomVH - 88;
        } else {
//            return [Tool heightForString:((NewsM *)self.dataAry[[self.viewAry indexOfObject:[tableView superview]]].dataAry[indexPath.row]).title width:kScreenW - 32 font:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]] + 45;
            return 80;
        }
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:false animated:true];
    if (self.dataType == DataTypeNews) {
        if (self.newsSelectBlock && self.dataAry[[self.viewAry indexOfObject:[tableView superview]]].requestType != RequestTypeSuccessEmpty) {
            self.newsSelectBlock((NewsM *)self.dataAry[[self.viewAry indexOfObject:[tableView superview]]].dataAry[indexPath.row], self.dataAry[[self.viewAry indexOfObject:[tableView superview]]].flag == 2);
        }
    }
}

@end
