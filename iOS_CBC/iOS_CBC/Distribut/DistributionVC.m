//
//  DistributionVC.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/25.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "DistributionVC.h"
#import "DistributionClassV.h"
#import "DistributionTableCell.h"
#import "DistributionDetailsVC.h"

@interface DistributionVC () <UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *distributionAddTitleLab;
@property (weak, nonatomic) IBOutlet UIView *distributionAddLineV;
@property (weak, nonatomic) IBOutlet UILabel *distributionMyTitleLab;
@property (weak, nonatomic) IBOutlet UIView *distributionMyLineV;
@property (nonatomic, assign) NSInteger pageIndex;

@property (weak, nonatomic) IBOutlet UIImageView *supplyImgV;
@property (weak, nonatomic) IBOutlet UIImageView *purchaseImgV;
@property (nonatomic, assign) DistributionType type;

@property (weak, nonatomic) IBOutlet UITextField *titleTF;

@property (weak, nonatomic) IBOutlet UILabel *classLab;
@property (weak, nonatomic) IBOutlet UILabel *subClassLab;
@property (nonatomic, strong) DistributionClassV *distributionClassV;
@property (nonatomic, assign) NSInteger classID;

@property (weak, nonatomic) IBOutlet UITextField *modelTF;
@property (weak, nonatomic) IBOutlet UITextField *countTF;
@property (weak, nonatomic) IBOutlet UITextField *priceDesTF;
@property (weak, nonatomic) IBOutlet UITextField *tradePlaceTF;

@property (weak, nonatomic) IBOutlet UITextView *contentTextV;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLab;

@property (weak, nonatomic) IBOutlet UIView *myV;
@property (weak, nonatomic) IBOutlet UIScrollView *addV;
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UIView *titleV;

@property (nonatomic, assign) NSInteger distributionID;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray<DistributionM *> *dataAry;
@property (nonatomic, assign) CGFloat baseTVHeight;

@property (nonatomic, strong) NSMutableArray<NSString *> *selectAry;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgV;

@end

@implementation DistributionVC

- (NSMutableArray<NSString *> *)selectAry {
    if (!_selectAry) {
        _selectAry = @[].mutableCopy;
    }
    return _selectAry;
}

- (DistributionClassV *)distributionClassV {
    if (!_distributionClassV) {
        _distributionClassV = [[NSBundle mainBundle] loadNibNamed:@"DistributionClassV" owner:nil options:nil].firstObject;
        _distributionClassV.frame = self.view.bounds;
        _distributionClassV.alpha = 0;
        kWeakSelf
        _distributionClassV.selectBlock = ^(DistributionClassType type, NSInteger ID, NSString * _Nonnull className, NSString * _Nonnull subClassName) {
            weakSelf.classID = ID;
            weakSelf.classLab.text = className;
            weakSelf.subClassLab.text = subClassName;
        };
        [self.view addSubview:_distributionClassV];
    }
    return _distributionClassV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self resetViews];
}

- (void)setViews {
    self.contentTextV.delegate = self;
    self.requestV.frame = self.addV.bounds;
    [self.myV addSubview:self.requestV];
    self.errorV.frame = self.addV.bounds;
    [self.myV addSubview:self.errorV];
    self.baseTVHeight = kScreenH - 94 - kTopVH - kBottomVH - [Tool heightForString:@"信息从网站前台中撤销，不再显示。" width:kScreenW - 86 font:[UIFont systemFontOfSize:15]] - [Tool heightForString:@"彻底删除，您自己也无法再看到此信息。" width:kScreenW - 86 font:[UIFont systemFontOfSize:15]];
    self.baseTV.frame = CGRectMake(0, 0, kScreenW, self.baseTVHeight);
    [self.baseTV registerNib:[UINib nibWithNibName:@"DistributionTableCell" bundle:nil] forCellReuseIdentifier:@"DistributionTableCell"];
    self.page = 1;
    kWeakSelf
//    self.baseTV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.page = 1;
//        [weakSelf requestData];
//    }];
    self.baseTV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf requestData];
    }];
    [self.contentV addSubview:self.baseTV];
}

- (void)resetViews {
    self.classID = 10198;
    self.classLab.text = @"铁合金";
    self.subClassLab.text = @"钒";
    self.type = 0;
    self.supplyImgV.image = kImage(self.type ? @"distribution_type_unselect" : @"distribution_type_select");
    self.purchaseImgV.image = kImage(self.type ? @"distribution_type_select" : @"distribution_type_unselect");
    self.distributionClassV.ID = 0;
    self.titleTF.text = @"";
    self.modelTF.text = @"";
    self.countTF.text = @"";
    self.priceDesTF.text = @"";
    self.tradePlaceTF.text = @"";
    self.contentTextV.text = @"";
    self.placeholderLab.alpha = 1;
}

- (void)reloadData {
    self.requestV.alpha = 1;
    self.errorV.alpha = 0;
    if (![Tool shareInstance].user) {
        return;
    }
    [self requestData];
}

- (void)requestData {
    kWeakSelf
    if (!self.baseTV.mj_footer) {
        self.baseTV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakSelf.page ++;
            [weakSelf requestData];
        }];
    }
    [Tool POST:DISTRIBUTIONMY params:@[@{@"pagesize":@"20"}, @{@"pageindex":@(self.page).stringValue}, @{@"vipid":[Tool shareInstance].user.ID}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSDictionary * _Nonnull result) {
        if (weakSelf.page == 1) {
            weakSelf.dataAry = @[].mutableCopy;
            weakSelf.selectAry = @[].mutableCopy;
            weakSelf.selectImgV.image = kImage(@"distribution_unselect");
        }
        if (weakSelf.baseTV.alpha) {
            if (weakSelf.baseTV.mj_header) {
                [weakSelf.baseTV.mj_header endRefreshing];
            }
            if (weakSelf.baseTV.mj_footer) {
                [weakSelf.baseTV.mj_footer endRefreshing];
            }
        }
        NSArray *ary = [DistributionM mj_objectArrayWithKeyValuesArray:result[@"mallvipmylist"]];
        for (DistributionM *model in ary) {
            CGFloat height = [Tool heightForString:[NSString stringWithFormat:@"%@%@", model.typeID == 1 ? @"[供应]" : @"[求购]", model.infotitle] width:kScreenW - 110 font:[UIFont systemFontOfSize:16]];
            model.cellHeight = height > 60 ? height : 60;
            NSMutableAttributedString *atrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", model.typeID == 1 ? @"[供应]" : @"[求购]", model.infotitle]];
            [atrStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, atrStr.length)];
            [atrStr addAttributes:@{NSForegroundColorAttributeName:kHexColor(@"C84E00", 1)} range:NSMakeRange(0, 4)];
            model.name = atrStr;
        }
        if (ary.count < 20) {
            [weakSelf.baseTV.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.dataAry addObjectsFromArray:ary];
        weakSelf.titleV.alpha = weakSelf.dataAry.count ? 1 : 0;
        if (weakSelf.dataAry.count == 0) {
            DistributionM *model = [[DistributionM alloc] init];
            model.cellHeight = weakSelf.baseTVHeight;
            [weakSelf.dataAry addObject:model];
            weakSelf.baseTV.mj_footer = nil;
        }
        
        if (weakSelf.requestV.alpha == 1) {
            weakSelf.requestV.alpha = 0;
            weakSelf.errorV.alpha = 0;
        }
        [weakSelf.baseTV reloadData];
    } failure:^(NSString * _Nonnull error) {
        if (weakSelf.page > 1) {
            weakSelf.page --;
            [weakSelf.baseTV.mj_footer endRefreshing];
        } else {
            weakSelf.errorV.alpha = 1;
            weakSelf.requestV.alpha = 0;
        }
    }];
}

- (IBAction)pageSelectAct:(UIButton *)sender {
    [self resignAct];
    [self pageSelectWithIndex:sender.tag - 30000];
}

- (void)pageSelectWithIndex:(NSInteger)index {
    if (self.pageIndex != index) {
        self.pageIndex = index;
        self.addV.alpha = self.pageIndex ? 0 : 1;
        self.myV.alpha = self.pageIndex ? 1 : 0;
        self.distributionAddTitleLab.textColor = kHexColor(self.pageIndex ? @"000000" : kNavBackgroundColorHex, 1);
        self.distributionAddLineV.backgroundColor = kHexColor(self.pageIndex ? @"BBBBBB" : kNavBackgroundColorHex, 1);
        self.distributionMyTitleLab.textColor = kHexColor(self.pageIndex ? kNavBackgroundColorHex : @"000000", 1);
        self.distributionMyLineV.backgroundColor = kHexColor(self.pageIndex ? kNavBackgroundColorHex : @"BBBBBB", 1);
        if (self.pageIndex) {
            [self reloadData];
        }
    }
}

- (IBAction)typeSelectAct:(UIButton *)sender {
    [self resignAct];
    if (self.type != sender.tag - 30010) {
        self.type = sender.tag - 30010;
        self.supplyImgV.image = kImage(self.type ? @"distribution_type_unselect" : @"distribution_type_select");
        self.purchaseImgV.image = kImage(self.type ? @"distribution_type_select" : @"distribution_type_unselect");
    }
}

- (IBAction)classSelectAct:(UIButton *)sender {
    [self resignAct];
    [self.distributionClassV showWithType:sender.tag - 30020];
}

- (IBAction)sureAct:(id)sender {
    [self resignAct];
    if (self.titleTF.text.length == 0) {
        [Tool showStatusDark:@"请填写产品标题"];
        return;
    }
    if (self.modelTF.text.length == 0) {
        [Tool showStatusDark:@"请填写产品规格"];
        return;
    }
    if (self.countTF.text.length == 0) {
        [Tool showStatusDark:@"请填写交易数量"];
        return;
    }
    [Tool showProgressDark];
    kWeakSelf
    [Tool POST:DISTRIBUTIONADD params:@[@{@"id":@(self.distributionID).stringValue}, @{@"typeid":@(self.type + 1).stringValue}, @{@"vipid":[Tool shareInstance].user.ID}, @{@"title":self.titleTF.text}, @{@"cont":self.contentTextV.text ? self.contentTextV.text : @""}, @{@"guige":self.modelTF.text}, @{@"num":self.countTF.text}, @{@"price":self.priceDesTF.text ? self.priceDesTF.text : @""}, @{@"area":self.tradePlaceTF.text ? self.tradePlaceTF.text : @""}, @{@"productid": @(self.classID).stringValue}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSDictionary * _Nonnull result) {
        if ([result[@"MallSubmitState"] boolValue]) {
            [weakSelf resetViews];
            [Tool showStatusDark:weakSelf.distributionID ? @"编辑成功" : @"添加成功"];
        } else {
            [Tool showStatusDark:weakSelf.distributionID ? @"编辑失败" : @"添加失败"];
        }
    } failure:^(NSString * _Nonnull error) {
        [Tool showStatusDark:weakSelf.distributionID ? @"编辑失败" : @"添加失败"];
    }];
}

- (IBAction)deleteAct:(id)sender {
    if (self.selectAry.count == 0) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"请至少选中一条信息" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertC animated:true completion:nil];
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"删除供求信息" message:@"确认删除所选中的供求信息？" preferredStyle:UIAlertControllerStyleAlert];
        kWeakSelf
        [alertC addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [Tool showProgressDark];
            [Tool POST:DISTRIBUTIONDEL params:@[@{@"ids":[weakSelf.selectAry componentsJoinedByString:@","]}, @{@"vipid":[Tool shareInstance].user.ID}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull progress) {
                
            } success:^(NSDictionary * _Nonnull result) {
                if ([result[@"MallDelState"] boolValue]) {
                    [Tool showStatusDark:@"删除成功"];
                    [weakSelf resetViews];
                    [weakSelf reloadData];
                } else {
                    [Tool showStatusDark:@"删除失败"];
                }
            } failure:^(NSString * _Nonnull error) {
                [Tool showStatusDark:@"删除失败"];
            }];
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertC animated:true completion:nil];
    }
}

- (IBAction)revokeAct:(id)sender {
    if (self.selectAry.count == 0) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"请至少选中一条信息" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertC animated:true completion:nil];
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"撤销显示供求信息" message:@"撤销信息后，网站前台将不再显示" preferredStyle:UIAlertControllerStyleAlert];
        kWeakSelf
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [Tool showProgressDark];
            [Tool POST:DISTRIBUTIONREV params:@[@{@"ids":[weakSelf.selectAry componentsJoinedByString:@","]}, @{@"vipid":[Tool shareInstance].user.ID}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull progress) {
                
            } success:^(NSDictionary * _Nonnull result) {
                if ([result[@"MallChgState"] boolValue]) {
                    [Tool showStatusDark:@"撤销成功"];
                    [weakSelf resetViews];
                    [weakSelf reloadData];
                } else {
                    [Tool showStatusDark:@"撤销失败"];
                }
            } failure:^(NSString * _Nonnull error) {
                [Tool showStatusDark:@"撤销失败"];
            }];
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertC animated:true completion:nil];
    }
}

- (IBAction)selectAllAct:(id)sender {
    if (self.dataAry.count == self.selectAry.count) {
        self.selectImgV.image = kImage(@"distribution_unselect");
        self.selectAry = @[].mutableCopy;
        for (DistributionM *model in self.dataAry) {
            model.isSelect = false;
            if ([self.selectAry containsObject:@(model.ID).stringValue]) {
                [self.selectAry removeObject:@(model.ID).stringValue];
            }
        }
        [self.baseTV reloadData];
    } else {
        if (self.dataAry[0].ID == 0) {
            return;
        }
        self.selectImgV.image = kImage(@"distribution_select");
        for (DistributionM *model in self.dataAry) {
            model.isSelect = true;
            if (![self.selectAry containsObject:@(model.ID).stringValue]) {
                [self.selectAry addObject:@(model.ID).stringValue];
            }
        }
        [self.baseTV reloadData];
    }
}

- (void)resignAct {
    [self.titleTF resignFirstResponder];
    [self.modelTF resignFirstResponder];
    [self.countTF resignFirstResponder];
    [self.priceDesTF resignFirstResponder];
    [self.tradePlaceTF resignFirstResponder];
    [self.contentTextV resignFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeholderLab.alpha = textView.text.length ? 0 : 1;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    self.placeholderLab.alpha = textView.text.length ? 0 : 1;
    return true;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *str = [textView.text stringByReplacingCharactersInRange:range withString:text];
    self.placeholderLab.alpha = str.length ? 0 : 1;
    return true;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    kWeakSelf
    if (indexPath.row < self.dataAry.count) {
        DistributionM *model = self.dataAry[indexPath.row];
        if (model.ID == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            NoDataV *v = [[[NSBundle mainBundle] loadNibNamed:@"NoDataV" owner:nil options:NULL] lastObject];
            v.viewType = NoDataViewTypeDistribution;
            v.frame = cell.bounds;
            [cell.contentView addSubview:v];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            DistributionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DistributionTableCell" forIndexPath:indexPath];
            cell.backgroundColor = kHexColor(indexPath.row % 2 == 1 ? @"EEEEEE" : @"FFFFFF", 1);
            cell.model = self.dataAry[indexPath.row];
            cell.selectBlock = ^(DistributionM * _Nonnull model) {
                if (model.isSelect) {
                    if (![weakSelf.selectAry containsObject:@(model.ID).stringValue]) {
                        [weakSelf.selectAry addObject:@(model.ID).stringValue];
                    }
                } else {
                    if ([weakSelf.selectAry containsObject:@(model.ID).stringValue]) {
                        [weakSelf.selectAry removeObject:@(model.ID).stringValue];
                    }
                }
                weakSelf.selectImgV.image = kImage(weakSelf.dataAry.count == weakSelf.selectAry.count ? @"distribution_select" : @"distribution_unselect");
            };
            cell.modifyBlock = ^(DistributionM * _Nonnull model) {
                [Tool showProgressDark];
                [Tool POST:DISTRIBUTIONREA params:@[@{@"id":@(model.ID).stringValue}, @{@"pass":@"cbcieapp12453fgdfg546867adflopq0225"}] progress:^(NSProgress * _Nonnull progress) {
                    
                } success:^(NSDictionary * _Nonnull result) {
                    NSArray<DistributionM *> *ary = [DistributionM mj_objectArrayWithKeyValuesArray:result[@"mallinfo"]];
                    NSArray<DistributionM *> *IDAry = [DistributionM mj_objectArrayWithKeyValuesArray:result[@"mallproduct"]];
                    if (ary.count) {
                        [Tool dismiss];
                        weakSelf.distributionID = model.ID;
                        weakSelf.type = ary[0].typeID - 1;
                        weakSelf.supplyImgV.image = kImage(self.type ? @"distribution_type_unselect" : @"distribution_type_select");
                        weakSelf.purchaseImgV.image = kImage(self.type ? @"distribution_type_select" : @"distribution_type_unselect");
                        if (IDAry.count) {
                            weakSelf.distributionClassV.ID = IDAry[0].productID;
                        }
                        weakSelf.titleTF.text = ary[0].infoTitle;
                        weakSelf.modelTF.text = ary[0].guige;
                        weakSelf.countTF.text = ary[0].tradenum;
                        weakSelf.priceDesTF.text = ary[0].price;
                        weakSelf.tradePlaceTF.text = ary[0].tradearea;
                        weakSelf.contentTextV.text = ary[0].infoContent;
                        weakSelf.placeholderLab.alpha = weakSelf.contentTextV.text.length ? 0 : 1;
                        [weakSelf pageSelectWithIndex:0];
                    } else {
                        [Tool showStatusDark:@"编辑失败"];
                    }
                } failure:^(NSString * _Nonnull error) {
                    [Tool showStatusDark:@"编辑失败"];
                }];
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataAry.count) {
        return self.dataAry[indexPath.row].cellHeight;
    } else {
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataAry.count) {
        if (self.dataAry[0].ID != 0) {
            DistributionDetailsVC *vc = [[DistributionDetailsVC alloc] init];
            vc.model = self.dataAry[indexPath.row];
            [self.navigationController pushViewController:vc animated:true];
        }
    }
}

@end
