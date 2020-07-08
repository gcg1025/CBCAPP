//
//  NewsClassTitleV.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/29.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "NewsClassTitleV.h"
#import "NewsClassCollectionCell.h"

@interface NewsClassTitleV () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) BaseCV *baseCV;
@property (nonatomic, strong) UIView *confirmBackgroundV;

@end

@implementation NewsClassTitleV

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UIView *cornerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreenW, 20)];
        cornerView.backgroundColor = [UIColor whiteColor];
        cornerView.layer.cornerRadius = 10;
        cornerView.layer.masksToBounds = true;
        [self addSubview:cornerView];
        
        UIView *titleV = [[UIView alloc] initWithFrame:CGRectMake(0, 54, kScreenW, 47)];
        titleV.backgroundColor = [UIColor whiteColor];
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, kScreenW / 2, 20)];
        self.titleLab.textColor = [UIColor blackColor];
        self.titleLab.font = [UIFont systemFontOfSize:14 weight:bold];
        [titleV addSubview:self.titleLab];
        self.titleLab.center = CGPointMake(self.titleLab.center.x, 23.5);
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW - 57, 10, 57, 37)];
        closeBtn.contentEdgeInsets = UIEdgeInsetsMake(13, 23, 13, 23);
        [closeBtn setImage:kImage(@"price_class_close") forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeAct:) forControlEvents:UIControlEventTouchUpInside];
        [titleV addSubview:closeBtn];
        [self addSubview:titleV];
        
        UIView *cvBackgroundV = [[UIView alloc] initWithFrame:CGRectMake(0, 101, kScreenW, 20)];
        cvBackgroundV.backgroundColor = [UIColor whiteColor];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize  = CGSizeMake((kScreenW - 22) / 4, 56);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        self.baseCV = [[BaseCV alloc] initWithFrame:CGRectMake(11, 0, kScreenW - 22, 20) collectionViewLayout:layout];
        self.baseCV.backgroundColor = [UIColor whiteColor];
        self.baseCV.delegate = self;
        self.baseCV.dataSource = self;
        [self.baseCV registerNib:[UINib nibWithNibName:@"NewsClassCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"NewsClassCollectionCell"];
        [cvBackgroundV addSubview:self.baseCV];
        [self addSubview:cvBackgroundV];
        
        self.confirmBackgroundV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 67)];
        self.confirmBackgroundV.backgroundColor = [UIColor whiteColor];
        UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 80, 36)];
        confirmBtn.backgroundColor = kHexColor(kNavBackgroundColorHex, 1);
        confirmBtn.layer.cornerRadius = 5;
        confirmBtn.layer.masksToBounds = true;
        [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmAct:) forControlEvents:UIControlEventTouchUpInside];
        [self.confirmBackgroundV addSubview:confirmBtn];
        confirmBtn.center = CGPointMake(kScreenW / 2, 28);
        [self addSubview:self.confirmBackgroundV];
    }
    return self;
}

- (void)layoutSubviews {
    self.baseCV.frame = CGRectMake(11, 0, kScreenW - 22, self.frame.size.height - 164);
    self.baseCV.superview.frame = CGRectMake(0, 101, kScreenW, self.frame.size.height - 164);
    self.confirmBackgroundV.frame = CGRectMake(0, self.frame.size.height - 67, kScreenW, 67);
}

- (void)setModel:(NewsClassM *)model {
    _model = model;
    self.titleLab.text = model.name;
    [self.baseCV reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.subClass.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewsClassCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewsClassCollectionCell" forIndexPath:indexPath];
    cell.isTitle = true;
    cell.model = self.model.subClass[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.model.subClass.count == 1) {
        [Tool showStatusDark:@"至少选择一个分类"];
        return;
    }
    if (self.deleteBlock) {
        NewsClassM *model =  self.model.subClass[indexPath.row];
        model.isSelect = false;
        NSMutableArray *dataAry = self.model.subClass.mutableCopy;
        [dataAry removeObjectAtIndex:indexPath.row];
        self.model.subClass = dataAry.copy;
        [self.baseCV deleteItemsAtIndexPaths:@[indexPath]];
        self.deleteBlock(model);
    }
}

- (void)closeAct:(id)sender {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)confirmAct:(id)sender {
    if (self.confirmBlock) {
        if (self.type == NewsClassTypeNormal) {
            [Tool setNewsClassIDAry:self.model.subClass.copy];
        } else if (self.type == NewsClassTypeAnalyse) {
            [Tool setNewsClassAnalyseIDAry:self.model.subClass.copy];
        }
        
        self.confirmBlock();
    }
}


- (void)insertWithIndexPaths:(NSMutableArray<NSIndexPath *> *)indexPaths {
    [self.baseCV insertItemsAtIndexPaths:indexPaths];
}

- (void)deleteWithIndexPaths:(NSMutableArray<NSIndexPath *> *)indexPaths {
    [self.baseCV deleteItemsAtIndexPaths:indexPaths];
}

@end
