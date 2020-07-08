#ifndef Api_h
#define Api_h

//https://api.xydaxympt.com/api/v1/content/detail?uuid=72604a888e9a11e9bc8000163e046721
//https://api.xydaxympt.com/api/v1/content/list?pagenum=1&pagesize=10

#define PROTOCOL_USER @"https://www.xydaxympt.com/charity-sale-h5/user.html"
#define PROTOCOL_SECRET @"https://www.xydaxympt.com/charity-sale-h5/personal.html"
#define WXAUTH @"https://api.weixin.qq.com/sns/oauth2/access_token"
#define WXINFO @"https://api.weixin.qq.com/sns/userinfo"

#define BASE_URL @"http://cs.cbcie.com/app/app.asmx"
//#define BASE_URL @"http://192.168.0.181:9090/api/v1/"
#define PAY_URL @"https://pay.xydaxympt.com/"
//#define PAY_URL @"http://192.168.0.181:7070/"
#define ADDURL(url1, url2) [NSString stringWithFormat:@"%@%@", url1, url2]

#define NEWSURL(ID, VIPID) [NSString stringWithFormat:@"http://cs.cbcie.com/app/news.aspx?webid=%@&vipid=%@", ID, VIPID]
#define SUPPLYPURCHASEURL(ID, VIPID) [NSString stringWithFormat:@"http://cs.cbcie.com/app/mallinfo_show.aspx?id=%@&vipid=%@", ID, VIPID]
#define DISTRIBUTIONURL(ID) [NSString stringWithFormat:@"http://cs.cbcie.com/app/mallinfo_vip.aspx?id=%@", ID]
#define SHARESURL(ID) [NSString stringWithFormat:@"http://www.cbcie.com/m/news/%@.html", ID]
#define PASS @"cbcieapp12453fgdfg546867adflopq0225"
#define XMLNS @"CBCWEB"


#define ADINFO @"Get_APP_ADinfo"
#define VERSION @"Get_IOS_Edition"
#define TOKEN @"Vip_Login_Token_Check"

#define LOGIN @"VipLogin"
#define REGISTER @"Vip_Reg"
#define SENDCODE @"Vip_Reg_smscode"

#define JURISDICATION @"Vip_view_qxstate"
#define VIEWLOG @"Vip_view_log"

#define SUBPRICE @"SelectAreaProduct"
#define STOPRICE @"SelectPriceList_Area"
#define ENTPRICE @"SelectPriceList_ccj"
#define BIDPRICE @"SelectPriceList_cgj"
#define FOPRICE @"SelectPriceList_qhjg"

#define PRICEINFO @"SelectChart_paraminfo"
#define PRICELINE @"SelectChart_chartlist"
#define PRICELIST @"SelectChart_pricelist"

#define NEWS @"SelectNewList"

#define ORDERVIPCONTENTINFO @"Get_VIP_hyqy"
#define ORDERVIPINFO @"Get_APP_qxinfo"
#define ORDERADD @"Vip_Add_App_Order"
#define ORDERLIST @"SelectOrderList"
#define ORDERINFO @"Vip_Orderdeals_Detail_Only"
#define ORDERPAYINFO @"GetWxPayinfo"

#define DISTRIBUTIONADD @"MallInfo_Submit"
#define DISTRIBUTIONMY @"SelectList_MallVip"
#define DISTRIBUTIONDEL @"DeleteMallinfo"
#define DISTRIBUTIONREV @"UpdateMallinfo"
#define DISTRIBUTIONREA @"SelectOnlyMallinfo"

#define SUPPLYPURCHASE @"SelectList_MallWeb"

#endif /* Api_h */
