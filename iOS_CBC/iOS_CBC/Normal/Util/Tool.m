#import "Tool.h"
#import "RSA.h"
#import "SDWebImageManager.h"

@interface Tool () <NSURLSessionDelegate>

@property (strong, nonatomic) AFHTTPSessionManager *afManager;
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, strong) NSMutableDictionary *tasks;
@property (nonatomic, strong) NSMutableDictionary *sessionModels;

@property (nonatomic, strong) NSMutableArray *singleDetailsImgAry;
@property (nonatomic, strong) NSMutableArray *singleUnDetailsImgAry;
@property (nonatomic, strong) NSMutableArray *doubleDetailsImgAry;
@property (nonatomic, strong) NSMutableArray *doubleUnDetailsImgAry;

@end

@implementation Tool

- (NSMutableDictionary *)tasks {
    if (!_tasks) {
        _tasks = @{}.mutableCopy;
    }
    return  _tasks;
}

- (NSMutableDictionary *)sessionModels {
    if (!_sessionModels) {
        _sessionModels = @{}.mutableCopy;
    }
    return _tasks;
}

- (UserM *)user {
    if (!_user) {
        if (kValueForKey(@"user")) {
            if (kValueForKey(kValueForKey(@"user"))) {
                _user = [UserM mj_objectWithKeyValues:kValueForKey(kValueForKey(@"user"))];
            }
        }
    }
    return _user;
}

+ (NSArray *)metalAry {
    return @[@{@"name":@"基本金属", @"subClass":@[@{@"name":@"铜", @"subClass":@[], @"id":@(477), @"isSelect":@(false), @"str":@"cu"}, @{@"name":@"铝", @"subClass":@[], @"id":@(14981), @"isSelect":@(false), @"str":@"al"}, @{@"name":@"铅", @"subClass":@[], @"id":@(13429), @"isSelect":@(false), @"str":@"pb"}, @{@"name":@"锌", @"subClass":@[], @"id":@(9847), @"isSelect":@(false), @"str":@"zn"}, @{@"name":@"镍", @"subClass":@[], @"id":@(13923), @"isSelect":@(false), @"str":@"ni"}, @{@"name":@"锡", @"subClass":@[], @"id":@(13487), @"isSelect":@(false), @"str":@"sn"}], @"id":@(100), @"isSelect":@(false)}, @{@"name":@"铁合金", @"subClass":@[@{@"name":@"钒", @"subClass":@[], @"id":@(10198), @"isSelect":@(false), @"str":@"v"}, @{@"name":@"钛", @"subClass":@[], @"id":@(10099), @"isSelect":@(false), @"str":@"ti"}, @{@"name":@"铬", @"subClass":@[], @"id":@(10851), @"isSelect":@(false), @"str":@"cr"}, @{@"name":@"钼", @"subClass":@[], @"id":@(13889), @"isSelect":@(false), @"str":@"mo"}, @{@"name":@"钨", @"subClass":@[], @"id":@(11111), @"isSelect":@(false), @"str":@"w"}, @{@"name":@"锰", @"subClass":@[], @"id":@(13685), @"isSelect":@(false), @"str":@"mn"}, @{@"name":@"硅", @"subClass":@[], @"id":@(13987), @"isSelect":@(false), @"str":@"si"}], @"id":@(200), @"isSelect":@(false)}, @{@"name":@"贵金属", @"subClass":@[@{@"name":@"金", @"subClass":@[], @"id":@(10643), @"isSelect":@(false), @"str":@"au"}, @{@"name":@"银", @"subClass":@[], @"id":@(10763), @"isSelect":@(false), @"str":@"ag"}, @{@"name":@"铂", @"subClass":@[], @"id":@(14027), @"isSelect":@(false), @"str":@"pt"}, @{@"name":@"钯", @"subClass":@[], @"id":@(13813), @"isSelect":@(false), @"str":@"pd"}, @{@"name":@"锇", @"subClass":@[], @"id":@(10897), @"isSelect":@(false), @"str":@"os"}, @{@"name":@"铑", @"subClass":@[], @"id":@(10790), @"isSelect":@(false), @"str":@"rh"}, @{@"name":@"钌", @"subClass":@[], @"id":@(13845), @"isSelect":@(false), @"str":@"ru"}, @{@"name":@"铱", @"subClass":@[], @"id":@(10429), @"isSelect":@(false), @"str":@"ir"}], @"id":@(300), @"isSelect":@(false)}, @{@"name":@"小金属", @"subClass":@[@{@"name":@"钴", @"subClass":@[], @"id":@(10114), @"isSelect":@(false), @"str":@"co"}, @{@"name":@"锂", @"subClass":@[], @"id":@(14086), @"isSelect":@(false), @"str":@"li"}, @{@"name":@"石墨碳素", @"subClass":@[], @"id":@(42344), @"isSelect":@(false), @"str":@"go"}, @{@"name":@"铟", @"subClass":@[], @"id":@(13835), @"isSelect":@(false), @"str":@"in"}, @{@"name":@"铋", @"subClass":@[], @"id":@(10456), @"isSelect":@(false), @"str":@"bi"}, @{@"name":@"锗", @"subClass":@[], @"id":@(10626), @"isSelect":@(false), @"str":@"ge"}, @{@"name":@"镓", @"subClass":@[], @"id":@(11043), @"isSelect":@(false), @"str":@"ga"}, @{@"name":@"碲", @"subClass":@[], @"id":@(11034), @"isSelect":@(false), @"str":@"te"}, @{@"name":@"硒", @"subClass":@[], @"id":@(10708), @"isSelect":@(false), @"str":@"se"}, @{@"name":@"锑", @"subClass":@[], @"id":@(10369), @"isSelect":@(false), @"str":@"sb"}, @{@"name":@"钽", @"subClass":@[], @"id":@(13955), @"isSelect":@(false), @"str":@"ta"}, @{@"name":@"铌", @"subClass":@[], @"id":@(10477), @"isSelect":@(false), @"str":@"nb"}, @{@"name":@"铷", @"subClass":@[], @"id":@(10884), @"isSelect":@(false), @"str":@"rb"}, @{@"name":@"铯", @"subClass":@[], @"id":@(10891), @"isSelect":@(false), @"str":@"cs"}, @{@"name":@"镁", @"subClass":@[], @"id":@(14083), @"isSelect":@(false), @"str":@"mg"}, @{@"name":@"锆", @"subClass":@[], @"id":@(10258), @"isSelect":@(false), @"str":@"zr"}, @{@"name":@"砷", @"subClass":@[], @"id":@(14061), @"isSelect":@(false), @"str":@"as"}, @{@"name":@"汞", @"subClass":@[], @"id":@(10470), @"isSelect":@(false), @"str":@"hg"}, @{@"name":@"镉", @"subClass":@[], @"id":@(15000), @"isSelect":@(false), @"str":@"cd"}, @{@"name":@"铼", @"subClass":@[], @"id":@(10804), @"isSelect":@(false), @"str":@"re"}, @{@"name":@"铍", @"subClass":@[], @"id":@(14039), @"isSelect":@(false), @"str":@"be"}, @{@"name":@"铊", @"subClass":@[], @"id":@(10720), @"isSelect":@(false), @"str":@"tl"}, @{@"name":@"锶", @"subClass":@[], @"id":@(13828), @"isSelect":@(false), @"str":@"sr"}, @{@"name":@"铪", @"subClass":@[], @"id":@(13853), @"isSelect":@(false), @"str":@"hf"}, @{@"name":@"硼", @"subClass":@[], @"id":@(10136), @"isSelect":@(false), @"str":@"b"}, @{@"name":@"磷", @"subClass":@[], @"id":@(10819), @"isSelect":@(false), @"str":@"p"}, @{@"name":@"钠", @"subClass":@[], @"id":@(13731), @"isSelect":@(false), @"str":@"na"}, @{@"name":@"钾", @"subClass":@[], @"id":@(13759), @"isSelect":@(false), @"str":@"k"}, @{@"name":@"钙", @"subClass":@[], @"id":@(13976), @"isSelect":@(false), @"str":@"ca"}, @{@"name":@"钡", @"subClass":@[], @"id":@(14159), @"isSelect":@(false), @"str":@"ba"}, @{@"name":@"稀土", @"subClass":@[], @"id":@(10395), @"isSelect":@(false), @"str":@"ree"}, @{@"name":@"耐火材料", @"subClass":@[], @"id":@(44398), @"isSelect":@(false), @"str":@"naihuo"}, @{@"name":@"陶瓷材料", @"subClass":@[], @"id":@(44397), @"isSelect":@(false), @"str":@"taoci"}, @{@"name":@"粉体", @"subClass":@[], @"id":@(44417), @"isSelect":@(false), @"str":@"fenti"}, @{@"name":@"无机化工", @"subClass":@[], @"id":@(44433), @"isSelect":@(false), @"str":@"wjy"}, @{@"name":@"不锈钢", @"subClass":@[], @"id":@(46471), @"isSelect":@(false), @"str":@"bxg"}, @{@"name":@"废旧", @"subClass":@[], @"id":@(43117), @"isSelect":@(false), @"str":@"waste"}, @{@"name":@"矿业", @"subClass":@[], @"id":@(5710), @"isSelect":@(false), @"str":@"mining"}], @"id":@(400), @"isSelect":@(false)}];
}
+ (NSString *)metalNameWithID:(NSInteger)ID {
    NSString *str = @"全部";
    switch (ID) {
        case 831: str = @"氯化铷"; break;
        case 1009: str = @"碳酸铷"; break;
        case 7197: str = @"硫酸铷"; break;
        case 5432: str = @"硝酸铷"; break;
        case 42283: str = @"碘化铷"; break;
        case 496: str = @"铜棒"; break;
        case 501: str = @"铜排"; break;
        case 503: str = @"铜箔"; break;
        case 6231: str = @"四钼酸铵"; break;
        case 6370: str = @"二钼酸铵"; break;
        case 6232: str = @"七钼酸铵"; break;
        case 10395: str = @"稀土"; break;
        case 372: str = @"粗铜"; break;
        case 14178: str = @"电解铜"; break;
        case 4411: str = @"黄铜板"; break;
        case 4863: str = @"紫铜带"; break;
        case 4414: str = @"紫铜管"; break;
        case 4864: str = @"黄铜棒"; break;
        case 4865: str = @"紫铜棒"; break;
        case 4868: str = @"低氧铜杆"; break;
        case 4869: str = @"无氧铜杆"; break;
        case 797: str = @"煅烧氧化铝"; break;
        case 13276: str = @"铝合金"; break;
        case 13279: str = @"铝异型材"; break;
        case 13282: str = @"铝杆"; break;
        case 13316: str = @"铝棒"; break;
        case 15010: str = @"铝型材"; break;
        case 43010: str = @"三元材料"; break;
        case 663: str = @"氢氧化铝"; break;
        case 704: str = @"氧化铝"; break;
        case 9678: str = @"氟化铝"; break;
        case 13265: str = @"冰晶石"; break;
        case 13268: str = @"氯化铝"; break;
        case 9193: str = @"高碳锰铁粉"; break;
        case 477: str = @"铜"; break;
        case 13923: str = @"镍"; break;
        case 5951: str = @"价格列表"; break;
        case 13522: str = @"锌锭"; break;
        case 6258: str = @"硫酸锆"; break;
        case 41441: str = @"锂辉石"; break;
        case 46518: str = @"锂云母"; break;
        case 8727: str = @"低铝硅铁"; break;
        case 44432: str = @"焦亚硫酸钠"; break;
        case 623: str = @"氢氧化铯"; break;
        case 40967: str = @"氯化铯"; break;
        case 40971: str = @"碘化铯"; break;
        case 40973: str = @"碳酸铯"; break;
        case 40974: str = @"硫酸铯"; break;
        case 42281: str = @"醋酸铯"; break;
        case 42280: str = @"溴化铯"; break;
        case 7245: str = @"氯化锌"; break;
        case 6673: str = @"生铁"; break;
        case 6790: str = @"锰铁"; break;
        case 8729: str = @"稀土镁硅铁"; break;
        case 1051: str = @"砷铜合金"; break;
        case 1052: str = @"铍铜合金"; break;
        case 6383: str = @"铍青铜合金"; break;
        case 9842: str = @"锡条"; break;
        case 8710: str = @"其它"; break;
        case 5582: str = @"电解锌"; break;
        case 9934: str = @"镍铁"; break;
        case 42567: str = @"低镍铁"; break;
        case 42566: str = @"高镍铁"; break;
        case 42565: str = @"中镍铁"; break;
        case 13964: str = @"硝酸钾"; break;
        case 10084: str = @"镁锭"; break;
        case 13628: str = @"硅铁"; break;
        case 10046: str = @"铝硅铁"; break;
        case 11222: str = @"硅钡"; break;
        case 10050: str = @"硅钙"; break;
        case 14055: str = @"稀土硅铁"; break;
        case 6788: str = @"硅铝钡"; break;
        case 376: str = @"硅锆"; break;
        case 41220: str = @"硅锶"; break;
        case 448: str = @"硅铬合金"; break;
        case 8733: str = @"低钛铁"; break;
        case 8734: str = @"中钛铁"; break;
        case 8735: str = @"高钛铁"; break;
        case 82: str = @"硅钙包芯线"; break;
        case 10101: str = @"钛精矿"; break;
        case 10102: str = @"金属钛"; break;
        case 10107: str = @"金红石"; break;
        case 10335: str = @"海绵钛"; break;
        case 10336: str = @"四氯化钛"; break;
        case 13658: str = @"高钛渣"; break;
        case 6375: str = @"酸溶渣"; break;
        case 13662: str = @"钛白粉"; break;
        case 10345: str = @"草酸钴"; break;
        case 10115: str = @"钴矿"; break;
        case 10118: str = @"电解钴"; break;
        case 14020: str = @"钴粉"; break;
        case 14021: str = @"钴片"; break;
        case 15013: str = @"偏钒酸铵"; break;
        case 10214: str = @"钒铁"; break;
        case 10213: str = @"钒氮合金"; break;
        case 13940: str = @"钒铝合金"; break;
        case 6900: str = @"氮化钒铁"; break;
        case 6916: str = @"多钒酸铵"; break;
        case 10208: str = @"五氧化二钒"; break;
        case 41893: str = @"粉钒"; break;
        case 41892: str = @"片钒"; break;
        case 5271: str = @"钒渣"; break;
        case 41335: str = @"硫酸锂"; break;
        case 42249: str = @"氟化锂"; break;
        case 44381: str = @"钼酸锂"; break;
        case 44382: str = @"溴化锂"; break;
        case 44383: str = @"叔丁醇锂"; break;
        case 44384: str = @"碘化锂"; break;
        case 10049: str = @"钛铁"; break;
        case 10260: str = @"锆精矿"; break;
        case 13787: str = @"金属锆"; break;
        case 13788: str = @"锆化合物"; break;
        case 13793: str = @"锆英砂"; break;
        case 43026: str = @"锆中矿"; break;
        case 7382: str = @"氧化锆"; break;
        case 6073: str = @"二氧化锆"; break;
        case 41211: str = @"氢氧化锆"; break;
        case 10268: str = @"碳酸锆"; break;
        case 6252: str = @"氧氯化锆"; break;
        case 41277: str = @"氯化锆"; break;
        case 41278: str = @"四氯化锆"; break;
        case 7234: str = @"锆铁"; break;
        case 43031: str = @"锆英粉"; break;
        case 10289: str = @"氢氧化锂"; break;
        case 41283: str = @"氧化锂"; break;
        case 10285: str = @"氯化锂"; break;
        case 10286: str = @"碳酸锂"; break;
        case 10287: str = @"锂的碳酸盐"; break;
        case 10288: str = @"钴酸锂"; break;
        case 46519: str = @"电池级碳酸锂"; break;
        case 7851: str = @"焦锑酸钠"; break;
        case 13663: str = @"锑锭"; break;
        case 10390: str = @"三氧化二锑"; break;
        case 10400: str = @"稀土制品"; break;
        case 10399: str = @"稀土合金"; break;
        case 10398: str = @"稀土化合物"; break;
        case 10397: str = @"稀土金属"; break;
        case 10402: str = @"金属镧"; break;
        case 10408: str = @"金属铈"; break;
        case 15009: str = @"金属钕"; break;
        case 6192: str = @"镨钕金属"; break;
        case 10618: str = @"镧铈金属"; break;
        case 6215: str = @"稀土硅铁"; break;
        case 43099: str = @"稀土镁合金"; break;
        case 6212: str = @"稀土镁硅"; break;
        case 41956: str = @"钕铁硼"; break;
        case 10414: str = @"氧化镧"; break;
        case 10415: str = @"氧化铈"; break;
        case 10416: str = @"氧化镨钕"; break;
        case 10417: str = @"氧化钕"; break;
        case 10418: str = @"氧化钐"; break;
        case 10419: str = @"氧化钆"; break;
        case 10420: str = @"氧化铕"; break;
        case 10421: str = @"氧化钇"; break;
        case 10423: str = @"氧化铽"; break;
        case 10424: str = @"氧化镝"; break;
        case 10425: str = @"氧化钬"; break;
        case 10426: str = @"氧化铒"; break;
        case 10427: str = @"氧化镨"; break;
        case 6876: str = @"氧化镥"; break;
        case 6875: str = @"氧化钪"; break;
        case 7158: str = @"氧化镱"; break;
        case 7302: str = @"稀土氧化物"; break;
        case 13799: str = @"镉锭"; break;
        case 10464: str = @"铋锭"; break;
        case 7130: str = @"氧化铋"; break;
        case 14091: str = @"金属汞"; break;
        case 6254: str = @"汞触媒"; break;
        case 6955: str = @"铌矿"; break;
        case 10485: str = @"铌锭"; break;
        case 5350: str = @"铌条"; break;
        case 41648: str = @"铌棒"; break;
        case 41647: str = @"铌片"; break;
        case 41646: str = @"铌丝"; break;
        case 41645: str = @"铌异型加工件"; break;
        case 10487: str = @"铌铁"; break;
        case 10669: str = @"锗锭"; break;
        case 10695: str = @"二氧化锰"; break;
        case 10698: str = @"锰酸锂"; break;
        case 10750: str = @"锰铁"; break;
        case 10752: str = @"铝锰铁"; break;
        case 13631: str = @"硅锰"; break;
        case 10711: str = @"硒锭"; break;
        case 40975: str = @"碳酸锶"; break;
        case 40976: str = @"氯化锶"; break;
        case 40980: str = @"氢氧化锶"; break;
        case 40986: str = @"氧化锶"; break;
        case 6384: str = @"高炉锰铁"; break;
        case 516: str = @"中碳锰铁"; break;
        case 1070: str = @"高碳锰铁"; break;
        case 1071: str = @"低碳锰铁"; break;
        case 6908: str = @"微碳锰铁"; break;
        case 11252: str = @"银粉"; break;
        case 41352: str = @"铼粉"; break;
        case 1008: str = @"铼粒"; break;
        case 11122: str = @"铼酸铵"; break;
        case 43012: str = @"蠕化剂"; break;
        case 10875: str = @"磷矿石"; break;
        case 10852: str = @"铬矿"; break;
        case 5449: str = @"铬矿砂"; break;
        case 11255: str = @"金属铬"; break;
        case 10973: str = @"铬铁"; break;
        case 10040: str = @"硅铬铁"; break;
        case 41311: str = @"铬精粉"; break;
        case 41530: str = @"磷酸二铵"; break;
        case 41536: str = @"磷酸一铵"; break;
        case 41537: str = @"磷酸"; break;
        case 42431: str = @"磷酸铁锂"; break;
        case 44405: str = @"黄磷"; break;
        case 10979: str = @"金属铬粉"; break;
        case 6437: str = @"氧化钨"; break;
        case 1058: str = @"高碳铬铁"; break;
        case 1054: str = @"低碳铬铁"; break;
        case 14774: str = @"微碳铬铁"; break;
        case 6209: str = @"中碳铬铁"; break;
        case 6210: str = @"氮化铬铁"; break;
        case 6915: str = @"高氮铬铁"; break;
        case 14781: str = @"低微碳铬铁"; break;
        case 13717: str = @"白钨精矿"; break;
        case 13718: str = @"黑钨精矿"; break;
        case 10996: str = @"钨酸"; break;
        case 10997: str = @"仲钨酸铵"; break;
        case 10998: str = @"钨酸钠"; break;
        case 11000: str = @"偏钨酸铵"; break;
        case 11003: str = @"碳化钨"; break;
        case 6614: str = @"碳化钨粉"; break;
        case 11008: str = @"钨铁"; break;
        case 11009: str = @"钨条"; break;
        case 11041: str = @"碲锭"; break;
        case 6260: str = @"二氧化碲"; break;
        case 41208: str = @"氧化碲"; break;
        case 41209: str = @"三氧化碲"; break;
        case 41210: str = @"四氯化碲"; break;
        case 11046: str = @"金属镓"; break;
        case 13715: str = @"废钨"; break;
        case 13714: str = @"钨材"; break;
        case 13713: str = @"钨化合物"; break;
        case 15020: str = @"钨矿"; break;
        case 41560: str = @"硅钡钙"; break;
        case 13277: str = @"铝合金锭"; break;
        case 13278: str = @"铸造铝合金锭"; break;
        case 5369: str = @"合金铝棒"; break;
        case 6935: str = @"压铸铝合金锭"; break;
        case 13645: str = @"热镀铝合金锭"; break;
        case 13280: str = @"非合金铝制型材及异型材"; break;
        case 13281: str = @"铝合金制空心异型材"; break;
        case 7149: str = @"电工圆铝杆"; break;
        case 13434: str = @"铅锭"; break;
        case 6185: str = @"氧化铅"; break;
        case 13448: str = @"铅钙合金"; break;
        case 996: str = @"铅砷合金"; break;
        case 13491: str = @"电解锡"; break;
        case 13492: str = @"锡锭"; break;
        case 13911: str = @"圆柱型碱性锌锰原电池(组)"; break;
        case 13525: str = @"氧化锌"; break;
        case 13532: str = @"锌粉"; break;
        case 13534: str = @"锌板"; break;
        case 6934: str = @"压铸锌合金锭"; break;
        case 977: str = @"热镀锌合金锭"; break;
        case 41989: str = @"铸造锌合金"; break;
        case 13549: str = @"镀或涂锌板"; break;
        case 13919: str = @"锌钡白"; break;
        case 5532: str = @"高纯硅铁"; break;
        case 41214: str = @"低钛低碳硅铁"; break;
        case 8725: str = @"高硅硅锰"; break;
        case 13686: str = @"锰矿"; break;
        case 13688: str = @"电解锰"; break;
        case 13689: str = @"锰化合物"; break;
        case 13691: str = @"废锰"; break;
        case 7142: str = @"金属锰"; break;
        case 13693: str = @"碳酸锰矿"; break;
        case 10679: str = @"氧化锰矿"; break;
        case 519: str = @"高铁锰矿"; break;
        case 9192: str = @"烧结锰矿"; break;
        case 384: str = @"高硅锰矿"; break;
        case 445: str = @"锰粉矿"; break;
        case 444: str = @"半碳酸锰矿"; break;
        case 10691: str = @"锰锭"; break;
        case 7163: str = @"电解锰片"; break;
        case 10681: str = @"锰粉"; break;
        case 6324: str = @"锰球"; break;
        case 13697: str = @"富锰渣"; break;
        case 6613: str = @"钨化合物"; break;
        case 7314: str = @"蓝钨"; break;
        case 11004: str = @"钨合金"; break;
        case 11005: str = @"钨粉"; break;
        case 9: str = @"钨条"; break;
        case 42986: str = @"炼钢钨条"; break;
        case 9872: str = @"钠的氟化物"; break;
        case 13746: str = @"钠的亚硫酸盐"; break;
        case 9899: str = @"磷酸一钠及磷酸二钠"; break;
        case 13749: str = @"三磷酸钠"; break;
        case 14197: str = @"碳酸氢钠"; break;
        case 14198: str = @"氰化钠"; break;
        case 13952: str = @"硝酸钠"; break;
        case 6609: str = @"硫酸钠"; break;
        case 40998: str = @"亚硫酸钠"; break;
        case 9720: str = @"氢氧化钠"; break;
        case 13761: str = @"金属钾"; break;
        case 9977: str = @"钾硝化物"; break;
        case 9997: str = @"钾的磷酸盐"; break;
        case 9998: str = @"钾的碳酸盐"; break;
        case 10000: str = @"硫酸钾"; break;
        case 41350: str = @"碳酸钾"; break;
        case 10002: str = @"氢氧化钾"; break;
        case 10005: str = @"氯化钾"; break;
        case 10124: str = @"氧化钴"; break;
        case 10125: str = @"四氧化三钴"; break;
        case 6251: str = @"氧化亚钴"; break;
        case 42248: str = @"氢氧化钴"; break;
        case 10128: str = @"硫酸钴"; break;
        case 10129: str = @"硝酸钴"; break;
        case 10131: str = @"氯化钴"; break;
        case 6256: str = @"电熔锆"; break;
        case 41279: str = @"醋酸锆"; break;
        case 6257: str = @"硅酸锆"; break;
        case 10271: str = @"锆粉"; break;
        case 7144: str = @"氧化镉"; break;
        case 5283: str = @"氧化锗"; break;
        case 13826: str = @"硒粉"; break;
        case 13824: str = @"二氧化硒"; break;
        case 10713: str = @"金属锶"; break;
        case 10784: str = @"粗铟"; break;
        case 6297: str = @"精铟"; break;
        case 41017: str = @"氢氧化钡"; break;
        case 41338: str = @"铪粉"; break;
        case 13895: str = @"钼矿"; break;
        case 13916: str = @"氧化钼"; break;
        case 6262: str = @"钼酸钠"; break;
        case 9976: str = @"钼铁"; break;
        case 13910: str = @"钼粉"; break;
        case 9982: str = @"钼条"; break;
        case 13912: str = @"钼丝"; break;
        case 385: str = @"钼酸铵"; break;
        case 13915: str = @"其它钼材"; break;
        case 6360: str = @"三氧化钼"; break;
        case 9195: str = @"钼酸"; break;
        case 13927: str = @"电解镍"; break;
        case 13928: str = @"镍化合物"; break;
        case 13929: str = @"镍材"; break;
        case 13924: str = @"镍矿"; break;
        case 13932: str = @"红土镍矿"; break;
        case 42572: str = @"电解镍板"; break;
        case 9921: str = @"镍合金"; break;
        case 1069: str = @"镍板"; break;
        case 42558: str = @"镍球"; break;
        case 13935: str = @"氧化镍"; break;
        case 9890: str = @"氧化亚镍"; break;
        case 9896: str = @"硫酸镍"; break;
        case 9891: str = @"氯化镍"; break;
        case 13956: str = @"钽矿"; break;
        case 41969: str = @"钽铌矿"; break;
        case 13977: str = @"钙矿"; break;
        case 13980: str = @"金属钙"; break;
        case 13982: str = @"钙化合物"; break;
        case 43032: str = @"粗钙"; break;
        case 14190: str = @"硝酸钙"; break;
        case 41036: str = @"硫酸钙"; break;
        case 13976: str = @"钙"; break;
        case 11034: str = @"碲"; break;
        case 13759: str = @"钾"; break;
        case 10136: str = @"硼"; break;
        case 10258: str = @"锆"; break;
        case 13989: str = @"金属硅"; break;
        case 13993: str = @"硅石"; break;
        case 14001: str = @"硅材"; break;
        case 7704: str = @"多晶硅"; break;
        case 50691: str = @"电池片"; break;
        case 46517: str = @"通氧金属硅"; break;
        case 47547: str = @"5字头金属硅"; break;
        case 14998: str = @"硅酸盐"; break;
        case 8739: str = @"钴酸锂"; break;
        case 14044: str = @"金属铍"; break;
        case 14062: str = @"金属砷"; break;
        case 14084: str = @"镁矿"; break;
        case 5362: str = @"镁砂"; break;
        case 53707: str = @"镁石"; break;
        case 14090: str = @"金属锂"; break;
        case 44386: str = @"锂粉"; break;
        case 6276: str = @"氯化汞"; break;
        case 10473: str = @"氯化钡"; break;
        case 42549: str = @"阴极铜"; break;
        case 10009: str = @"氯化钙"; break;
        case 14209: str = @"钽锭"; break;
        case 14215: str = @"钽丝"; break;
        case 43109: str = @"钽片"; break;
        case 41650: str = @"钽棒"; break;
        case 41649: str = @"钽异型加工件"; break;
        case 843: str = @"五氧化二钽"; break;
        case 10344: str = @"碳酸钴"; break;
        case 4413: str = @"铜锌合金管"; break;
        case 705: str = @"铝材"; break;
        case 14991: str = @"电解铝"; break;
        case 14992: str = @"预焙阳极"; break;
        case 14993: str = @"铝锭"; break;
        case 42055: str = @"重熔用铝锭"; break;
        case 9953: str = @"碳化硅"; break;
        case 6072: str = @"黑碳化硅"; break;
        case 41216: str = @"有机硅"; break;
        case 41336: str = @"镉粒"; break;
        case 13729: str = @"硼粉"; break;
        case 10990: str = @"钨精矿"; break;
        case 15025: str = @"硼铁"; break;
        case 41973: str = @"硼铁包芯线"; break;
        case 15028: str = @"氯化钯"; break;
        case 479: str = @"硫酸铜"; break;
        case 41032: str = @"二氧化钙"; break;
        case 41033: str = @"氧化钙"; break;
        case 41034: str = @"氢氧化钙"; break;
        case 41909: str = @"磷酸铁锂前驱体"; break;
        case 41919: str = @"锰酸锂正极材料"; break;
        case 46527: str = @"双氟磺酰亚胺锂"; break;
        case 11111: str = @"钨"; break;
        case 10851: str = @"铬"; break;
        case 13685: str = @"锰"; break;
        case 13987: str = @"硅"; break;
        case 44404: str = @"等静压石墨"; break;
        case 42350: str = @"果壳"; break;
        case 42349: str = @"煤质"; break;
        case 42348: str = @"木质"; break;
        case 42358: str = @"石墨电极"; break;
        case 42354: str = @"阴极炭块"; break;
        case 42352: str = @"增碳剂"; break;
        case 42351: str = @"针状焦"; break;
        case 48688: str = @"石墨电极"; break;
        case 41515: str = @"锂电池"; break;
        case 41503: str = @"前驱体"; break;
        case 41502: str = @"六氟磷酸锂"; break;
        case 41500: str = @"溶剂"; break;
        case 42074: str = @"隔膜"; break;
        case 42075: str = @"电解液"; break;
        case 42072: str = @"正极材料"; break;
        case 42073: str = @"负极材料"; break;
        case 13896: str = @"钼精矿"; break;
        case 13902: str = @"钼材"; break;
        case 10862: str = @"氧化铬绿"; break;
        case 42353: str = @"原料"; break;
        case 14989: str = @"铝土矿"; break;
        case 10077: str = @"菱镁矿"; break;
        case 53790: str = @"氟硅酸钠"; break;
        case 10475: str = @"碳酸钡"; break;
        default: break;
    }
    return str;
}

+ (NSArray *)distributionAry {
    return @[@{@"name":@"铁合金", @"subClass":@[@{@"name":@"钒", @"subClass":@[], @"id":@(10198), @"isSelect":@(false), @"str":@"v"}, @{@"name":@"钛", @"subClass":@[], @"id":@(10099), @"isSelect":@(false), @"str":@"ti"}, @{@"name":@"铬", @"subClass":@[], @"id":@(10851), @"isSelect":@(false), @"str":@"cr"}, @{@"name":@"钼", @"subClass":@[], @"id":@(13889), @"isSelect":@(false), @"str":@"mo"}, @{@"name":@"钨", @"subClass":@[], @"id":@(11111), @"isSelect":@(false), @"str":@"w"}, @{@"name":@"锰", @"subClass":@[], @"id":@(13685), @"isSelect":@(false), @"str":@"mn"}, @{@"name":@"硅", @"subClass":@[], @"id":@(13987), @"isSelect":@(false), @"str":@"si"}], @"id":@(100), @"isSelect":@(false)}, @{@"name":@"基本金属", @"subClass":@[@{@"name":@"铜", @"subClass":@[], @"id":@(477), @"isSelect":@(false), @"str":@"cu"}, @{@"name":@"铝", @"subClass":@[], @"id":@(14981), @"isSelect":@(false), @"str":@"al"}, @{@"name":@"铅", @"subClass":@[], @"id":@(13429), @"isSelect":@(false), @"str":@"pb"}, @{@"name":@"锌", @"subClass":@[], @"id":@(9847), @"isSelect":@(false), @"str":@"zn"}, @{@"name":@"镍", @"subClass":@[], @"id":@(13923), @"isSelect":@(false), @"str":@"ni"}, @{@"name":@"锡", @"subClass":@[], @"id":@(13487), @"isSelect":@(false), @"str":@"sn"}], @"id":@(200), @"isSelect":@(false)}, @{@"name":@"稀散金属", @"subClass":@[@{@"name":@"钴", @"subClass":@[], @"id":@(10114), @"isSelect":@(false), @"str":@"co"}, @{@"name":@"锂", @"subClass":@[], @"id":@(14086), @"isSelect":@(false), @"str":@"li"}, @{@"name":@"铟", @"subClass":@[], @"id":@(13835), @"isSelect":@(false), @"str":@"in"}, @{@"name":@"铋", @"subClass":@[], @"id":@(10456), @"isSelect":@(false), @"str":@"bi"}, @{@"name":@"锗", @"subClass":@[], @"id":@(10626), @"isSelect":@(false), @"str":@"ge"}, @{@"name":@"镓", @"subClass":@[], @"id":@(11043), @"isSelect":@(false), @"str":@"ga"}, @{@"name":@"碲", @"subClass":@[], @"id":@(11034), @"isSelect":@(false), @"str":@"te"}, @{@"name":@"硒", @"subClass":@[], @"id":@(10708), @"isSelect":@(false), @"str":@"se"}, @{@"name":@"锑", @"subClass":@[], @"id":@(10369), @"isSelect":@(false), @"str":@"sb"}, @{@"name":@"钽", @"subClass":@[], @"id":@(13955), @"isSelect":@(false), @"str":@"ta"}, @{@"name":@"铌", @"subClass":@[], @"id":@(10477), @"isSelect":@(false), @"str":@"nb"}, @{@"name":@"铷", @"subClass":@[], @"id":@(10884), @"isSelect":@(false), @"str":@"rb"}, @{@"name":@"铯", @"subClass":@[], @"id":@(10891), @"isSelect":@(false), @"str":@"cs"}, @{@"name":@"镁", @"subClass":@[], @"id":@(14083), @"isSelect":@(false), @"str":@"mg"}, @{@"name":@"锆", @"subClass":@[], @"id":@(10258), @"isSelect":@(false), @"str":@"zr"}, @{@"name":@"砷", @"subClass":@[], @"id":@(14061), @"isSelect":@(false), @"str":@"as"}, @{@"name":@"汞", @"subClass":@[], @"id":@(10470), @"isSelect":@(false), @"str":@"hg"}, @{@"name":@"镉", @"subClass":@[], @"id":@(15000), @"isSelect":@(false), @"str":@"cd"}, @{@"name":@"铼", @"subClass":@[], @"id":@(10804), @"isSelect":@(false), @"str":@"re"}, @{@"name":@"铍", @"subClass":@[], @"id":@(14039), @"isSelect":@(false), @"str":@"be"}, @{@"name":@"铊", @"subClass":@[], @"id":@(10720), @"isSelect":@(false), @"str":@"tl"}, @{@"name":@"锶", @"subClass":@[], @"id":@(13828), @"isSelect":@(false), @"str":@"sr"}, @{@"name":@"铪", @"subClass":@[], @"id":@(13853), @"isSelect":@(false), @"str":@"hf"}, @{@"name":@"硼", @"subClass":@[], @"id":@(10136), @"isSelect":@(false), @"str":@"b"}, @{@"name":@"磷", @"subClass":@[], @"id":@(10819), @"isSelect":@(false), @"str":@"p"}, @{@"name":@"钠", @"subClass":@[], @"id":@(13731), @"isSelect":@(false), @"str":@"na"}, @{@"name":@"钾", @"subClass":@[], @"id":@(13759), @"isSelect":@(false), @"str":@"k"}, @{@"name":@"钙", @"subClass":@[], @"id":@(13976), @"isSelect":@(false), @"str":@"ca"}, @{@"name":@"钡", @"subClass":@[], @"id":@(14159), @"isSelect":@(false), @"str":@"ba"}], @"id":@(300), @"isSelect":@(false)}, @{@"name":@"稀土", @"subClass":@[@{@"name":@"稀土合金", @"subClass":@[], @"id":@(10399), @"isSelect":@(false), @"str":@""}, @{@"name":@"稀土化合物", @"subClass":@[], @"id":@(10398), @"isSelect":@(false), @"str":@""}, @{@"name":@"稀土金属", @"subClass":@[], @"id":@(10397), @"isSelect":@(false), @"str":@""}, @{@"name":@"稀土矿", @"subClass":@[], @"id":@(10396), @"isSelect":@(false), @"str":@""}, @{@"name":@"稀土制品", @"subClass":@[], @"id":@(10400), @"isSelect":@(false), @"str":@""}], @"id":@(400), @"isSelect":@(false)}, @{@"name":@"贵金属", @"subClass":@[@{@"name":@"金", @"subClass":@[], @"id":@(10643), @"isSelect":@(false), @"str":@"au"}, @{@"name":@"银", @"subClass":@[], @"id":@(10763), @"isSelect":@(false), @"str":@"ag"}, @{@"name":@"铂", @"subClass":@[], @"id":@(14027), @"isSelect":@(false), @"str":@"pt"}, @{@"name":@"钯", @"subClass":@[], @"id":@(13813), @"isSelect":@(false), @"str":@"pd"}, @{@"name":@"锇", @"subClass":@[], @"id":@(10897), @"isSelect":@(false), @"str":@"os"}, @{@"name":@"铑", @"subClass":@[], @"id":@(10790), @"isSelect":@(false), @"str":@"rh"}, @{@"name":@"钌", @"subClass":@[], @"id":@(13845), @"isSelect":@(false), @"str":@"ru"}, @{@"name":@"铱", @"subClass":@[], @"id":@(10429), @"isSelect":@(false), @"str":@"ir"}], @"id":@(500), @"isSelect":@(false)}, @{@"name":@"石墨", @"subClass":@[@{@"name":@"石墨碳素", @"subClass":@[], @"id":@(42344), @"isSelect":@(false), @"str":@"go"}], @"id":@(300), @"isSelect":@(false)}];
}
+ (NSArray *)supplyPurchaseAry {
    return @[@{@"name":@"全部", @"IDS":@"477,14981,13429,9847,13923,13487,11111,13889,10198,10099,10851,13685,13987,10114,14086,14083,13955,10477,10258,10395,42344", @"isSelect":@(false)}, @{@"name":@"铜", @"IDS":@"477", @"isSelect":@(false)}, @{@"name":@"铝", @"IDS":@"14981", @"isSelect":@(false)}, @{@"name":@"铅", @"IDS":@"13429", @"isSelect":@(false)}, @{@"name":@"锌", @"IDS":@"9847", @"isSelect":@(false)}, @{@"name":@"锡", @"IDS":@"13923", @"isSelect":@(false)}, @{@"name":@"镍", @"IDS":@"13487", @"isSelect":@(false)}, @{@"name":@"钨", @"IDS":@"11111", @"isSelect":@(false)}, @{@"name":@"钼", @"IDS":@"13889", @"isSelect":@(false)}, @{@"name":@"钒", @"IDS":@"10198", @"isSelect":@(false)}, @{@"name":@"钛", @"IDS":@"10099", @"isSelect":@(false)}, @{@"name":@"铬", @"IDS":@"10851", @"isSelect":@(false)}, @{@"name":@"锰", @"IDS":@"13685", @"isSelect":@(false)}, @{@"name":@"硅", @"IDS":@"13987", @"isSelect":@(false)}, @{@"name":@"钴锂", @"IDS":@"10114,14086", @"isSelect":@(false)}, @{@"name":@"镁", @"IDS":@"14083", @"isSelect":@(false)}, @{@"name":@"钽铌", @"IDS":@"13955,10477", @"isSelect":@(false)}, @{@"name":@"锆", @"IDS":@"10258", @"isSelect":@(false)}, @{@"name":@"稀土", @"IDS":@"10395", @"isSelect":@(false)}, @{@"name":@"石墨碳素", @"IDS":@"42344", @"isSelect":@(false)}];
}
+ (NSArray *)futureAry {
    return @[@{@"name":@"SHFE", @"dataAry":@[], @"id":@(4129), @"isSelect":@(true)}, @{@"name":@"LME", @"dataAry":@[], @"id":@(4127), @"isSelect":@(false)}, @{@"name":@"COMEX", @"dataAry":@[], @"id":@(4128), @"isSelect":@(false)}, @{@"name":@"NYMEX", @"dataAry":@[], @"id":@(8333), @"isSelect":@(false)}, @{@"name":@"TOCOM", @"dataAry":@[], @"id":@(6213), @"isSelect":@(false)}, @{@"name":@"郑商所", @"dataAry":@[], @"id":@(7377), @"isSelect":@(false)}, @{@"name":@"大商所", @"dataAry":@[], @"id":@(8782), @"isSelect":@(false)}];
}
+ (NSArray *)orgnizationAry {
    return @[@{@"name":@"无锡盘", @"dataAry":@[], @"id":@(10146), @"isSelect":@(true)}, @{@"name":@"欧洲战略", @"dataAry":@[], @"id":@(8330), @"isSelect":@(false)}, @{@"name":@"上海华通", @"dataAry":@[], @"id":@(4135), @"isSelect":@(false)}, @{@"name":@"中原有色", @"dataAry":@[], @"id":@(14097), @"isSelect":@(false)}, @{@"name":@"长江有色", @"dataAry":@[], @"id":@(4131), @"isSelect":@(false)}, @{@"name":@"上海物贸", @"dataAry":@[], @"id":@(4134), @"isSelect":@(false)}, @{@"name":@"南海灵通", @"dataAry":@[], @"id":@(6366), @"isSelect":@(false)}, @{@"name":@"广东南储", @"dataAry":@[], @"id":@(4137), @"isSelect":@(false)}, @{@"name":@"上海金交所", @"dataAry":@[], @"id":@(7942), @"isSelect":@(false)}, @{@"name":@"南方稀贵", @"dataAry":@[], @"id":@(8325), @"isSelect":@(false)}, @{@"name":@"庄信万丰", @"dataAry":@[], @"id":@(15166), @"isSelect":@(false)}, @{@"name":@"纽约贵金属现货", @"dataAry":@[], @"id":@(8329), @"isSelect":@(false)}, @{@"name":@"伦敦贵金属", @"dataAry":@[], @"id":@(8328), @"isSelect":@(false)}, @{@"name":@"贺利氏", @"dataAry":@[], @"id":@(15188), @"isSelect":@(false)}, @{@"name":@"巴斯夫", @"dataAry":@[], @"id":@(15189), @"isSelect":@(false)}];
}
+ (NSArray *)bidAry {
    return @[@{@"name":@"全部", @"IDS":@"000000", @"isSelect":@(false)}, @{@"name":@"钨", @"IDS":@"11111", @"isSelect":@(false)}, @{@"name":@"钼", @"IDS":@"13889", @"isSelect":@(false)}, @{@"name":@"钒", @"IDS":@"10198", @"isSelect":@(false)}, @{@"name":@"钛", @"IDS":@"10099", @"isSelect":@(false)}, @{@"name":@"铬", @"IDS":@"10851", @"isSelect":@(false)}, @{@"name":@"锰", @"IDS":@"13685", @"isSelect":@(false)}, @{@"name":@"硅", @"IDS":@"13987", @"isSelect":@(false)}, @{@"name":@"铌", @"IDS":@"10477", @"isSelect":@(false)}, @{@"name":@"铜", @"IDS":@"477", @"isSelect":@(false)}, @{@"name":@"铝", @"IDS":@"14981", @"isSelect":@(false)}, @{@"name":@"锡", @"IDS":@"13923", @"isSelect":@(false)}, @{@"name":@"镍", @"IDS":@"13487", @"isSelect":@(false)}, @{@"name":@"磷", @"IDS":@"10819", @"isSelect":@(false)}, @{@"name":@"钙", @"IDS":@"13976", @"isSelect":@(false)}, @{@"name":@"钡", @"IDS":@"14159", @"isSelect":@(false)}, @{@"name":@"硼", @"IDS":@"10136", @"isSelect":@(false)}, @{@"name":@"镁", @"IDS":@"14083", @"isSelect":@(false)}, @{@"name":@"钴", @"IDS":@"10114", @"isSelect":@(false)}, @{@"name":@"石墨碳素", @"IDS":@"42344", @"isSelect":@(false)}];
}

+ (instancetype)shareInstance {
    static Tool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[Tool alloc] init];
    });
    return tool;
}

+ (BOOL)isRightVersion {
    if (kValueForKey(kVersionStoreKey)) {
        if ([kValueForKey(kVersionStoreKey) isKindOfClass:[NSString class]]) {
            return ((NSString *)kValueForKey(kVersionStoreKey)).floatValue <= ((NSString *)kVersionKey).floatValue;
        } else {
            return true;
        }
    } else {
        return true;
    }
}
+ (void)saveUserPhone:(NSString *)phone {
    kSetValueForKey(phone, kPhone);
}
+ (NSString *)userPhone {
    return kValueForKey(kPhone) ? kValueForKey(kPhone) : kPhone;
}
+ (void)saveUserPassword:(NSString *)password {
    kSetValueForKey(password, kPassword);
}
+ (NSString *)userPassword {
    return kValueForKey(kPassword) ? kValueForKey(kPassword) : kPassword;
}
+ (void)saveUserInfo:(UserM *)model {
    kSetValueForKey([model mj_JSONString], model.ID);
    kSetValueForKey(model.ID, kUser);
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeUserLogIn object:nil];
}
+ (void)logOut {
    kRemoveValueForKey(kUser);
    [Tool shareInstance].user = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeUserLogOut object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeUserUpdate object:nil];
}

+ (NSArray *)priceClassIDAry {
    if (kValueForKey(kPriceClass)) {
        NSMutableArray *ary = [kValueForKey(kPriceClass) componentsSeparatedByString:@","].mutableCopy;
        NSMutableArray *oAry = @[].mutableCopy;
        for (NSString *str in ary) {
            if (![oAry containsObject:str]) {
                [oAry addObject:str];
            } else {
                if ([str isEqualToString:@"13923"]) {
                    if (![oAry containsObject:@"10477"]) {
                        [oAry addObject:@"10477"];
                    }
                }
            }
        }
        kSetValueForKey([oAry componentsJoinedByString:@","], kPriceClass);
        return [kValueForKey(kPriceClass) componentsSeparatedByString:@","];
    } else {
        return @[];
    }
}

+ (void)setPriceClassIDAry:(NSArray<PriceClassM *> *)ary {
    NSMutableArray *tempAry = @[].mutableCopy;
    for (PriceClassM *model in ary) {
        [tempAry addObject:@(model.ID).stringValue];
    }
    kSetValueForKey([tempAry componentsJoinedByString:@","], kPriceClass);
}

+ (NSString *)strWithPriceID:(NSInteger)ID {
    NSArray *ary = [self metalAry];
    NSMutableArray *mutAry = @[].mutableCopy;
    for (NSDictionary *dic in ary) {
        [mutAry addObjectsFromArray:dic[@"subClass"]];
    }
    NSString *str = @"";
    for (NSDictionary *dic in mutAry) {
        if ([dic[@"id"] integerValue] == ID) {
            str = dic[@"str"];
            break;
        }
    }
    return str;
}

+ (NSString *)bjjgNameStringWithID:(NSInteger)ID isFutures:(BOOL)isFutures {
    NSString *name = @"";
    if (isFutures) {
        switch (ID) {
            case 4129:
                name = @"SHFE";
                break;
            case 4127:
                name = @"LME";
                break;
            case 4128:
                name = @"COMEX";
                break;
            case 8333:
                name = @"NYMEX";
                break;
            case 6213:
                name = @"TOCOM";
                break;
            case 7377:
                name = @"郑商所";
                break;
            case 8782:
                name = @"大商所";
                break;
            default:
                break;
        }
    } else {
        switch (ID) {
            case 10146:
                name = @"无锡盘";
                break;
            case 8330:
                name = @"欧洲战略";
                break;
            case 4135:
                name = @"上海华通";
                break;
            case 14097:
                name = @"中原有色";
                break;
            case 4131:
                name = @"长江有色";
                break;
            case 4134:
                name = @"上海物贸";
                break;
            case 6366:
                name = @"南海灵通";
                break;
            case 4137:
                name = @"广东南储";
                break;
            case 7942:
                name = @"上海金交所";
                break;
            case 8325:
                name = @"南方稀贵";
                break;
            case 15166:
                name = @"庄信万丰";
                break;
            case 8329:
                name = @"纽约贵金属现货";
                break;
            case 8328:
                name = @"伦敦贵金属";
                break;
            case 15188:
                name = @"贺利氏";
                break;
            case 15189:
                name = @"巴斯夫";
                break;
            default:
                break;
        }
    }
    return name;
}

+ (NSString *)bjjgIdStringWithID:(NSInteger)ID isFutures:(BOOL)isFutures {
    NSString *str = [self strWithPriceID:ID];
    if (isFutures) {
        if ([str isEqualToString:@"pt"]) {
            return @"8333,6213";
        } else if ([str isEqualToString:@"co"]) {
            return @"4127";
        } else if ([str isEqualToString:@"si"]) {
            return @"7377";
        } else if ([str isEqualToString:@"au"]) {
            return @"4128,4129,6213,4127";
        } else if ([str isEqualToString:@"al"]) {
            return @"4129,4127";
        } else if ([str isEqualToString:@"mo"]) {
            return @"4127";
        } else if ([str isEqualToString:@"ni"]) {
            return @"4129,4127";
        } else if ([str isEqualToString:@"pd"]) {
            return @"8333,6213";
        } else if ([str isEqualToString:@"pb"]) {
            return @"4129,4127";
        } else if ([str isEqualToString:@"cu"]) {
            return @"4129,4128,4127";
        } else if ([str isEqualToString:@"sn"]) {
            return @"4129,4127";
        } else if ([str isEqualToString:@"zn"]) {
            return @"4129,4127";
        } else if ([str isEqualToString:@"ag"]) {
            return @"4128,4129,6213,4127";
        } else {
            return @"";
        }
    } else {
        if ([str isEqualToString:@"bi"]) {
            return @"8325,8330";
        } else if ([str isEqualToString:@"pt"]) {
            return @"7942,8325,15166,8329,8328,15188,15189";
        } else if ([str isEqualToString:@"te"]) {
            return @"8325";
        } else if ([str isEqualToString:@"v"]) {
            return @"8330";
        } else if ([str isEqualToString:@"cd"]) {
            return @"8330";
        } else if ([str isEqualToString:@"cr"]) {
            return @"8330,4131";
        } else if ([str isEqualToString:@"co"]) {
            return @"10146,8330,4131,4137";
        } else if ([str isEqualToString:@"si"]) {
            return @"8330,4131";
        } else if ([str isEqualToString:@"ga"]) {
            return @"8330";
        } else if ([str isEqualToString:@"au"]) {
            return @"7942,8329,8328,15188,15189";
        } else if ([str isEqualToString:@"rh"]) {
            return @"4135,8325,8330,15166,8329,15188,15189";
        } else if ([str isEqualToString:@"ru"]) {
            return @"4135,8330,15166,15188,15189";
        } else if ([str isEqualToString:@"al"]) {
            return @"4135,14097,4131,4134,6366,4137";
        } else if ([str isEqualToString:@"mg"]) {
            return @"8330,4131";
        } else if ([str isEqualToString:@"mn"]) {
            return @"8330,4131";
        } else if ([str isEqualToString:@"mo"]) {
            return @"8330";
        } else if ([str isEqualToString:@"ni"]) {
            return @"4135,14097,4131,4134,10146,4137";
        } else if ([str isEqualToString:@"pd"]) {
            return @"4135,4131,8325,15166,8329,8328,15188,15189";
        } else if ([str isEqualToString:@"pb"]) {
            return @"4135,14097,4131,4134,4137";
        } else if ([str isEqualToString:@"as"]) {
            return @"8330";
        } else if ([str isEqualToString:@"ti"]) {
            return @"8330";
        } else if ([str isEqualToString:@"ta"]) {
            return @"8330";
        } else if ([str isEqualToString:@"sb"]) {
            return @"4131,8325,8330";
        } else if ([str isEqualToString:@"cu"]) {
            return @"4135,14097,4131,4134,6366,4137";
        } else if ([str isEqualToString:@"w"]) {
            return @"8325,8330";
        } else if ([str isEqualToString:@"se"]) {
            return @"8330";
        } else if ([str isEqualToString:@"ree"]) {
            return @"8325";
        } else if ([str isEqualToString:@"sn"]) {
            return @"4135,4131,4134,4137,10146,8325";
        } else if ([str isEqualToString:@"zn"]) {
            return @"4135,14097,4131,4134,4137,6366";
        } else if ([str isEqualToString:@"ir"]) {
            return @"4135,8330,15166,15188,15189";
        } else if ([str isEqualToString:@"in"]) {
            return @"10146,8325,8330";
        } else if ([str isEqualToString:@"ag"]) {
            return @"4131,7942,8325,4135,8329,8328,15188,15189";
        } else if ([str isEqualToString:@"ge"]) {
            return @"8330";
        } else {
            return @"";
        }
    }
}

+ (NSString *)updateMarkTypeStringWithID:(NSInteger)ID isFutures:(BOOL)isFutures {
    NSString *str = [self strWithPriceID:ID];
    if (isFutures) {
        if ([str isEqualToString:@"pt"]) {
            return @"1";
        } else if ([str isEqualToString:@"co"]) {
            return @"12";
        } else if ([str isEqualToString:@"si"]) {
            return @"1";
        } else if ([str isEqualToString:@"au"]) {
            return @"1,17";
        } else if ([str isEqualToString:@"al"]) {
            return @"1,12";
        } else if ([str isEqualToString:@"mo"]) {
            return @"12";
        } else if ([str isEqualToString:@"ni"]) {
            return @"1,12";
        } else if ([str isEqualToString:@"pd"]) {
            return @"1";
        } else if ([str isEqualToString:@"pb"]) {
            return @"1,12";
        } else if ([str isEqualToString:@"cu"]) {
            return @"1,12";
        } else if ([str isEqualToString:@"sn"]) {
            return @"1,12";
        } else if ([str isEqualToString:@"zn"]) {
            return @"1,12";
        } else if ([str isEqualToString:@"ag"]) {
            return @"1,17";
        } else {
            return @"";
        }
    } else {
        if ([str isEqualToString:@"bi"]) {
            return @"5,13";
        } else if ([str isEqualToString:@"pt"]) {
            return @"13,15,16,17,14";
        } else if ([str isEqualToString:@"te"]) {
            return @"13";
        } else if ([str isEqualToString:@"v"]) {
            return @"5";
        } else if ([str isEqualToString:@"cd"]) {
            return @"5";
        } else if ([str isEqualToString:@"cr"]) {
            return @"5,16";
        } else if ([str isEqualToString:@"co"]) {
            return @"5,16";
        } else if ([str isEqualToString:@"si"]) {
            return @"5,16";
        } else if ([str isEqualToString:@"ga"]) {
            return @"5";
        } else if ([str isEqualToString:@"au"]) {
            return @"15,17,14,16";
        } else if ([str isEqualToString:@"rh"]) {
            return @"5,13,14,16";
        } else if ([str isEqualToString:@"ru"]) {
            return @"5,16";
        } else if ([str isEqualToString:@"al"]) {
            return @"16";
        } else if ([str isEqualToString:@"mg"]) {
            return @"5,16";
        } else if ([str isEqualToString:@"mn"]) {
            return @"5,16";
        } else if ([str isEqualToString:@"mo"]) {
            return @"5";
        } else if ([str isEqualToString:@"ni"]) {
            return @"16";
        } else if ([str isEqualToString:@"pd"]) {
            return @"13,16,17,14";
        } else if ([str isEqualToString:@"pb"]) {
            return @"16";
        } else if ([str isEqualToString:@"as"]) {
            return @"5";
        } else if ([str isEqualToString:@"ti"]) {
            return @"5";
        } else if ([str isEqualToString:@"ta"]) {
            return @"5";
        } else if ([str isEqualToString:@"sb"]) {
            return @"5,13,16";
        } else if ([str isEqualToString:@"cu"]) {
            return @"16";
        } else if ([str isEqualToString:@"w"]) {
            return @"5,13";
        } else if ([str isEqualToString:@"se"]) {
            return @"5";
        } else if ([str isEqualToString:@"ree"]) {
            return @"13";
        } else if ([str isEqualToString:@"sn"]) {
            return @"16,13";
        } else if ([str isEqualToString:@"zn"]) {
            return @"16";
        } else if ([str isEqualToString:@"ir"]) {
            return @"5,16";
        } else if ([str isEqualToString:@"in"]) {
            return @"5,13,16";
        } else if ([str isEqualToString:@"ag"]) {
            return @"11,16,15,17,13,14";
        } else if ([str isEqualToString:@"ge"]) {
            return @"5";
        } else {
            return @"";
        }
    }
}

+ (NSArray *)newsClassIDAry {
    if (kValueForKey(kNewsClass)) {
        NSMutableArray *ary = [kValueForKey(kNewsClass) componentsSeparatedByString:@","].mutableCopy;
        NSMutableArray *oAry = @[].mutableCopy;
        for (NSString *str in ary) {
            if (![oAry containsObject:str]) {
                [oAry addObject:str];
            } else {
                if ([str isEqualToString:@"13923"]) {
                    if (![oAry containsObject:@"10477"]) {
                        [oAry addObject:@"10477"];
                    }
                }
            }
        }
        kSetValueForKey([oAry componentsJoinedByString:@","], kNewsClass);
        return [kValueForKey(kNewsClass) componentsSeparatedByString:@","];
    } else {
        return @[];
    }
}
+ (void)setNewsClassIDAry:(NSArray<NSString *> *)ary {
    NSMutableArray *tempAry = @[].mutableCopy;
    for (NewsClassM *model in ary) {
        [tempAry addObject:@(model.ID).stringValue];
    }
    kSetValueForKey([tempAry componentsJoinedByString:@","], kNewsClass);
}

+ (NSArray *)newsClassAnalyseIDAry {
    if (kValueForKey(kNewsClassAnalyse)) {
        NSMutableArray *ary = [kValueForKey(kNewsClassAnalyse) componentsSeparatedByString:@","].mutableCopy;
        NSMutableArray *oAry = @[].mutableCopy;
        for (NSString *str in ary) {
            if (![oAry containsObject:str]) {
                [oAry addObject:str];
            } else {
                if ([str isEqualToString:@"13923"]) {
                    if (![oAry containsObject:@"10477"]) {
                        [oAry addObject:@"10477"];
                    }
                }
            }
        }
        kSetValueForKey([oAry componentsJoinedByString:@","], kNewsClassAnalyse);
        return [kValueForKey(kNewsClassAnalyse) componentsSeparatedByString:@","];
    } else {
        return @[];
    }
}
+ (void)setNewsClassAnalyseIDAry:(NSArray<NSString *> *)ary {
    NSMutableArray *tempAry = @[].mutableCopy;
    for (NewsClassM *model in ary) {
        [tempAry addObject:@(model.ID).stringValue];
    }
    kSetValueForKey([tempAry componentsJoinedByString:@","], kNewsClassAnalyse);
}

+ (NSArray *)newsClassSortAry {
    if (kValueForKey(kNewsClassSort)) {
        return [kValueForKey(kNewsClassSort) componentsSeparatedByString:@","];
    } else {
        return @[];
    }
}

+ (void)setNewsClassSortAry:(NSArray<NSString *> *)ary {
    if (ary.count) {
        kSetValueForKey([ary componentsJoinedByString:@","], kNewsClassSort);
    }
}

#pragma mark NetRequest
+ (nullable NSMutableString *)soapInvokeWithParams:(NSArray *)params method:(NSString *)method {
    NSMutableString * post = [[NSMutableString alloc ] init];
    [post appendString:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
     "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\""
     " xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\""
     " xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n"
     "<soap:Body>\n" ];
    [post appendString:@"<"];
    [post appendString:method];
    [post appendString:[NSString stringWithFormat:@" xmlns=\"%@\">\n", XMLNS]];
    for (NSDictionary *dict in params) {
        NSString *value = nil;
        NSString *key = [[dict keyEnumerator] nextObject];
        if (key != nil) {
            value = [dict valueForKey:key];
            [post appendString:@"<"];
            [post appendString:key];
            [post appendString:@">"];
            if(value != nil) {
                [post appendString:value];
            } else {
                [post appendString:@""];
            }
            [post appendString:@"</"];
            [post appendString:key];
            [post appendString:@">\n"];
        }
    }
    [post appendString:@"</"];
    [post appendString:method];
    [post appendString:@">\n"];
    [post appendString:@"</soap:Body>\n""</soap:Envelope>\n"];
    return post;
}
+ (void)POST:(NSString *)api params:(NSArray *)params progress:(void (^)(NSProgress *progress))uploadProgress success:(void (^)(NSDictionary *result))success failure:(void (^)(NSString *error))failure {
    NSLog(@"POST:\n%@", api);
    NSLog(@"param:\n%@", params);
    NSString *soapStr = [self soapInvokeWithParams:params method:api];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%zd", soapStr.length] forHTTPHeaderField:@"Content-Length"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"CBCWEB/%@", api] forHTTPHeaderField:@"SOAPAction"];
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return soapStr;
    }];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:BASE_URL parameters:soapStr headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@", result);
        if (result) {
            NSString *pattern = [NSString stringWithFormat:@"(?<=%@Result\\>).*(?=</%@Result)", api, api];
            NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
            NSDictionary *dict = [NSDictionary dictionary];
            for (NSTextCheckingResult *checkingResult in [regular matchesInString:result options:0 range:NSMakeRange(0, result.length)]) {
                dict = [NSJSONSerialization JSONObjectWithData:[[result substringWithRange:checkingResult.range] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
            }
            NSLog(@"response:\n%@", dict);
            if (success) {
                success(dict);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:\n%@", error);
        if (failure) {
            failure([NSString stringWithFormat:@"%@", error.userInfo]);
        }
    }];
}

+ (void)cancelAllRequest {
    if ([Tool shareInstance].downloadTask) {
        [[Tool shareInstance].downloadTask cancel];
        [Tool shareInstance].downloadTask = nil;
    }
}

#pragma mark HUD
+ (void)showStatusLight:(NSString *)status {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD setMaximumDismissTimeInterval:2];
    [SVProgressHUD showImage:kImage(@" ") status:status];
}
+ (void)showLongStatusLight:(NSString *)status {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:60];
    [SVProgressHUD setMaximumDismissTimeInterval:60];
    [SVProgressHUD showImage:kImage(@" ") status:status];
}

+ (void)showStatusDark:(NSString *)status {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD setMaximumDismissTimeInterval:2];
    [SVProgressHUD showImage:kImage(@" ") status:status];
}
+ (void)showLongStatusDark:(NSString *)status {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:60];
    [SVProgressHUD setMaximumDismissTimeInterval:60];
    [SVProgressHUD showImage:kImage(@" ") status:status];
}
+ (void)showLongLongStatusDark:(NSString *)status {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:6000];
    [SVProgressHUD setMaximumDismissTimeInterval:6000];
    [SVProgressHUD showImage:kImage(@" ") status:status];
}
+ (void)showProgressDark {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:60];
    [SVProgressHUD setMaximumDismissTimeInterval:60];
    [SVProgressHUD show];
}
+ (void)showProgressStatusDark:(NSString *)status {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setMinimumDismissTimeInterval:60];
    [SVProgressHUD setMaximumDismissTimeInterval:60];
    [SVProgressHUD showWithStatus:status];
}
+ (void)showSuccessStatusDark:(NSString *)status {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setMaximumDismissTimeInterval:1];
    [SVProgressHUD showSuccessWithStatus:status];
}
+ (void)showProgress:(CGFloat)progress status:(NSString *)status {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setMinimumDismissTimeInterval:60];
    [SVProgressHUD setMaximumDismissTimeInterval:60];
    [SVProgressHUD showProgress:progress status:status];
}

+ (void)dismiss {
    [SVProgressHUD dismiss];
}

#pragma mark FormatCheck
+ (BOOL)isPhoneNumber:(NSString *)patternStr {
    NSString *pattern = @"^[1]([3-9])[0-9]{9}$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
//    return [patternStr isEqualToString:@"11166668888"];
}

+ (BOOL)detectionIsEmailQualified:(NSString *)patternStr {
    NSString *pattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+ (BOOL)detectionIsIdCardNumberQualified:(NSString *)patternStr {
    NSString *pattern = @"^\\d{15}|\\d{18}$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+ (BOOL)detectionIsPasswordQualified:(NSString *)patternStr {
    NSString *pattern = @"^[a-zA-Z]\\w.{5,17}$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+ (BOOL)detectionIsIPAddress:(NSString *)patternStr {
    NSString *pattern = @"((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+ (BOOL)detectionIsAllNumber:(NSString *)patternStr {
    NSString *pattern = @"^[0-9]*$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+ (BOOL)detectionIsEnglishAlphabet:(NSString *)patternStr {
    NSString *pattern = @"^[A-Za-z]+$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+ (BOOL)detectionIsUrl:(NSString *)patternStr {
    NSString *pattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+ (BOOL)detectionIsChinese:(NSString *)patternStr {
    NSString *pattern = @"[\u4e00-\u9fa5]+";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+ (BOOL)detectionNormalText:(NSString *)normalStr WithHighLightText:(NSString *)HighLightStr {
    NSString *pattern = [NSString stringWithFormat:@"%@",HighLightStr];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:normalStr options:0 range:NSMakeRange(0, normalStr.length)];
    return results.count > 0;
}

#pragma mark Time
+ (NSString *)updateTimeForRow:(double)time {
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = time / 1000;
    // 时间差
    NSTimeInterval timeD = currentTime - createTime;
    
    NSInteger sec = timeD/60;
    if (sec<60) {
        return [NSString stringWithFormat:@"%@分钟前", @(sec).stringValue];
    }
    // 秒转小时
    NSInteger hours = timeD/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%@小时前", @(hours).stringValue];
    }
    //秒转天数
    NSInteger days = timeD/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%@天前", @(days).stringValue];
    }
    //秒转月
    NSInteger months = timeD/3600/24/30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%@月前", @(months).stringValue];
    }
    //秒转年
    NSInteger years = timeD/3600/24/30/12;
    return [NSString stringWithFormat:@"%@年前", @(years).stringValue];
}

+ (NSString *)time:(double)time withFormatter:(nonnull NSString *)formatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
}

+ (NSString *)countDownTime:(double)time {
    NSInteger countTime = [NSString stringWithFormat:@"%.f", ((time + 24 * 3600 * 1000) - [NSDate date].timeIntervalSince1970 * 1000) / 1000].integerValue;
    NSInteger h = countTime / 3600;
    NSInteger m = countTime / 60 % 60;
    NSInteger s = countTime % 60;
    return [NSString stringWithFormat:@"%@:%@:%@", h < 10 ? [NSString stringWithFormat:@"0%@", @(h).stringValue] : @(h).stringValue, m < 10 ? [NSString stringWithFormat:@"0%@", @(m).stringValue] : @(m).stringValue, s < 10 ? [NSString stringWithFormat:@"0%@", @(s).stringValue] : @(s).stringValue];
}


#pragma mark String
+ (CGFloat)widthForString:(NSString *)string font:(UIFont *)font {
    return [string boundingRectWithSize:CGSizeMake(10000, 100) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.width;
}
+ (CGFloat)widthForString:(NSString *)string height:(CGFloat)height font:(UIFont *)font {
    return [string boundingRectWithSize:CGSizeMake(10000, height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.width;
}
+ (CGFloat)heightForString:(NSString *)string font:(UIFont *)font {
    return [string boundingRectWithSize:CGSizeMake(100, 10000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.height;
}
+ (CGFloat)heightForString:(NSString *)string width:(CGFloat)width font:(UIFont *)font {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    return [string boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle} context:nil].size.height;
}

+ (UIColor *)hexColor:(NSString *)hexColor alpha:(CGFloat)alpha {
    if (hexColor == nil) {
        return nil;
    }
    
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}
+ (void)removeCacheFile:(NSString*)filePath {
    NSError * error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath] == YES) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    }
}

+ (NSString *)numberTranslat:(NSInteger)number {
    if (number > 1000 && number < 10000000) {
        return [NSString stringWithFormat:@"%.1f万", number / 10000.0f];
    } else if (number >= 10000000) {
        return [NSString stringWithFormat:@"%.1f亿", number / 100000000.0f];
    }
    return @(number).stringValue;
}

+ (NSAttributedString *)htmlTranslat:(NSString *)htmlString font:(nonnull UIFont *)font {
    NSAttributedString *attString = [[NSAttributedString alloc] initWithData:[[htmlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    NSArray<NSString *> *ary = [attString.string componentsSeparatedByString:@"<sub>"];
    NSMutableArray<NSDictionary *> *indexAry = @[].mutableCopy;
    NSInteger index = 0;
    for (NSInteger i = 0; i < ary.count; i ++) {
        NSString *subString = ary[i];
        NSArray<NSString *> *subAry = [subString componentsSeparatedByString:@"</sub>"];
        if (subAry.count == 2) {
            [indexAry addObject:@{@(index).stringValue:@(subAry[0].length).stringValue}];
        }
        subString = [subString stringByReplacingOccurrencesOfString:@"</sub>" withString:@""];
        index += subString.length;
    }
    NSString *string = [attString.string stringByReplacingOccurrencesOfString:@"<sub>" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"</sub>" withString:@""];
    NSMutableAttributedString *mattrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [mattrString addAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, mattrString.length)];
    for (NSDictionary *dic in indexAry) {
        NSInteger index = ((NSString *)dic.allKeys[0]).integerValue;
        NSInteger length = ((NSString *)dic[dic.allKeys[0]]).integerValue;
        [mattrString addAttributes:@{NSBaselineOffsetAttributeName:@(-(font.pointSize / 17 * 4)), NSFontAttributeName:[UIFont systemFontOfSize:font.pointSize / 17 * 12]} range:NSMakeRange(index, length)];
    }
    return mattrString.copy;
}

+ (NSArray<UIImage *> *)imagesIsSingle:(BOOL)isSingle isDetails:(BOOL)isDetails {
    Tool *tool = [self shareInstance];
    if (!tool.singleDetailsImgAry) {
        NSMutableArray *ary = @[].mutableCopy;
        for (NSInteger i = 0; i < 11; i ++) {
            NSString *imgName = [NSString stringWithFormat:@"%@%@", i == 10 ? @"price_title_single_details_" : @"price_title_single_details_0", @(i).stringValue];
            [ary addObject:kImage(imgName)];
        }
        tool.singleDetailsImgAry = ary.copy;
    }
    if (!tool.singleUnDetailsImgAry) {
        NSMutableArray *ary = @[].mutableCopy;
        for (NSInteger i = 10; i >= 0; i --) {
            NSString *imgName = [NSString stringWithFormat:@"%@%@", i == 10 ? @"price_title_single_details_" : @"price_title_single_details_0", @(i).stringValue];
            [ary addObject:kImage(imgName)];
        }
        tool.singleUnDetailsImgAry = ary.copy;
    }
    if (!tool.doubleDetailsImgAry) {
        NSMutableArray *ary = @[].mutableCopy;
        for (NSInteger i = 0; i < 11; i ++) {
            NSString *imgName = [NSString stringWithFormat:@"%@%@", i == 10 ? @"price_title_double_details_" : @"price_title_double_details_0", @(i).stringValue];
            [ary addObject:kImage(imgName)];
        }
        tool.doubleDetailsImgAry = ary.copy;
    }
    if (!tool.doubleUnDetailsImgAry) {
        NSMutableArray *ary = @[].mutableCopy;
        for (NSInteger i = 10; i >= 0; i --) {
            NSString *imgName = [NSString stringWithFormat:@"%@%@", i == 10 ? @"price_title_double_details_" : @"price_title_double_details_0", @(i).stringValue];
            [ary addObject:kImage(imgName)];
        }
        tool.doubleUnDetailsImgAry = ary.copy;
    }
    if (isSingle) {
        return isDetails ? tool.singleDetailsImgAry : tool.singleUnDetailsImgAry;
    } else {
        return isDetails ? tool.doubleDetailsImgAry : tool.doubleUnDetailsImgAry;
    }
}

+ (NSString *)transPrice:(NSString *)price {
    return [price containsString:@"."] ? [NSString stringWithFormat:@"%.2f", price.floatValue] : price;
}

+ (NSString *)decryptString:(NSString *)str {
    return [RSA decryptString:str privateKey:@"-----BEGIN RSA PRIVATE KEY-----\nMIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAOy4vWdgBespNpLVTyarjVALlLS06z3DOPWbpFc1xX70DPc9gFgJdcY92T8W1RPd+uhAYOMYaFa4mSxtmTuQ79cNEBBaQzTM8cfgVgqiPmTOaCf/JUXX2mcb+i1Hq84HtFgpZjfNKB6Eu0yapr4OJP/HgAyznEWxmxgPQRWzbAWrAgMBAAECgYEA0yB1dQSUYseQL+dlv7STxYd+qqkNgjlizNNzAIEp0u+xvLUyidJuI1A4OWeQxTZfONNqVkEHlgjwPErHtvOuo+SY5W24SMLKRvxaDfkHc6W60aSnYxrPTIAN5tBA2D474b1/ehwrhCkfWlHtdJ78JqMP0oD22/5Med3NztxDBRkCQQD2/KqsOjwUgIR97j2iDoPUs3dwDfmJaO3GKJaDwB8N09GRvZ9GvoIKFK9ncg8bToR3kcwlAHE0Ft5GLmYRWyxNAkEA9Vws114tX5PQ4daO+7jjHKdxmAINkxgHlUnAgOdFW78A3CBE+o5Y1wxC7ZPlfwweGyp9FOKuZQge6z2hf9WV1wJBAN6ZllEnIyLvOXouEEpQfqxjG1BYqAAaG8KurgkMTHCv6X9KwZSG+riPMA8xkz/vIiCJvM3UejKSMb5a7w7RdzkCQQCAMV2YVLM+KZvMMu7Xo/y9HtshwYjYHojvve3fK3Y4fi3z1MRVaIQQL27UdB5G58zfAq8Bd4IIdVq6K6QyhyRXAkBC58L7SXFZhKnHoHlYu1ANf9+BjR7oKnU0uk2/ZUyXvlOeBCR16mvzcSvp6V+xmY098dXhfziXu6kdryDUERNq\n-----END RSA PRIVATE KEY-----"];
}

+ (NSString *)transYear:(NSString *)year {
    if (year.integerValue - 1 >=0 && year.integerValue - 1 <=9) {
        return @[@"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十"][year.integerValue - 1];
    } else {
        return @"";;
    }
}

+ (void)getAdImg {
    [Tool POST:ADINFO params:@[@{@"pass":PASS}] progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSDictionary * _Nonnull result) {
        if ([result[@"app_ad_info"] isKindOfClass:[NSArray class]]) {
            ADM *adM = [ADM mj_objectArrayWithKeyValuesArray:result[@"app_ad_info"]].firstObject;
            NSString *pic = @"";
            if (kScreenH / kScreenW == 2688 / 1242.0) {
                pic = adM.pic_2688;
            } else {
                pic = adM.pic_2208;
            }
            BOOL shouldDownload = false;
            if (kValueForKey(kADPicKey)) {
                if (![kValueForKey(kADPicKey) isEqualToString:pic]) {
                    shouldDownload = true;
                }
            } else {
                shouldDownload = true;
            }
            NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", [kValueForKey(kADPicKey) componentsSeparatedByString:@"/"].lastObject]];
            BOOL isDir = NO;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
                shouldDownload = true;
            }
            if (shouldDownload) {
                SDWebImageManager *manager = [SDWebImageManager sharedManager] ;
                [manager loadImageWithURL:[NSURL URLWithString:pic] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    NSLog(@"downAdSuccess");
                    kSetValueForKey(adM.linkurl, kADLinkKey);
                    kSetValueForKey(adM.showtime, kADDownKey);
                    kSetValueForKey(pic, kADPicKey);
                    [UIImageJPEGRepresentation(image,1.0) writeToFile:path atomically:true];
                }];
            } else {
                kSetValueForKey(adM.linkurl, kADLinkKey);
                kSetValueForKey(adM.showtime, kADDownKey);
            }
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
}

+ (NSString *)transFloat:(NSString *)string digits:(NSInteger)digits usesGroupingSeparator:(BOOL)usesGroupingSeparator {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.usesGroupingSeparator =
    formatter.maximumFractionDigits = digits;
    return [formatter stringFromNumber:@(string.floatValue)];
}

@end
