//
//  FOPriceClassV.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/8.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "FOPriceClassV.h"
#import "FOPriceClassCollectionCell.h"

@interface FOPriceClassV () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

//@property (weak, nonatomic) IBOutlet BaseCV *baseCV;
@property (weak, nonatomic) IBOutlet UIView *backgroundV;
@property (nonatomic, strong) BaseCV *baseCV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundVHeiCon;


@end

@implementation FOPriceClassV

- (void)awakeFromNib {
    [super awakeFromNib];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kScreenW - 10) / 4, 40);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.baseCV = [[BaseCV alloc] initWithFrame:CGRectMake(0, 30, kScreenW - 10, 165) collectionViewLayout:layout];
    self.baseCV.delegate = self;
    self.baseCV.dataSource = self;
    self.baseCV.backgroundColor = [UIColor whiteColor];
    [self.baseCV registerNib:[UINib nibWithNibName:@"FOPriceClassCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"FOPriceClassCollectionCell"];
    [self.backgroundV addSubview:self.baseCV];
    self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
}

- (void)setDataAry:(NSMutableArray<FOPriceM *> *)dataAry {
    _dataAry = dataAry;
    CGFloat hei = ((dataAry.count - 1) / 4 + 1) * 40 + 70;
    if (hei > kScreenH - kStatusH - 172 - kScreenH / 4) {
        hei = kScreenH - kStatusH - 172 - kScreenH / 4;
    }
    self.baseCV.frame = CGRectMake(0, 30, kScreenW - 10, hei - 50);
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
    FOPriceClassCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FOPriceClassCollectionCell" forIndexPath:indexPath];
    cell.model = self.dataAry[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectBlock) {
        self.selectBlock(indexPath.row);
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
