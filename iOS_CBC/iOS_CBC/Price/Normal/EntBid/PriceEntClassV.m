//
//  PriceEntClassV.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/22.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "PriceEntClassV.h"
#import "PriceEntClassCollectionCell.h"

@interface PriceEntClassV () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet BaseCV *baseCV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundVHeiCon;


@end

@implementation PriceEntClassV

- (void)awakeFromNib {
    [super awakeFromNib];
    self.baseCV.delegate = self;
    self.baseCV.dataSource = self;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize  = CGSizeMake((kScreenW - 10) / 4, 40);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.baseCV.collectionViewLayout = layout;
    [self.baseCV registerNib:[UINib nibWithNibName:@"PriceEntClassCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"PriceEntClassCollectionCell"];
    self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
}

- (void)setDataAry:(NSMutableArray<PriceModelM *> *)dataAry {
    _dataAry = dataAry;
    CGFloat hei = ((dataAry.count - 1) / 4 + 1) * 40 + 70;
    if (hei > kScreenH - kStatusH - 172 - kScreenH / 4) {
        hei = kScreenH - kStatusH - 172 - kScreenH / 4;
    }
    self.backgroundVHeiCon.constant = hei;
    [self layoutIfNeeded];
    [self.baseCV reloadData];
}

- (void)hideView {
    self.alpha = 0;
}

- (void)showView {
    kWeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 1;
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PriceEntClassCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PriceEntClassCollectionCell" forIndexPath:indexPath];
    NSString *key = [NSString stringWithFormat:@"Ent%@", @(self.dataAry[indexPath.row].ID).stringValue];
    NSString *index = kValueForKey(key);
    self.dataAry[indexPath.row].isSelect = index.integerValue == indexPath.row;
    cell.model = self.dataAry[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [NSString stringWithFormat:@"Ent%@", @(self.dataAry[indexPath.row].ID).stringValue];
    NSString *index = kValueForKey(key);
    if (indexPath.row != index.integerValue) {
        kSetValueForKey(@(indexPath.row).stringValue, key);
        if (self.selectBlock) {
            self.selectBlock();
        }
    }
    [self hideView];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenW - 10) / 4, 40);
}

- (IBAction)closeAct:(id)sender {
    [self hideView];
}


@end
