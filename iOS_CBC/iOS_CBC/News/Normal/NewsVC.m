//
//  NewsVC.m
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/30.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import "NewsVC.h"
#import "NewsTitleCollectionCell.h"
#import "NewsTypeCollectionCell.h"
#import "NewsClassVC.h"
#import "NewsDetailsVC.h"
#import "NewsClassV.h"

@interface NewsVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray<NewsClassM *> *dataAry;

@property (weak, nonatomic) IBOutlet UIView *newsTitleCVBackgroundV;
@property (nonatomic, strong) BaseCV *newsTitleCV;
@property (nonatomic, strong) NewsClassV *newsClassV;
@property (nonatomic, assign) NSInteger newsClassID;
@property (nonatomic, strong) NSArray<NewsClassM *> *newsClassAry;

@property (weak, nonatomic) IBOutlet UICollectionView *newsTypeCV;
@property (nonatomic, strong) NSArray<PageTitleM *> *newsTypeAry;
@property (nonatomic, strong) NSMutableDictionary *newsTypeDataDic;
@property (nonatomic, assign) NSInteger newsTypeIndex;

@property (weak, nonatomic) IBOutlet UIView *pageBackgroundV;

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation NewsVC

- (NSArray<NewsClassM *> *)dataAry {
    if (!_dataAry) {
        _dataAry = @[];
    }
    return _dataAry;
}

- (NSMutableDictionary *)newsTypeDataDic {
    if (!_newsTypeDataDic) {
        _newsTypeDataDic = @{}.mutableCopy;
    }
    return _newsTypeDataDic;
}

- (NewsClassV *)newsClassV {
    if (!_newsClassV) {
        _newsClassV = [[NSBundle mainBundle] loadNibNamed:@"NewsClassV" owner:nil options:nil].lastObject;
        _newsClassV.frame = self.view.bounds;
        _newsClassV.alpha = 0;
        _newsClassV.type = NewsClassTypeNormal;
        kWeakSelf
        _newsClassV.closeBlock = ^{
            [weakSelf requestData];
        };
        _newsClassV.confirmBlock = ^{
            [weakSelf requestData];
        };
    }
    return _newsClassV;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.shouleRefresh) {
        self.shouleRefresh = false;
        self.newsTypeDataDic = @{}.mutableCopy;
        [self requestData];
    }
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

- (void)updateData {
    [super updateData];
    if ([Tool shareInstance].currentViewController == self) {
        if (self.shouleRefresh) {
            self.shouleRefresh = false;
            self.newsTypeDataDic = @{}.mutableCopy;
            [self requestData];
        }
    }
}

- (void)setViews {
    [self.view addSubview:self.newsClassV];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.newsTitleCV = [[BaseCV alloc] initWithFrame:CGRectMake(0, 0, 100, 44) collectionViewLayout:layout];
    self.newsTitleCV.backgroundColor = [UIColor clearColor];
    [self.newsTitleCVBackgroundV addSubview:self.newsTitleCV];
    self.newsTitleCV.delegate = self;
    self.newsTitleCV.dataSource = self;
    [self.newsTitleCV registerNib:[UINib nibWithNibName:@"NewsTitleCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"NewsTitleCollectionCell"];
    
    self.newsTypeAry = [PageTitleM mj_objectArrayWithKeyValuesArray:@[@{@"name":@"全部新闻", @"index":@(0), @"type":@"0"}, @{@"name":@"行业新闻", @"index":@(1), @"type":@"1"}, @{@"name":@"企业新闻", @"index":@(2), @"type":@"2"}, @{@"name":@"招标公告", @"index":@(3), @"type":@"5"}, @{@"name":@"政策解读", @"index":@(4), @"type":@"4"}/*, @{@"name":@"市场分析", @"index":@(5), @"type":@"-2"}*/]];
//    self.newsTypeAry = [PageTitleM mj_objectArrayWithKeyValuesArray:@[@{@"name":@"市场分析", @"index":@(5), @"type":@"-2"}]];
    self.newsTypeCV.delegate = self;
    self.newsTypeCV.dataSource = self;
    [self.newsTypeCV registerNib:[UINib nibWithNibName:@"NewsTypeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"NewsTypeCollectionCell"];
    self.basePageV.dataType = DataTypeNews;
    self.basePageV.frame = CGRectMake(0, 0, kScreenW, kScreenH - kTopVH - kBottomVH - 88);
    kWeakSelf
    self.basePageV.scrollBlock = ^(NSInteger index) {
        if (weakSelf.newsTypeIndex != index) {
            weakSelf.newsTypeIndex = index;
            [weakSelf.newsTypeCV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:true];
            [weakSelf.newsTypeCV reloadData];
        }
    };
    self.basePageV.refreshBlock = ^(NSInteger ID, PageDataM * _Nonnull model, BOOL isReload, PriceContentClassM * _Nullable classM) {
        if (isReload) {
            model.dataAry = @[].mutableCopy;
        }
        NSString *minid = @"0";
        if (model.requestType == RequestTypeGoingRequest) {
            NewsM *newsM = (NewsM *)model.dataAry.lastObject;
            minid = newsM.aid;
        }
        [Tool POST:NEWS params:@[@{@"count":isReload ? @"20" : @"10"}, @{@"productid":@(ID).stringValue}, @{@"typeid":weakSelf.newsTypeAry[weakSelf.newsTypeIndex].type}, @{@"minid":minid}, @{@"maxid":@"0"}, @{@"keyname":@"newslist"}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull progress) {
            
        } success:^(NSDictionary * _Nonnull result) {
            NSArray *ary = [NewsM mj_objectArrayWithKeyValuesArray:result[@"newslist"]];
            if (ary.count) {
                [model.dataAry addObjectsFromArray:ary];
            }
            model.requestType = ary.count ? (ary.count < (isReload ? 20 : 10) ? RequestTypeSuccessNomoreData : RequestTypeSuccessNormal) : RequestTypeSuccessEmpty;
            if (ID == weakSelf.newsClassID) {
                [weakSelf.basePageV setViewWithModel:model];
            }
        } failure:^(NSString * _Nonnull error) {
            model.requestType = model.dataAry.count ? RequestTypeSuccessNormal : RequestTypeError;
            if (ID == weakSelf.newsClassID) {
                [weakSelf.basePageV setViewWithModel:model];
            }
        }];
    };
    self.basePageV.newsSelectBlock = ^(NewsM * _Nonnull model, BOOL isBid) {
        NewsDetailsVC *vc = [[NewsDetailsVC alloc] init];
        vc.type = isBid ? NewsTypeBid : NewsTypeNormal;
        vc.model = model;
        [weakSelf.navigationController pushViewController:vc animated:true];
    };
    [self.pageBackgroundV addSubview:self.basePageV];
}

- (void)resetNewsClassViews {
    CGFloat wid = 0;
    for (NewsClassM *model in self.newsClassAry) {
        wid += ([Tool widthForString:model.name font:[UIFont systemFontOfSize:18]] + 40);
    }
    self.newsTitleCV.frame = CGRectMake(0, 0, wid > kScreenW - 44 ? kScreenW - 44 : wid, 44);
    [self.newsTitleCV reloadData];
}

- (void)requestData {
    NSArray *selectAry = [Tool newsClassIDAry];
    if (selectAry.count == 0) {
        self.isFirst = true;
        kSetValueForKey(@"10114,14086,13923,10198,13955,10477,42344", kNewsClass);
        selectAry = [Tool newsClassIDAry];
    }
    NSMutableArray<NewsClassM *> *dataAry = [NewsClassM mj_objectArrayWithKeyValuesArray:[Tool metalAry]];
    for (NewsClassM *model in dataAry) {
        model.subClass = [NewsClassM mj_objectArrayWithKeyValuesArray:model.subClass];
        for (NewsClassM *subModel in model.subClass) {
            if ([self.newsTypeDataDic.allKeys containsObject:@(subModel.ID).stringValue]) {
                subModel.dataAry = self.newsTypeDataDic[@(subModel.ID).stringValue];
            } else {
                NSMutableArray *ary = @[].mutableCopy;
                for (NSInteger i = 0; i < self.newsTypeAry.count; i++) {
                    PageDataM *dataModel = [[PageDataM alloc] init];
                    dataModel.flag = self.newsTypeAry[i].index;
                    dataModel.dataAry = @[].mutableCopy;
                    [ary addObject:dataModel];
                }
                subModel.dataAry = ary;
                [self.newsTypeDataDic addEntriesFromDictionary:@{@(subModel.ID).stringValue:ary}];
            }
        }
    }
//    if (!self.dataAry.count) {
//        NSArray *ary = [Tool metalAry];
//        NSMutableArray *mutAry = @[].mutableCopy;
//        for (NSDictionary *dic in ary) {
//            [mutAry addObjectsFromArray:dic[@"subClass"]];
//        }
//        self.dataAry = [NewsClassM mj_objectArrayWithKeyValuesArray:mutAry];
//    }
//    for (NewsClassM *model in self.dataAry) {
//        if ([self.newsTypeDataDic.allKeys containsObject:@(model.ID).stringValue]) {
//            model.dataAry = self.newsTypeDataDic[@(model.ID).stringValue];
//        } else {
//            NSMutableArray *ary = @[].mutableCopy;
//            for (NSInteger i = 0; i < self.newsTypeAry.count; i++) {
//                PageDataM *dataModel = [[PageDataM alloc] init];
//                dataModel.dataAry = @[].mutableCopy;
//                [ary addObject:dataModel];
//            }
//            model.dataAry = ary;
//            [self.newsTypeDataDic addEntriesFromDictionary:@{@(model.ID).stringValue:ary}];
//        }
//    }
    NewsClassM *titleModel = [[NewsClassM alloc] init];
    titleModel.name = @"我的定制金属";
    NSMutableArray<NewsClassM *> *ary = @[].mutableCopy;
    for (NSString *ID in selectAry) {
         for (NewsClassM *model in dataAry) {
             for (NewsClassM *subModel in model.subClass) {
                 if (subModel.ID == ID.integerValue) {
                     subModel.isSelect = true;
                     [ary addObject:subModel];
                 }
             }
         }
    }
//    NSMutableArray<NewsClassM *> *ary = @[].mutableCopy;
//    for (NSString *ID in selectAry) {
//         for (NewsClassM *model in self.dataAry) {
//             if (model.ID == ID.integerValue) {
//                 model.isSelect = true;
//                 [ary addObject:model];
//             }
//         }
//    }
    if (![selectAry containsObject:@(self.newsClassID).stringValue]) {
        if (ary.count == 0) {
            NewsClassM *subModel = dataAry[0].subClass[0];
            self.newsClassID = subModel.ID;
            subModel.isSelect = true;
            [ary addObject:subModel];
        } else {
            self.newsClassID = ary[0].ID;
        }
    }
    titleModel.subClass = ary.copy;
    [dataAry insertObject:titleModel atIndex:0];
    self.newsClassAry = titleModel.subClass;
    
    for (NewsClassM *model in self.newsClassAry) {
        if (self.newsClassID == model.ID) {
            [self selectNewsClassAct:[self.newsClassAry indexOfObject:model]];
            break;
        }
    }

    self.newsClassV.dataAry = dataAry.copy;
    if (self.isFirst) {
        self.isFirst = false;
        [self.newsClassV showView];
    }
    [self resetNewsClassViews];
    
//    NSMutableArray *sortAry = [Tool newsClassSortAry].mutableCopy;
//    for (NewsClassM *model in self.dataAry) {
//        if (![sortAry containsObject:@(model.ID).stringValue]) {
//            [sortAry addObject:@(model.ID).stringValue];
//        }
//    }
//    [Tool setNewsClassSortAry:sortAry.copy];
}

- (IBAction)selectClassAct:(id)sender {
    [self.newsClassV showView];
//    NewsClassVC *vc = [[NewsClassVC alloc] initWithNibName:@"NewsClassVC" bundle:nil];
//    vc.modalPresentationStyle = UIModalPresentationFullScreen;
//    vc.dataAry = self.dataAry;
//    kWeakSelf
//    vc.changeBlock = ^{
//        [weakSelf requestData];
//    };
//    [self presentViewController:vc animated:true completion:nil];
}

- (void)selectNewsClassAct:(NSInteger)index {
    if (self.basePageV.dataAry) {
        if (![self.basePageV.dataAry isEqual:self.newsClassAry[index].dataAry]) {
            self.basePageV.dataAry = self.newsClassAry[index].dataAry.mutableCopy;
            self.basePageV.ID = self.newsClassAry[index].ID;
            [self selectNewsTypeAct];
        }
    } else {
        self.basePageV.dataAry = self.newsClassAry[index].dataAry.mutableCopy;
        self.basePageV.ID = self.newsClassAry[index].ID;
        [self selectNewsTypeAct];
    }
}

- (void)selectNewsTypeAct {
    [self.newsTypeCV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.newsTypeIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:true];
    [self.basePageV scrollToIndex:self.newsTypeIndex];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.newsTitleCV) {
        return self.newsClassAry.count;
    } else if (collectionView == self.newsTypeCV) {
        return self.newsTypeAry.count;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.newsTitleCV) {
        NewsTitleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewsTitleCollectionCell" forIndexPath:indexPath];
        cell.isCurrentClass = self.newsClassID == self.newsClassAry[indexPath.row].ID;
        cell.model = self.newsClassAry[indexPath.row];
        return cell;
    } else if (collectionView == self.newsTypeCV) {
        NewsTypeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewsTypeCollectionCell" forIndexPath:indexPath];
        cell.model = self.newsTypeAry[indexPath.row];
        cell.isCurrentType = self.newsTypeIndex ==
        self.newsTypeAry[indexPath.row].index;
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.newsTitleCV) {
        if (self.newsClassID != self.newsClassAry[indexPath.row].ID) {
            self.newsClassID = self.newsClassAry[indexPath.row].ID;
            [self selectNewsClassAct:indexPath.row];
            [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:true];
            [self.newsTitleCV reloadData];
        }
    } else if (collectionView == self.newsTypeCV) {
        if (self.newsTypeIndex != self.newsTypeAry[indexPath.row].index) {
            self.newsTypeIndex = self.newsTypeAry[indexPath.row].index;
            [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:true];
            [self selectNewsTypeAct];
            [self.newsTypeCV reloadData];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.newsTitleCV) {
        return CGSizeMake([Tool widthForString:self.newsClassAry[indexPath.row].name font:[UIFont systemFontOfSize:18]] + 40, 44);
    } else if (collectionView == self.newsTypeCV) {
        return CGSizeMake([Tool widthForString:self.newsTypeAry[indexPath.row].name font:[UIFont systemFontOfSize:16]] + 30, 44);
    }
    return CGSizeMake(1, 1);
}

@end
