//
//  UILabel+TextAlign.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/19.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "UILabel+TextAlign.h"

@implementation UILabel (TextAlign)

// label顶部对齐
- (void)topAlignment
{
    CGSize size = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
    self.numberOfLines = 0;
    NSInteger newLinesToPad = (self.frame.size.height - rect.size.height)/size.height;
    for (NSInteger i = 0; i < newLinesToPad; i ++) {
        self.text = [self.text stringByAppendingString:@"\n "];
    }
}

// label底部对齐
- (void)bottomAlignment
{
    CGSize size = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
    self.numberOfLines = 0;
    NSInteger newLinesToPad = (self.frame.size.height - rect.size.height)/size.height;
    for (NSInteger i = 0; i < newLinesToPad; i ++) {
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
    }
}

@end
