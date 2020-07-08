#import "BaseM.h"

@implementation BaseM

- (NSString *)description {
    NSString * desc= [super description];
    desc = [NSString stringWithFormat:@"\n%@\n", desc];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i ++) {
        objc_property_t property = properties[i];
        const char * propName = property_getName(property);
        if (propName) {
            NSString    * prop = [NSString stringWithCString:propName encoding:[NSString defaultCStringEncoding]];
            id obj = [self valueForKey:prop];
            desc = [desc stringByAppendingFormat:@"%@ : %@,\n",prop,obj];
        }
    }
    free(properties);
    return desc;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return  @{@"ID":@"id", @"typeName":@"typename"};
}

@end

@implementation ADM
@end

@implementation PageDataM
@end

@implementation PageTitleM
@end

@implementation ResultM
@end

@implementation UserM

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return  @{@"ID":@"id", @"isActivation":@"IsActivation"};
}

- (NSMutableDictionary *)jurDic {
    if (!_jurDic) {
        _jurDic = @{}.mutableCopy;
    }
    return _jurDic;
}

@end

@implementation PriceClassM
@end

@implementation PriceContentClassM

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return  @{@"ID":@"id", @"rootID":@"rootid"};
}

@end

@implementation PriceModelM
@end

@implementation PriceStoContentM

- (NSString *)price_avg {
    return _price_avg.floatValue ? _price_avg : self.sts_avg;
}

- (NSString *)price_min {
    return _price_min.floatValue ? _price_min : self.sts_min;
}

- (NSString *)price_max {
    return _price_max.floatValue ? _price_max : self.sts_max;
}

- (NSString *)price_zde {
    return _price_zde.floatValue ? _price_zde : self.zde;
}

@end

@implementation PriceStoM
@end

@implementation PriceEntBidM
@end

@implementation PriceEntBidClassM

@end

@implementation PriceFOContentM

@end

@implementation PriceFOM

@end

@implementation PriceFOClassM
@end

@implementation NewsClassM
@end

@implementation NewsM
@end

@implementation DistributionClassM
@end

@implementation DistributionM

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return  @{@"ID":@"id", @"isActivation":@"IsActivation", @"typeID":@"typeid", @"productID":@"productid"};
}

@end

@implementation FOPriceM
@end

@implementation PriceDetailsM
@end

@implementation PriceDetailsLineM
@end

@implementation PriceDetailsPriceM
@end

@implementation OrderCellM
@end

@implementation OrderInfoM
@end

@implementation OrderPrivacyInfoM

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return  @{@"productname":@"Productname"};
}

@end
