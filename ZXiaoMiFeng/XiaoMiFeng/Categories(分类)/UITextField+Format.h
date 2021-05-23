//
//  UITextField+Format.h
//  Agent
//
//  Created by ideasforHK on 2018/11/5.
//  Copyright © 2018年 ideasforHK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Format)

/// 格式化身份证号
- (BOOL)formatIdNumWithString:(NSString *)string range:(NSRange)range;

/// 格式化银行卡号
- (BOOL)formatBankCardNoWithString:(NSString *)string range:(NSRange)range;

@end
