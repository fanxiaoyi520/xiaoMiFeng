//
//  UILabel+AlignmentLeftAndRight.m
//  ZFDaYaNews
//
//  Created by 小蜜蜂 on 2019/11/15.
//  Copyright © 2019 Jellyfish. All rights reserved.
//

#import "UILabel+AlignmentLeftAndRight.h"
#import <CoreText/CoreText.h>

@implementation UILabel (AlignmentLeftAndRight)

- (void)textAlignmentLeftAndRight{
    
    [self textAlignmentLeftAndRightWith:CGRectGetWidth(self.frame)];
    
}

- (void)textAlignmentLeftAndRightWith:(CGFloat)labelWidth{
    
    if(self.text==nil||self.text.length==0) {
        
        return;
        
    }
    
//    CGSize size = [self.text boundingRectWithSize:CGSizeMake(labelWidth,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil].size;
    
    CGFloat textWidth = [self SG_widthWithString:self.text font:self.font];
    
    
    NSInteger length = (self.text.length-1);
    
    NSString* lastStr = [self.text substringWithRange:NSMakeRange(self.text.length-1,1)];
    
    if([lastStr isEqualToString:@":"]||[lastStr isEqualToString:@"："]) {
        
        length = (self.text.length-2);
        
    }
    
//    CGFloat margin = (labelWidth - size.width)/length;
    CGFloat margin = (labelWidth - textWidth)/length;
    
    NSNumber*number = [NSNumber numberWithFloat:margin];
    
    NSMutableAttributedString* attribute = [[NSMutableAttributedString alloc]initWithString:self.text];
    
    [attribute addAttribute:NSKernAttributeName value:number range:NSMakeRange(0,length)];
    
    self.attributedText= attribute;
    
}


#pragma mark - - - 计算字符串宽度
- (CGFloat)SG_widthWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}

@end
