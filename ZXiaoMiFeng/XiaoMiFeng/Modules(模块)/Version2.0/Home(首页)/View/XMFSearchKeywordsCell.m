//
//  XMFSearchKeywordsCell.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2021/1/22.
//  Copyright Â© 2021 ðå°èèð. All rights reserved.
//

#import "XMFSearchKeywordsCell.h"

//åš.mæä»¶äž­æ·»å 
@interface  XMFSearchKeywordsCell()

/** å³é®è¯ */
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
    
    //çš^äœäžºåéç¬Š
    NSArray<NSString *> *searchwordsArr = [suggestSearchwordsStr componentsSeparatedByString:@"^"];
    
    //å®æŽçå³é®è¯
    NSString *firstKeywordsStr = [searchwordsArr firstObject];
    
    //éèŠé«äº®çå³é®è¯
    NSString *secondKeywordsStr = searchwordsArr[1];
    
    if ((searchwordsArr.count >= 2) && [firstKeywordsStr containsString:secondKeywordsStr]) {
        
        self.keywordsLB.attributedText = [self setupAttributeString:firstKeywordsStr highlightText:secondKeywordsStr];
        
        
    }else{
        
        
        self.keywordsLB.text = firstKeywordsStr;
        
    }
    
    
    
    

        
   
    
    
    
}


#pragma mark - å¯ææ¬éšåå­äœé£ç°
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
