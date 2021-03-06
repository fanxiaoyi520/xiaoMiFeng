//
//  XMFHomeGoodsFilterPriceCell.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/5.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFHomeGoodsFilterPriceCell.h"
#import "XMFHomeGoodsFilterModel.h"

//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFHomeGoodsFilterPriceCell()<UITextFieldDelegate>

/** æ¯å¦å­å¨å°æ°ç¹ */
@property (nonatomic , assign) BOOL isHavePoint;


@end

@implementation XMFHomeGoodsFilterPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    //è®¾ç½®ä»£çæ¹æ³
    self.leftTfd.delegate = self;
    
    self.rightTfd.delegate = self;
    
    /*
    //ç»æå°ä»·æ ¼åæå¤§ä»·æ ¼æ·»å éç¥
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.leftTfd];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.rightTfd];
    */
    
    
    [self.leftTfd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.rightTfd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
}


//éç¥ç»å®æ¹æ³
-(void)textFieldDidChange: (NSNotification *)noti{
    
    if (self.leftTfd.text.length) {
        
        self.sonModel.minPrice = self.leftTfd.text;
    }
    
    
    if (self.rightTfd.text.length) {
        
        self.sonModel.maxPrice = self.rightTfd.text;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(textFieldOnXMFHomeGoodsFilterPriceCellInput:filterSonModel:)]) {
        
        [self.delegate textFieldOnXMFHomeGoodsFilterPriceCellInput:self filterSonModel:self.sonModel];
    }
    
    
}

//ç§»é¤éç¥
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//éåsetæ¹æ³
-(void)setSonModel:(XMFHomeGoodsFilterSonModel *)sonModel{
    
    _sonModel = sonModel;
    
    self.leftTfd.text = sonModel.minPrice;
    
    self.rightTfd.text = sonModel.maxPrice;
    
    
}


#pragma mark - âââââââ textFieldçä»£çæ¹æ³ ââââââââ
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        self.isHavePoint = NO;
    }
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//å½åè¾å¥çå­ç¬¦
        if ((single >= '0' && single <= '9') || single == '.') {//æ°æ®æ ¼å¼æ­£ç¡®
            //é¦å­æ¯ä¸è½ä¸º0åå°æ°ç¹
            if([textField.text length] == 0){
                if(single == '.') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                
            }
            
            //è¾å¥çå­ç¬¦æ¯å¦æ¯å°æ°ç¹
            if (single == '.') {
                if(!self.isHavePoint)//textä¸­è¿æ²¡æå°æ°ç¹
                {
                    self.isHavePoint = YES;
                    return YES;
                }else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (self.isHavePoint) {//å­å¨å°æ°ç¹
                    //å¤æ­å°æ°ç¹çä½æ°
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    } else{
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        } else { //è¾å¥çæ°æ®æ ¼å¼ä¸æ­£ç¡®
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    } else {
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length >= 2) {
        NSString *first = [textField.text substringToIndex:1];
        /** ç¬¬ä¸ä½ç¨æ·è¾å¥ 0 ä½ä¸åå«å°æ°ç¹ ç¨æ·è¾å¥å®æåè®²0æªåæ */
        if ([first isEqualToString:@"0"] && ![textField.text containsString:@"."]) {
            textField.text = [textField.text substringFromIndex:1];//
        }
        /** ç¬¬ä¸ä½ç¨æ·è¾å¥ 0 ä¹è¾å¥äºå°æ°ç¹ */
        if ([first isEqualToString:@"0"] && [textField.text containsString:@"."]) {
            if([textField.text rangeOfString:@"."].location != NSNotFound) {
                NSRange range;
                range = [textField.text rangeOfString:@"."];
                /** å°æ°ç¹å¨0çåé¢ */
                if (range.location == 1) {
                    
                    /** å°æ°ç¹ä¸å¨0çåé¢ */
                } else if (range.location != 1) {
                    textField.text = nil;
                }
            } else {
            }
        }
    }
    
    
    /*
     
    if (self.leftTfd.text.length) {
        self.sonModel.minPrice = self.leftTfd.text;
    }
    
    
    if (self.rightTfd.text.length) {
        self.sonModel.maxPrice = self.rightTfd.text;
    }
     
     */
    
    self.sonModel.minPrice = self.leftTfd.text;
    
    self.sonModel.maxPrice = self.rightTfd.text;

    
    
    //å½æé«ä»·å°äºæä½ä»·æ¶
    if (self.sonModel.minPrice.length && self.sonModel.maxPrice.length) {
        if (self.sonModel.minPrice.doubleValue > self.sonModel.maxPrice.doubleValue) {
            
            NSString *rightTfdStr = self.rightTfd.text;
            
            self.rightTfd.text = self.leftTfd.text;
            
            self.leftTfd.text = rightTfdStr;
            
            
            self.sonModel.minPrice = self.leftTfd.text;
            
            self.sonModel.maxPrice = self.rightTfd.text;
            
        }
        
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldOnXMFHomeGoodsFilterPriceCellEndInput:filterSonModel:)]) {
        [self.delegate textFieldOnXMFHomeGoodsFilterPriceCellEndInput:self filterSonModel:self.sonModel];
    }
}



@end
