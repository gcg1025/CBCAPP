//
//  DistributionClassV.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/25.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "DistributionClassV.h"

@interface DistributionClassV () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vBotCon;
@property (nonatomic, assign) NSInteger classIndex;
@property (nonatomic, assign) NSInteger subClassIndex;
@property (nonatomic, strong) NSMutableArray<DistributionClassM *> *dataAry;

@end

@implementation DistributionClassV

- (NSMutableArray<DistributionClassM *> *)dataAry {
    if (!_dataAry) {
        _dataAry = [DistributionClassM mj_objectArrayWithKeyValuesArray:[Tool distributionAry]];
        for (DistributionClassM *model in _dataAry) {
            model.subClass = [DistributionClassM mj_objectArrayWithKeyValuesArray:model.subClass];
        }
    }
    return _dataAry;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.pickerV.dataSource = self;
    self.pickerV.delegate = self;
    self.backgroundColor = [kHexColor(@"000000", 1) colorWithAlphaComponent:0.2];
}

- (void)setID:(NSInteger)ID {
    if (ID == 0) {
        self.classIndex = 0;
        self.subClassIndex = 0;
    } else {
        for (DistributionClassM *model in self.dataAry) {
            for (DistributionClassM *subModel in model.subClass) {
                if (subModel.ID == ID) {
                    self.classIndex = [self.dataAry indexOfObject:model];
                    self.subClassIndex = [model.subClass indexOfObject:subModel];
                    if (self.selectBlock) {
                        self.selectBlock(self.type, self.dataAry[self.classIndex].subClass[self.subClassIndex].ID, self.dataAry[self.classIndex].name, self.dataAry[self.classIndex].subClass[self.subClassIndex].name);
                    }
                }
            }
        }
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.type ? self.dataAry[self.classIndex].subClass.count : self.dataAry.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger) row forComponent:(NSInteger)component {
    return self.type ? self.dataAry[self.classIndex].subClass[row].name : self.dataAry[row].name;
}

- (void)showWithType:(DistributionClassType)type {
    self.type = type;
    [self.pickerV reloadComponent:0];
    [self.pickerV selectRow:self.type ? self.subClassIndex : self.classIndex inComponent:0 animated:false];
    self.vBotCon.constant = 0;
    self.alpha = 1;
    kWeakSelf
    [UIView animateWithDuration:0.4 animations:^{
        [weakSelf layoutIfNeeded];
    }];
}

- (IBAction)sureAct:(id)sender {
    if (self.type) {
        if (self.subClassIndex != [self.pickerV selectedRowInComponent:0]) {
            self.subClassIndex = [self.pickerV selectedRowInComponent:0];
            if (self.selectBlock) {
                self.selectBlock(self.type, self.dataAry[self.classIndex].subClass[self.subClassIndex].ID, self.dataAry[self.classIndex].name, self.dataAry[self.classIndex].subClass[self.subClassIndex].name);
            }
        }
    } else {
        if (self.classIndex != [self.pickerV selectedRowInComponent:0]) {
            self.classIndex = [self.pickerV selectedRowInComponent:0];
            self.subClassIndex = 0;
            if (self.selectBlock) {
                self.selectBlock(self.type, self.dataAry[self.classIndex].subClass[self.subClassIndex].ID, self.dataAry[self.classIndex].name, self.dataAry[self.classIndex].subClass[self.subClassIndex].name);
            }
        }
    }
    [self hideView];
}


- (IBAction)hideAct:(id)sender {
    [self hideView];
}

- (void)hideView {
    self.vBotCon.constant = -300;
    kWeakSelf
    [UIView animateWithDuration:0.4 animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        weakSelf.alpha = 0;
    }];
}

@end
