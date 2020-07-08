#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, NoDataViewType) {
    NoDataViewTypePrice,
    NoDataViewTypeNews,
    NoDataViewTypeDistribution,
    NoDataViewTypeSupply,
    NoDataViewTypePurchase,
    NoDataViewTypeOrder,
    NoDataViewTypeCustomize,
    NoDataViewTypeFutures,
    NoDataViewTypeOrgnization
};

@interface NoDataV : UIView

@property (assign, nonatomic) NoDataViewType viewType;

@end

NS_ASSUME_NONNULL_END
