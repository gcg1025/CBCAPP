//
//  NSLayoutConstraint+multiplier.m
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/28.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import "NSLayoutConstraint+multiplier.h"

@implementation NSLayoutConstraint (multiplier)

- (void)changeMultiplier:(CGFloat)multiplier {
    NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:self.firstItem attribute:self.firstAttribute relatedBy:self.relation toItem:self.secondItem attribute:self.secondAttribute multiplier:multiplier constant:self.constant];
    newConstraint.priority = self.priority;
    newConstraint.shouldBeArchived = self.shouldBeArchived;
    newConstraint.identifier = self.identifier;
    [NSLayoutConstraint deactivateConstraints:@[self]];
    [NSLayoutConstraint activateConstraints:@[newConstraint]];
}

@end
