//
//  NewsClassVC.m
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/30.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import "NewsClassVC.h"
#import "NewsClassTableCell.h"

@interface NewsClassVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *backgroundV;
@property (nonatomic, strong) NSMutableArray *sortAry;
@property (nonatomic, strong) NSMutableArray *selectAry;
@property (nonatomic, assign) BOOL gestureIsChanged;
@property (nonatomic, assign) BOOL gestureIsDrag;

@end

@implementation NewsClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
}

- (void)setViews {
    [self setNavigationBarWithTitle:@"更多金属" hasBackBtn:false];
    [self.navigationView.rightBtn setImage:kImage(@"news_class_close") forState:UIControlStateNormal];
    self.navigationView.rightBtn.contentEdgeInsets = UIEdgeInsetsMake(14, 10, 14, 18);
    self.navigationView.rightBtn.alpha = 1;
    
    self.baseTV.frame = CGRectMake(0, 0, kScreenW, kScreenH - kTopVH - kBottomH);
    self.baseTV.backgroundColor = kHexColor(@"F0F0F0", 1);
    [self.baseTV registerNib:[UINib nibWithNibName:@"NewsClassTableCell" bundle:nil] forCellReuseIdentifier:@"NewsClassTableCell"];
    [self.backgroundV addSubview:self.baseTV];
    
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    longTap.minimumPressDuration = 0.1;
    [self.baseTV addGestureRecognizer:longTap];
}

- (void)reloadData {
    self.sortAry = [Tool newsClassSortAry].mutableCopy;
    self.selectAry = [Tool newsClassIDAry].mutableCopy;
    [self.baseTV reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsClassTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsClassTableCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (NewsClassM *model in self.dataAry) {
        if ([@(model.ID).stringValue isEqualToString:self.sortAry[indexPath.row]]) {
            cell.model = model;
            break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectActWithIndexPath:indexPath];
}

- (void)handlelongGesture:(UILongPressGestureRecognizer *)sender {
    UIGestureRecognizerState state = sender.state;
    
    CGPoint location = [sender locationInView:self.baseTV];
    NSIndexPath *indexPath = [self.baseTV indexPathForRowAtPoint:location];
    NewsClassTableCell *cell = [self.baseTV cellForRowAtIndexPath:indexPath];
    CGPoint dragPoint = [sender locationInView:cell.dragV];
    static UIView *snapshot = nil;
    static NSIndexPath *sourceIndexPath = nil;
    switch (state) {
        case UIGestureRecognizerStateBegan:
        {
            if (dragPoint.x < 40 && dragPoint.y < 40) {
                self.gestureIsDrag = true;
                if (indexPath) {
                    sourceIndexPath = indexPath;
                    UITableViewCell *cell = [self.baseTV cellForRowAtIndexPath:indexPath];
                    snapshot = [self customSnapshoFromView:cell];
                    __block CGPoint center = cell.center;
                    snapshot.center = center;
                    snapshot.alpha = 0.0;
                    [self.baseTV addSubview:snapshot];
                    [UIView animateWithDuration:0.05 animations:^{
                        center.y = location.y;
                        snapshot.center = center;
                        snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                        snapshot.alpha = 0.98;
                        cell.alpha = 0.0f;
                    } completion:^(BOOL finished) {
                        cell.hidden = true;
                    }];
                }
            } else {
                self.gestureIsDrag = false;
                self.gestureIsChanged = false;
                cell.contentView.backgroundColor = kHexColor(kTintColorHex, 0.4);
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (self.gestureIsDrag) {
                CGPoint center = snapshot.center;
                center.y = location.y;
                snapshot.center = center;
                if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                    [self.sortAry exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                    [Tool setNewsClassSortAry:self.sortAry.copy];
                    self.selectAry = @[].mutableCopy;
                    for (NSString *ID in self.sortAry) {
                        for (NewsClassM *model in self.dataAry) {
                            if ([@(model.ID).stringValue isEqualToString:ID]) {
                                if (model.isSelect) {
                                    [self.selectAry addObject:ID];
                                }
                            }
                        }
                    }
                    [Tool setNewsClassIDAry:self.selectAry.copy];
                    if (self.changeBlock) {
                        self.changeBlock();
                    }
                    [self.baseTV moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                    sourceIndexPath = indexPath;
                }
            } else {
                self.gestureIsChanged = true;
                cell.contentView.backgroundColor = kHexColor(@"F0F0F0", 1);
                return;
            }
        }
            break;
        default:
        {
            if (self.gestureIsDrag) {
                UITableViewCell *cell = [self.baseTV cellForRowAtIndexPath:sourceIndexPath];
                [UIView animateWithDuration:0.05 animations:^{
                    snapshot.center = cell.center;
                    snapshot.transform = CGAffineTransformIdentity;
                    snapshot.alpha = 0.0;
                    cell.alpha = 1.0f;
                } completion:^(BOOL finished) {
                    cell.hidden = false;
                    [snapshot removeFromSuperview];
                    snapshot = nil;
                }];
                sourceIndexPath = nil;
            } else {
                cell.contentView.backgroundColor = kHexColor(@"F0F0F0", 1);
                if (!self.gestureIsChanged) {
                    [self selectActWithIndexPath:indexPath];
                }
            }
        }
            break;
    }
//    if (dragPoint.x < 40 && dragPoint.y < 40) {
//        
//    } else {
//        switch (state) {
//            case UIGestureRecognizerStateBegan:
//            {
//                self.gestureIsChanged = false;
//                cell.contentView.backgroundColor = kHexColor(kTintColorHex, 0.4);
//            }
//                break;
//            case UIGestureRecognizerStateChanged:
//            {
//                self.gestureIsChanged = true;
//                cell.contentView.backgroundColor = kHexColor(@"F0F0F0", 1);
//                return;
//            }
//                break;
//            case UIGestureRecognizerStateEnded:
//            {
//                cell.contentView.backgroundColor = kHexColor(@"F0F0F0", 1);
//                if (!self.gestureIsChanged) {
//                    [self selectActWithIndexPath:indexPath];
//                }
//            }
//            default:
//                return;
//                break;
//        }
//    }
}

- (void)selectActWithIndexPath:(NSIndexPath *)indexPath {
    for (NewsClassM *model in self.dataAry) {
        if ([@(model.ID).stringValue isEqualToString:self.sortAry[indexPath.row]]) {
            model.isSelect = !model.isSelect;
            break;
        }
    }
    [self.baseTV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    self.selectAry = @[].mutableCopy;
    for (NSString *ID in self.sortAry) {
        for (NewsClassM *model in self.dataAry) {
            if ([@(model.ID).stringValue isEqualToString:ID]) {
                if (model.isSelect) {
                    [self.selectAry addObject:ID];
                }
            }
        }
    }
    [Tool setNewsClassIDAry:self.selectAry.copy];
    if (self.changeBlock) {
        self.changeBlock();
    }
}

- (UIView *)customSnapshoFromView:(UIView *)inputView {
    UIView *snapshot = nil;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 7.0) {
        snapshot = [self customSnapShortFromViewEx:inputView];
    }else{
        snapshot = [inputView snapshotViewAfterScreenUpdates:true];
    }
    
    snapshot.layer.masksToBounds = false;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}

- (UIView *)customSnapShortFromViewEx:(UIView *)inputView {
    CGSize inSize = inputView.bounds.size;
    UIGraphicsBeginImageContextWithOptions(inSize, false, [UIScreen mainScreen].scale);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView* snapshot = [[UIImageView alloc] initWithImage:image];
    return snapshot;
}

- (void)rightAct {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
