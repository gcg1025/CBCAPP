#import "BaseCV.h"

@implementation BaseCV

- (instancetype)initWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    self = [self initWithFrame:frame collectionViewLayout:layout];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    self.showsVerticalScrollIndicator = false;
    self.showsHorizontalScrollIndicator = false;
    if (@available(iOS 11, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.backgroundColor = [UIColor whiteColor];
    return self;
}

@end
