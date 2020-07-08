//
//  PriceClassContentV.m
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/26.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import "PriceClassContentV.h"
#import "PriceClassCollectionCell.h"

@interface PriceClassContentV()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) BaseCV *baseCV;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, assign) BOOL isAllSelect;

@end

@implementation PriceClassContentV

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *titleV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 47)];
        titleV.backgroundColor = [UIColor whiteColor];
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, kScreenW / 2, 20)];
        self.titleLab.textColor = [UIColor blackColor];
        self.titleLab.font = [UIFont systemFontOfSize:14 weight:bold];
        [titleV addSubview:self.titleLab];
        self.titleLab.center = CGPointMake(self.titleLab.center.x, 23.5);
        self.allBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW - 86, 11, 70, 25)];
        self.allBtn.backgroundColor = kHexColor(kTintColorHex, 1);
        self.allBtn.layer.cornerRadius = 5;
        self.allBtn.layer.masksToBounds = true;
        self.allBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
        [self.allBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.allBtn addTarget:self action:@selector(allAct:) forControlEvents:UIControlEventTouchUpInside];
        [titleV addSubview:self.allBtn];
        [self addSubview:titleV];
        
        UIView *cvBackgroundV = [[UIView alloc] initWithFrame:CGRectMake(0, 47, kScreenW, 20)];
        cvBackgroundV.backgroundColor = [UIColor whiteColor];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize  = CGSizeMake((kScreenW - 22) / 4, 56);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        self.baseCV = [[BaseCV alloc] initWithFrame:CGRectMake(11, 0, kScreenW - 22, 20) collectionViewLayout:layout];
        self.baseCV.backgroundColor = [UIColor whiteColor];
        self.baseCV.delegate = self;
        self.baseCV.dataSource = self;
        [self.baseCV registerNib:[UINib nibWithNibName:@"PriceClassCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"PriceClassCollectionCell"];
        [cvBackgroundV addSubview:self.baseCV];
        [self addSubview:cvBackgroundV];
    }
    return self;
}

- (void)layoutSubviews {
    self.baseCV.frame = CGRectMake(11, 0, kScreenW - 22, self.frame.size.height - 47);
    self.baseCV.superview.frame = CGRectMake(0, 47, kScreenW, self.frame.size.height - 47);
}

- (void)setModel:(PriceClassM *)model {
    _model = model;
    self.titleLab.text = model.name;
    [self checkAllSelect];
    [self.baseCV reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.subClass.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PriceClassCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PriceClassCollectionCell" forIndexPath:indexPath];
    cell.model = self.model.subClass[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenW - 22) / 4, 56);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectBlock && !self.model.subClass[indexPath.row].isSelect) {
        self.model.subClass[indexPath.row].isSelect = true;
        self.selectBlock(self.model.subClass[indexPath.row]);
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        [self checkAllSelect];
    }
}

- (void)checkAllSelect {
    self.isAllSelect = true;
    for (PriceClassM *model in self.model.subClass) {
        if (!model.isSelect) {
            self.isAllSelect = false;
            break;
        }
    }
    [self.allBtn setTitle:self.isAllSelect ? @"取消全选" : @"全选" forState:UIControlStateNormal];
}

- (void)allAct:(id)sender {
    if (self.allBlock) {
        if (self.isAllSelect) {
            NSMutableArray *ary = self.selectModel.subClass.mutableCopy;
            for (NSInteger i = self.selectModel.subClass.count - 1; i >= 0; i --) {
                PriceClassM *model = self.selectModel.subClass[i];
                if (ary.count > 1) {
                   if ([self.model.subClass containsObject:model]) {
                       model.isSelect = false;
                       [ary removeObject:model];
                    }
                }
            }
        } else {
            for (PriceClassM *model in self.model.subClass) {
                model.isSelect = true;
            }
        }
        [self checkAllSelect];
        [self.baseCV reloadData];
        self.allBlock(self.model, self.isAllSelect);
    }
}

- (void)reloadItemsAtIndex:(NSInteger)index {
    [self.baseCV reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    [self checkAllSelect];
}

@end
