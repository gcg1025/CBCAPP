//
//  LoginV.m
//  iOS_CBC
//
//  Created by SDB_Mac on 2020/2/12.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "LoginV.h"

@implementation LoginV

- (IBAction)loginAct:(id)sender {
    if (self.loginBlock) {
        self.loginBlock();
    }
}

@end
