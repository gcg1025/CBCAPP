//
//  AnalyseVC.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/29.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "AnalyseVC.h"
#import "AnalyseTitleCollectionCell.h"
#import "NewsCell.h"
#import "NewsDetailsVC.h"
#import "NewsClassV.h"


@interface AnalyseVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray<NewsM *> *dataAry;
@property (nonatomic, assign) BOOL isReload;
@property (nonatomic, strong) NewsClassV *newsClassV;
@property (nonatomic, assign) NSInteger newsClassID;
@property (nonatomic, strong) NSArray<NewsClassM *> *newsClassAry;
@property (nonatomic, strong) NSMutableDictionary *newsClassDataDic;

@property (nonatomic, strong) BaseCV *newsTitleCV;
@property (weak, nonatomic) IBOutlet UIView *newsTitleCVBackgroundV;
@property (weak, nonatomic) IBOutlet UIView *backgroundV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation AnalyseVC

- (NewsClassV *)newsClassV {
    if (!_newsClassV) {
        _newsClassV = [[NSBundle mainBundle] loadNibNamed:@"NewsClassV" owner:nil options:nil].lastObject;
        _newsClassV.frame = self.view.bounds;
        _newsClassV.alpha = 0;
        _newsClassV.type = NewsClassTypeAnalyse;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *selectAry = [Tool newsClassAnalyseIDAry];
    if (selectAry.count) {
        [self requestData];
    } else {
        [self performSelector:@selector(requestData) withObject:nil afterDelay:0.01];
    }
}

- (void)setViews {
    [self setNavigationBarWithTitle:@"市场分析" hasBackBtn:true];
    NSString *version= [UIDevice currentDevice].systemVersion;
    if (version.doubleValue < 11) {
        self.topCon.constant = 64;
        [self.view layoutIfNeeded];
    }
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
    [self.newsTitleCV registerNib:[UINib nibWithNibName:@"AnalyseTitleCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"AnalyseTitleCollectionCell"];

    self.baseTV.frame = CGRectMake(0, 0, kScreenW, kScreenH - kTopVH - kBottomH - 44);
    [self.baseTV registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:@"NewsCell"];
    kWeakSelf
    self.baseTV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isReload = true;
        [weakSelf requestNewsData];
    }];
    self.baseTV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isReload = false;
        [weakSelf requestNewsData];
    }];
    [self.baseTV registerNib:[UINib nibWithNibName:@"SupplyPurchaseTableCell" bundle:nil] forCellReuseIdentifier:@"SupplyPurchaseTableCell"];
    [self.backgroundV addSubview:self.baseTV];
    self.requestV.frame = self.backgroundV.bounds;
    [self.backgroundV addSubview:self.requestV];
    self.errorV.frame = self.backgroundV.bounds;
    [self.backgroundV addSubview:self.errorV];
}

- (void)reloadData {
    self.baseTV.contentOffset = CGPointMake(0, 0);
    self.isReload = true;
    self.baseTV.alpha = 0;
    self.errorV.alpha = 0;
    self.requestV.alpha = 1;
    kWeakSelf
    self.baseTV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isReload = false;
        [weakSelf requestNewsData];
    }];
    [self requestNewsData];
}

- (void)requestNewsData {
    kWeakSelf
    NSInteger newsClassID = self.newsClassID;
    [Tool POST:NEWS params:@[@{@"count":self.isReload ? @"20" : @"10"}, @{@"productid":self.newsClassID ? @(self.newsClassID).stringValue : @""}, @{@"typeid":@"-2"}, @{@"minid":self.isReload ? @"0" : self.dataAry.lastObject.aid}, @{@"maxid":@"0"}, @{@"keyname":@"newslist"}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSDictionary * _Nonnull result) {
        if (newsClassID == weakSelf.newsClassID) {
            NSArray *ary = [NewsM mj_objectArrayWithKeyValuesArray:result[@"newslist"]];
            if (weakSelf.isReload) {
                weakSelf.dataAry = @[].mutableCopy;
            }
            [weakSelf.baseTV.mj_header endRefreshing];
            [weakSelf.baseTV.mj_footer endRefreshing];
            if (ary.count < (weakSelf.isReload ?  20 : 10)) {
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
        if (newsClassID == weakSelf.newsClassID) {
            weakSelf.requestV.alpha = 0;
            weakSelf.errorV.alpha = 1;
            weakSelf.baseTV.alpha = 0;
        }
    }];
}

- (void)resetNewsClassViews {
    CGFloat wid = 0;
    for (NewsClassM *model in self.newsClassAry) {
        wid += ([Tool widthForString:model.name font:[UIFont systemFontOfSize:14]] + 40);
    }
    self.newsTitleCV.frame = CGRectMake(0, 0, wid > kScreenW - 44 ? kScreenW - 44 : wid, 44);
    [self.newsTitleCV reloadData];
}

- (void)requestData {
    NSArray *selectAry = [Tool newsClassAnalyseIDAry];
    if (selectAry.count == 0) {
        self.isFirst = true;
        kSetValueForKey(@"10114,14086,13923,10198,13955,10477,42344", kNewsClassAnalyse);
        selectAry = [Tool newsClassAnalyseIDAry];
    }
    NSMutableArray<NewsClassM *> *dataAry = [NewsClassM mj_objectArrayWithKeyValuesArray:[Tool metalAry]];
    for (NewsClassM *model in dataAry) {
        model.subClass = [NewsClassM mj_objectArrayWithKeyValuesArray:model.subClass];
        for (NewsClassM *subModel in model.subClass) {
            if ([self.newsClassDataDic.allKeys containsObject:@(subModel.ID).stringValue]) {
                subModel.dataAry = self.newsClassDataDic[@(subModel.ID).stringValue];
            } else {
                NSMutableArray *ary = @[].mutableCopy;
                subModel.dataAry = ary;
                [self.newsClassDataDic addEntriesFromDictionary:@{@(subModel.ID).stringValue:ary}];
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
//    if (![selectAry containsObject:@(self.newsClassID).stringValue]) {
//        if (ary.count == 0) {
//            NewsClassM *subModel = dataAry[0].subClass[0];
//            self.newsClassID = subModel.ID;
//            subModel.isSelect = true;
//            [ary addObject:subModel];
//        } else {
//            self.newsClassID = ary[0].ID;
//        }
        
//    }
    titleModel.subClass = ary.copy;
    [dataAry insertObject:titleModel atIndex:0];
    NSMutableArray *newsClassAry = ary.mutableCopy;
    NewsClassM *classM = [[NewsClassM alloc] init];
    classM.ID = 0;
    classM.name = @"全部";
    [newsClassAry insertObject:classM atIndex:0];
    self.newsClassAry = newsClassAry.copy;
    
//    for (NewsClassM *model in self.newsClassAry) {
//        if (self.newsClassID == model.ID) {
//            [self selectNewsClassAct:[self.newsClassAry indexOfObject:model]];
//            break;
//        }
//    }
    
    self.newsClassID = 0;
    [self reloadData];

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataAry.count) {
        NewsM *model = self.dataAry[indexPath.row];
        if (model.aid.integerValue == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            NoDataV *v = [[[NSBundle mainBundle] loadNibNamed:@"NoDataV" owner:nil options:NULL] lastObject];
            v.viewType = NoDataViewTypeNews;
            v.frame = cell.bounds;
            [cell.contentView addSubview:v];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
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
        if (self.dataAry[0].aid.integerValue == 0) {
            return kScreenH - kTopVH - 44 - kBottomH;
        } else {
            return 80;
        }
    } else {
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataAry.count) {
        if (self.dataAry[0].aid.integerValue != 0) {
            NewsDetailsVC *vc = [[NewsDetailsVC alloc] init];
            vc.type = NewsTypeAnalyse;
            vc.model = self.dataAry[indexPath.row];
            [self.navigationController pushViewController:vc animated:true];
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.newsClassAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AnalyseTitleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AnalyseTitleCollectionCell" forIndexPath:indexPath];
    cell.isCurrentClass = self.newsClassID == self.newsClassAry[indexPath.row].ID;
    cell.model = self.newsClassAry[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.newsClassID != self.newsClassAry[indexPath.row].ID) {
        self.newsClassID = self.newsClassAry[indexPath.row].ID;
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:true];
        [self.newsTitleCV reloadData];
        [self reloadData];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([Tool widthForString:self.newsClassAry[indexPath.row].name font:[UIFont systemFontOfSize:18]] + 40, 44);
}

@end
