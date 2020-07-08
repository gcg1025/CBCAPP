#import "BaseTV.h"

@implementation BaseTV

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showsVerticalScrollIndicator = false;
    self.showsHorizontalScrollIndicator = false;
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    if (@available(iOS 11, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showsVerticalScrollIndicator = false;
    self.showsHorizontalScrollIndicator = false;
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    if (@available(iOS 11, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    return self;
}

@end
