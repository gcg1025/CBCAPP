#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypeInit,
    RequestTypeGoingReload,
    RequestTypeGoingRefresh,
    RequestTypeGoingRequest,
    RequestTypeSuccessEmpty,
    RequestTypeSuccessNormal,
    RequestTypeSuccessNomoreData,
    RequestTypeError
};

@interface BaseM : NSObject

@end

@interface ADM : BaseM

@property (nonatomic, strong) NSString *pic_2208;
@property (nonatomic, strong) NSString *pic_2688;
@property (nonatomic, strong) NSString *linkurl;
@property (nonatomic, strong) NSString *showtime;

@end

@interface PageDataM : BaseM

@property (nonatomic, assign) NSInteger requestNumber;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) RequestType requestType;
@property (nonatomic, strong) NSMutableArray<BaseM *> *dataAry;

@property (nonatomic, strong) NSString *idsStr;
@property (nonatomic, strong) NSString *updatemarktypeStr;

@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *stoIndexAry;

@end

@interface PageTitleM : BaseM

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *type;

@end

@interface ResultM : BaseM
@end

@interface UserM : BaseM

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *companyname;
@property (nonatomic, strong) NSString *isActivation;
@property (nonatomic, strong) NSString *contacts;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *kfid;
@property (nonatomic, strong) NSString *kfphone;
@property (nonatomic, strong) NSString *sysdate;
@property (nonatomic, strong) NSString *enddate;
@property (nonatomic, strong) NSString *vipmember;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSMutableDictionary *jurDic;

@end

@interface PriceClassM : BaseM

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *str;
@property (nonatomic, strong) NSArray<PriceClassM *> *subClass;
@property (nonatomic, strong) NSArray<PageTitleM *> *priceTypeAry;
@property (nonatomic, strong) NSArray *dataAry;
@property (nonatomic, assign) BOOL isSelect;

@end

@interface PriceContentClassM : BaseM

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger rootID;
@property (nonatomic, strong) NSArray<PriceContentClassM *> *subClass;
@property (nonatomic, strong) NSArray *dataAry;
@property (nonatomic, assign) RequestType requestType;
@property (nonatomic, assign) BOOL isDetails;

@end


@interface PriceModelM : BaseM

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, assign) NSInteger productid_small;
@property (nonatomic, strong) NSString *productSmallName;
@property (nonatomic, assign) BOOL isSelect;

@end

@interface PriceStoContentM : BaseM

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString *price_avg;
@property (nonatomic, strong) NSString *price_max;
@property (nonatomic, strong) NSString *price_min;
@property (nonatomic, strong) NSString *price_zde;
@property (nonatomic, strong) NSString *price_zdf;
@property (nonatomic, strong) NSString *price_zsj;
@property (nonatomic, strong) NSString *sts_avg;
@property (nonatomic, strong) NSString *sts_max;
@property (nonatomic, strong) NSString *sts_min;
@property (nonatomic, strong) NSString *zde;
@property (nonatomic, strong) NSString *priceStr;

@end

@interface PriceStoM : BaseM

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString *bjjg;
@property (nonatomic, strong) NSString *indexstring;
@property (nonatomic, assign) BOOL isacceptances;
@property (nonatomic, assign) BOOL iscash;
@property (nonatomic, assign) BOOL istax;
@property (nonatomic, strong) NSString *pricetypename;
@property (nonatomic, strong) NSString *qname;
@property (nonatomic, strong) NSAttributedString *qnameAttr;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *valuedate;
@property (nonatomic, strong) NSString *zsunitname;

@property (nonatomic, strong) NSString *detailsTitleStr;
@property (nonatomic, strong) NSString *detailsNameStr;
@property (nonatomic, assign) BOOL isRequest;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) NSInteger jurID;

@property (nonatomic, strong) PriceStoContentM *priceStoContentM;

@end

@interface PriceEntBidM : BaseM

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString *valuedate;
@property (nonatomic, strong) NSString *comp_simple;
@property (nonatomic, strong) NSString *qname;
@property (nonatomic, strong) NSString *indexstring;
@property (nonatomic, strong) NSAttributedString *indexstringAttr;
@property (nonatomic, strong) NSString *areaname;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *price_zde;
@property (nonatomic, strong) NSString *price_zdf;
@property (nonatomic, strong) NSString *unitname;
@property (nonatomic, strong) NSString *fkfs;

@property (nonatomic, strong) NSString *pdate;
@property (nonatomic, strong) NSString *pdate_char;
@property (nonatomic, strong) NSString *companyname;
@property (nonatomic, strong) NSString *productid_name;
@property (nonatomic, strong) NSString *index_string;
@property (nonatomic, strong) NSString *price_average;
@property (nonatomic, strong) NSString *price_unit;
@property (nonatomic, strong) NSString *cg_number;
@property (nonatomic, strong) NSString *cg_unit;
@property (nonatomic, strong) NSString *fffs;

@property (nonatomic, strong) NSString *cg_str;

@property (nonatomic, assign) NSInteger jurID;
@property (nonatomic, strong) NSString *jurIDStr;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL isEnt;

@end

@interface PriceEntBidClassM : BaseM

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger productid;
@property (nonatomic, strong) NSMutableArray<PriceEntBidM *> *dataAry;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, assign) NSInteger productid_small;
@property (nonatomic, strong) NSString *productSmallName;
@property (nonatomic, assign) RequestType requestType;

@end

@interface PriceFOContentM : BaseM

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString *vclose;
@property (nonatomic, strong) NSString *vzde;
@property (nonatomic, strong) NSString *vcjl;
@property (nonatomic, strong) NSString *price_avg;
@property (nonatomic, strong) NSString *price_zde;
@property (nonatomic, strong) NSString *price_min;
@property (nonatomic, strong) NSString *price_max;
@property (nonatomic, strong) NSString *price_js;
@property (nonatomic, strong) NSString *price_jszde;
@property (nonatomic, strong) NSString *price_sell;
@property (nonatomic, strong) NSString *price_sell_zde;
@property (nonatomic, strong) NSString *price_sell_zdf;
@property (nonatomic, strong) NSString *price_close;
@property (nonatomic, strong) NSString *price_colse;
@property (nonatomic, strong) NSString *price_close_zde;
@property (nonatomic, strong) NSString *data_cjl;
@property (nonatomic, strong) NSString *priceStr;
@property (nonatomic, strong) NSString *priceCSStr;

@property (nonatomic, strong) NSString *min;
@property (nonatomic, strong) NSString *max;
@property (nonatomic, strong) NSString *avg;
@property (nonatomic, strong) NSString *trade;
@property (nonatomic, strong) NSString *zde;
@property (nonatomic, strong) NSString *zdf;
@property (nonatomic, strong) NSString *close;
@property (nonatomic, strong) NSString *sale;

@end

@interface PriceFOM : BaseM

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger bjjgid;
@property (nonatomic, strong) NSString *indexstring;
@property (nonatomic, strong) NSAttributedString *indexAttr;
@property (nonatomic, assign) BOOL isacceptances;
@property (nonatomic, assign) BOOL iscash;
@property (nonatomic, assign) BOOL istax;
@property (nonatomic, strong) NSString *pricetypename;
@property (nonatomic, strong) NSString *qname;
@property (nonatomic, strong) NSAttributedString *qnameAttr;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, assign) NSInteger updatemarktype;
@property (nonatomic, strong) NSString *valuedate;
@property (nonatomic, strong) NSString *zsunitname;

@property (nonatomic, strong) NSString *detailsTitleStr;
@property (nonatomic, strong) NSString *detailsNameStr;

@property (nonatomic, assign) BOOL isFutures;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) NSInteger jurID;
@property (nonatomic, assign) BOOL isLME;

@property (nonatomic, assign) BOOL isTitle;;

@property (nonatomic, strong) PriceFOContentM *priceFoContentM;

@end

@interface PriceFOClassM : BaseM

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSMutableArray<PriceFOM *> *dataAry;
@property (nonatomic, assign) BOOL isDetails;
@property (nonatomic, assign) BOOL isLME;

@end

@interface NewsClassM : BaseM

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *dataAry;
@property (nonatomic, strong) NSArray<NewsClassM *> *subClass;
@property (nonatomic, assign) BOOL isSelect;

@end

@interface NewsM : BaseM

@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *aid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *adate;
@property (nonatomic, strong) NSString *source;

@end

@interface DistributionClassM : BaseM

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *IDS;
@property (nonatomic, strong) NSArray<DistributionClassM *> *subClass;
@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, assign) CGFloat cellHeight;

@end

@interface DistributionM : BaseM

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger typeID;
@property (nonatomic, strong) NSString *infotitle;
@property (nonatomic, strong) NSAttributedString *name;
@property (nonatomic, strong) NSString *sysdate;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) BOOL isuse;

@property (nonatomic, strong) NSString *infoTitle;
@property (nonatomic, strong) NSString *infoContent;
@property (nonatomic, strong) NSString *guige;
@property (nonatomic, strong) NSString *tradenum;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *tradearea;
@property (nonatomic, assign) NSInteger productID;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL isSelect;

@end

@interface FOPriceM : BaseM

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray<PriceFOM *> *dataAry;
@property (nonatomic, assign) BOOL isSelect;

@end

@interface PriceDetailsM : BaseM

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger pid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) NSInteger bjjgid;
@property (nonatomic, strong) NSString *bjjgname;
@property (nonatomic, strong) NSString *qname;
@property (nonatomic, strong) NSString *indexstring;
@property (nonatomic, strong) NSString *pricetypename;
@property (nonatomic, strong) NSString *priceunitname;
@property (nonatomic, strong) NSString *placePruduct;
@property (nonatomic, strong) NSString *placeTrade;
@property (nonatomic, assign) NSInteger updatemarktype;
@property (nonatomic, assign) BOOL iscash;
@property (nonatomic, assign) BOOL istax;
@property (nonatomic, strong) NSString *payFunction;
@property (nonatomic, assign) NSInteger productid_big;

@end

@interface PriceDetailsLineM : BaseM

@property (nonatomic, assign) RequestType requestType;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSMutableArray<NSString *> *xDataAry;
@property (nonatomic, strong) NSMutableArray<NSString *> *yDataAry;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *yScaleAry;
@property (nonatomic, strong) NSString *yData1;
@property (nonatomic, strong) NSString *yData2;
@property (nonatomic, strong) NSString *yData3;
@property (nonatomic, strong) NSString *yData4;
@property (nonatomic, strong) NSString *xData1;
@property (nonatomic, strong) NSString *xData2;
@property (nonatomic, strong) NSString *xData3;
@property (nonatomic, strong) NSString *xData4;

@end

@interface PriceDetailsPriceM : BaseM

@property (nonatomic, strong) NSString *valuedate;
@property (nonatomic, strong) NSString *vopen;
@property (nonatomic, strong) NSString *vclose;
@property (nonatomic, strong) NSString *vzdf;
@property (nonatomic, strong) NSString *vjsj;
@property (nonatomic, strong) NSString *vcjl;
@property (nonatomic, strong) NSString *vccl;
@property (nonatomic, strong) NSString *price_close_zdf;
@property (nonatomic, strong) NSString *price_open;
@property (nonatomic, strong) NSString *price_close;
@property (nonatomic, strong) NSString *data_cjl;
@property (nonatomic, strong) NSString *data_ccl;
@property (nonatomic, strong) NSString *price_buy;
@property (nonatomic, strong) NSString *price_buy_zde;
@property (nonatomic, strong) NSString *price_buy_zdf;
@property (nonatomic, strong) NSString *price_sell;
@property (nonatomic, strong) NSString *price_sell_zde;
@property (nonatomic, strong) NSString *price_sell_zdf;
@property (nonatomic, strong) NSString *price_zde;
@property (nonatomic, strong) NSString *price_zdf;
@property (nonatomic, strong) NSString *price_min;
@property (nonatomic, strong) NSString *price_max;
@property (nonatomic, strong) NSString *price_avg;
@property (nonatomic, strong) NSString *price_jszde;
@property (nonatomic, strong) NSString *price_dp;
@property (nonatomic, strong) NSString *price_js;
@property (nonatomic, strong) NSString *price_close_zde;


@property (nonatomic, strong) NSString *price1;
@property (nonatomic, strong) UIColor *color1;
@property (nonatomic, strong) NSString *price2;
@property (nonatomic, strong) UIColor *color2;
@property (nonatomic, strong) NSString *price3;
@property (nonatomic, strong) UIColor *color3;
@property (nonatomic, strong) NSString *price4;
@property (nonatomic, strong) UIColor *color4;
@property (nonatomic, strong) NSString *price5;
@property (nonatomic, strong) UIColor *color5;
@property (nonatomic, strong) NSString *price6;
@property (nonatomic, strong) UIColor *color6;
@property (nonatomic, strong) NSString *price7;
@property (nonatomic, strong) UIColor *color7;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL isEmpty;

@end

@interface OrderCellM : BaseM

@property (nonatomic, strong) NSString *content;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) CGFloat cellHeight;

@end

@interface OrderPrivacyInfoM : BaseM

@property (nonatomic, strong) NSString *payMoney;
@property (nonatomic, strong) NSString *payType;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *systemDate;
@property (nonatomic, strong) NSString *productname;
@property (nonatomic, strong) NSString *enddate;
@property (nonatomic, strong) NSString *qxlx;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *startdate;
@property (nonatomic, strong) NSString *title;

@end

@interface OrderInfoM : BaseM

@property (nonatomic, strong) NSString *hyqy;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *jieshao;
@property (nonatomic, strong) NSString *year1;
@property (nonatomic, strong) NSString *price1_new;
@property (nonatomic, strong) NSString *price1_old;
@property (nonatomic, strong) NSString *year2;
@property (nonatomic, strong) NSString *price2_new;
@property (nonatomic, strong) NSString *price2_old;
@property (nonatomic, strong) NSString *year3;
@property (nonatomic, strong) NSString *price3_new;
@property (nonatomic, strong) NSString *price3_old;
@property (nonatomic, strong) NSString *zhname;
@property (nonatomic, strong) NSString *bank;
@property (nonatomic, strong) NSString *account;

@property (nonatomic, strong) NSString *ordernumber;
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) NSString *payMoney;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, strong) NSString *systemDate;
@property (nonatomic, strong) NSString *startdate;
@property (nonatomic, strong) NSString *vipdate;

@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *oriTitle;

@property (nonatomic, assign) BOOL isPayFunction;
@property (nonatomic, strong) NSString *tip;
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) OrderPrivacyInfoM *privacyModel;

@end



NS_ASSUME_NONNULL_END
