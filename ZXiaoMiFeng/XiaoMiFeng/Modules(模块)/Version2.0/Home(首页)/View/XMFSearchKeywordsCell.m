//
//  XMFSearchKeywordsCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2021/1/22.
//  Copyright © 2021 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFSearchKeywordsCell.h"

//在.m文件中添加
@interface  XMFSearchKeywordsCell()

/** 关键词 */
@property (weak, nonatomic) IBOutlet UILabel *keywordsLB;


@end

@implementation XMFSearchKeywordsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSuggestSearchwordsStr:(NSString *)suggestSearchwordsStr{
    
    _suggestSearchwordsStr = suggestSearchwordsStr;
    
    //用^作为分隔符
    NSArray<NSString *> *searchwordsArr = [suggestSearchwordsStr componentsSeparatedByString:@"^"];
    
    //完整的关键词
    NSString *firstKeywordsStr = [searchwordsArr firstObject];
    
    //需要高亮的关键词
    NSString *secondKeywordsStr = searchwordsArr[1];
    
    if ((searchwordsArr.count >= 2) && [firstKeywordsStr containsString:secondKeywordsStr]) {
        
        self.keywordsLB.attributedText = [self setupAttributeString:firstKeywordsStr highlightText:secondKeywordsStr];
        
        
    }else{
        
        
        self.keywordsLB.text = firstKeywordsStr;
        
    }
    
    
    
    

        
   
    
    
    
}


#pragma mark - 富文本部分字体飘灰
- (NSMutableAttributedString *)setupAttributeString:(NSString *)text highlightText:(NSString *)highlightText {
    
    NSRange hightlightTextRange = [text rangeOfString:highlightText];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    if (hightlightTextRange.length > 0) {
        [attributeStr addAttribute:NSForegroundColorAttributeName
                             value:UIColorFromRGB(0x999999)
                             range:hightlightTextRange];
//        [attributeStr addAttribute:NSForegroundColorAttributeName
//                             value:KRedColor
//                             range:hightlightTextRange];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:hightlightTextRange];

        return attributeStr;
        
    }else {
        
        return [highlightText copy];
    }
}

@end
