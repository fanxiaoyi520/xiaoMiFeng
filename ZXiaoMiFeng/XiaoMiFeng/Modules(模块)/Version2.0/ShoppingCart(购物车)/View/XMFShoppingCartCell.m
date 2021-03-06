//
//  XMFShoppingCartCell.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/2.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFShoppingCartCell.h"
#import "XMFShoppingCartCellModel.h"//è´­ç©è½¦çæ»model
#import "UILabel+TextAlign.h"


#define NUMBERS @"0123456789"


//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFShoppingCartCell()<UITextFieldDelegate>

/** éæ©æé® */
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;


/** ååå¾ç */
@property (weak, nonatomic) IBOutlet UIImageView *goodsPicImgView;

/** åååç§° */
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLB;

/** ååè§æ ¼ */
@property (weak, nonatomic) IBOutlet UILabel *goodTypeLB;


/** åç¨ */
@property (weak, nonatomic) IBOutlet KKPaddingLabel *taxTagLB;

/** åç¨æ ç­¾å®½åº¦ */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taxTagLBWidth;


/** åé® */
@property (weak, nonatomic) IBOutlet KKPaddingLabel *postageTagLB;

/** åé®æ ç­¾å·¦è¾¹é´è· */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postageTagLBLeftSpace;

/** è¿è´¹ */
@property (weak, nonatomic) IBOutlet UILabel *postageFeeLB;


/** ç¨è´¹ */
@property (weak, nonatomic) IBOutlet UILabel *taxFeeLB;

/** å®ä»· */
@property (weak, nonatomic) IBOutlet UILabel *actPriceLB;


/** æ°éå */
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;

/** æ°éå  */
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

/** ååæ°é */
@property (weak, nonatomic) IBOutlet UITextField *goodCountTfd;

/** è´­ä¹°æ°éæç¤ºè¯­ */
@property (weak, nonatomic) IBOutlet UILabel *tipsLB;

/** è´­ä¹°æ°éæç¤ºè¯­çé«åº¦ */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsLBHeight;


/** æ¯å¦å­å¨å°æ°ç¹ */
@property (nonatomic , assign) BOOL isHavePoint;


@end

@implementation XMFShoppingCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //è®¾ç½®ä»£çæ¹æ³
    self.goodCountTfd.delegate = self;
    
    [self.goodCountTfd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    

}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    //ä»¥ä¸ä¸è¡ä»£ç é²æ­¢å¾çåå½¢
    self.goodsPicImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.goodsPicImgView.autoresizesSubviews = YES;
    
    self.goodsPicImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    
    [self.goodsPicImgView cornerWithRadius:5.f];



}


//é¡µé¢ä¸çæé®è¢«ç¹å»
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    
    switch (sender.tag) {
        case 0:{//éæ©
            
 
            if ([self.delegate respondsToSelector:@selector(buttonsOnXMFShoppingCartCellDidClick:button:)]) {
                
                [self.delegate buttonsOnXMFShoppingCartCellDidClick:self button:sender];
            }
            
        }
            break;
            
        case 1:{//å
        
            
            static NSTimeInterval time = 0.0;
            
            NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
            
            //éå¶ç¨æ·ç¹å»æé®çæ¶é´é´éå¤§äº1ç§é
            
            if (currentTime - time > 0.5) {
                
                //å¤§äºè¿ä¸ªæ¶é´é´éå°±å¤ç
                
                if ([self.delegate respondsToSelector:@selector(buttonsOnXMFShoppingCartCellDidClick:button:)]) {
                    
                    [self.delegate buttonsOnXMFShoppingCartCellDidClick:self button:sender];
                }
                
                
            }
            
            time = currentTime;
            
            
            
        }
            break;
            
        case 2:{//å 
        
            
            static NSTimeInterval time = 0.0;
            
            NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
            
            //éå¶ç¨æ·ç¹å»æé®çæ¶é´é´éå¤§äº1ç§é
            
            if (currentTime - time > 0.5) {
                
                //å¤§äºè¿ä¸ªæ¶é´é´éå°±å¤ç
              if ([self.delegate respondsToSelector:@selector(buttonsOnXMFShoppingCartCellDidClick:button:)]) {
                    
                    [self.delegate buttonsOnXMFShoppingCartCellDidClick:self button:sender];
                }
                
                
            }
            
            time = currentTime;
            
        }
            break;
            
        default:
            break;
    }

    
    
}



-(void)setValidModel:(XMFShoppingCartCellGoodsModel *)validModel{
    
    _validModel = validModel;
    
    
    //éæ©æé®
    self.selectBtn.selected = [validModel.checked boolValue];
        

    //å¾ç
    [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:validModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    //åååç§°
    self.goodsNameLB.text = validModel.goodsName;
    
    
    //éä¸­çååç±»å
    self.goodTypeLB.text = @"";
    for (int i= 0; i < validModel.specifications.count; ++i) {
        
        self.goodTypeLB.text = [NSString stringWithFormat:@"%@  %@",self.goodTypeLB.text,validModel.specifications[i]];
        
    }
    
    /** æ¯å¦åç¨ 0-å¦ 1-æ¯p */
    if ([validModel.taxFlag boolValue]) {
        
        self.taxTagLB.hidden = NO;
        
        self.taxTagLBWidth.constant = 40.f;
        
        self.postageTagLBLeftSpace.constant = 5.f;
        
        self.taxFeeLB.hidden = YES;

        
    }else{
        
        self.taxTagLB.hidden = YES;
        
        self.taxTagLBWidth.constant = 0.f;
        
        self.postageTagLBLeftSpace.constant = 0.f;
        
         self.taxFeeLB.hidden = NO;
        
        //ç¨è´¹
        self.taxFeeLB.text = [NSString stringWithFormat:@"ç¨è´¹ HK$ %@",[NSString removeSuffix:validModel.incomeTax]];
        
    }
    
    /** æ¯å¦åé® 0-å¦ 1-æ¯ */
    if ([validModel.freeShipping boolValue]) {
        
        self.postageTagLB.hidden = NO;
        
        self.postageFeeLB.hidden = YES;
        
    }else{
        
        self.postageTagLB.hidden = YES;
        
        self.postageFeeLB.hidden = NO;
        
        self.postageFeeLB.text = [NSString stringWithFormat:@"è¿è´¹ HK$ %@",[NSString removeSuffix:validModel.postage]];

    }
    

    
    
    //å®éä»·æ ¼
    self.actPriceLB.text = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:validModel.retailPrice]];
    
    //ååæ°é
    self.goodCountTfd.text = validModel.number;
    
    
    //å½æ°éå¤§äºåºå­çæ¶åæ¾ç¤º
    if ([validModel.number integerValue] >= [validModel.stock integerValue]) {
        
        self.tipsLB.text = [NSString stringWithFormat:@"æå¤è´­ä¹°%@ä»¶",validModel.stock];
        
        [self.tipsLB topAlignment];
        
        self.tipsLB.hidden = NO;
        
        self.tipsLBHeight.constant = 28.f;

        
    }else{
        
        self.tipsLB.hidden = YES;
        
        self.tipsLBHeight.constant = 0.f;
        
    }
    
    
    //å½ååæ°éå¤§äºå­åºæ°éæ¶ï¼å å·æé®ç½®ç°
    if ([validModel.number integerValue] >= [validModel.stock integerValue]){
        
        self.addBtn.enabled = NO;
        
    }else{
        
        self.addBtn.enabled = YES;

    }
    
    
}


#pragma mark - âââââââ ç»å®æ¹æ³ ââââââââ
//éç¥ç»å®æ¹æ³
-(void)textFieldDidChange: (UITextField *)textField{
    
    
    
}



/*
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        self.isHavePoint = NO;
    }
    
    
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//å½åè¾å¥çå­ç¬¦
        if ((single >= '0' && single <= '9') || single == '.') {//æ°æ®æ ¼å¼æ­£ç¡®
            //é¦å­æ¯ä¸è½ä¸º0åå°æ°ç¹
            if([textField.text length] == 0){
                if(single == '.'|| single == '0') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                
            }else{
                
                if(single == '.'|| single == '0') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                
            }
            
            //è¾å¥çå­ç¬¦æ¯å¦æ¯å°æ°ç¹
            if (single == '.') {
                if(!self.isHavePoint)//textä¸­è¿æ²¡æå°æ°ç¹
                {
                    self.isHavePoint = YES;
                    return NO;
                }else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (self.isHavePoint) {//å­å¨å°æ°ç¹
                 
                        return NO;
                    
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
        // ç¬¬ä¸ä½ç¨æ·è¾å¥ 0 ä½ä¸åå«å°æ°ç¹ ç¨æ·è¾å¥å®æåè®²0æªåæ
        if ([first isEqualToString:@"0"] && ![textField.text containsString:@"."]) {
            textField.text = [textField.text substringFromIndex:1];//
        }
        //ç¬¬ä¸ä½ç¨æ·è¾å¥ 0 ä¹è¾å¥äºå°æ°ç¹
        if ([first isEqualToString:@"0"] && [textField.text containsString:@"."]) {
            if([textField.text rangeOfString:@"."].location != NSNotFound) {
                NSRange range;
                range = [textField.text rangeOfString:@"."];
                // å°æ°ç¹å¨0çåé¢
                if (range.location == 1) {
                    
                    //å°æ°ç¹ä¸å¨0çåé¢
                } else if (range.location != 1) {
                    textField.text = nil;
                }
            } else {
            }
        }
    }
  
    
    
    //ä»£çæ¹æ³
    if ([self.delegate respondsToSelector:@selector(textFieldOnXMFShoppingCartCellEndInput:textField:)]) {
        
        [self.delegate textFieldOnXMFShoppingCartCellEndInput:self textField:textField];
    }
    
    

    
}*/


#pragma mark - âââââââ UITextFieldçä»£çæ¹æ³ ââââââââ

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string{
    
    //éå¶åªè½è¾å¥çº¯æ°å­
    NSCharacterSet*cs;
    
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    BOOL basicTest = [string isEqualToString:filtered];
    
    if(!basicTest) {
    
        return NO;
        
    }
    return YES;
}




- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.text.length > 0) {
        
        if ([textField.text integerValue] <= 0) {
            
            [MBProgressHUD showOnlyTextToView:kAppWindow title:XMFLI(@"äº²,å®å¨ä¸è½åå°äº")];
            
            //ååæ°é
            self.goodCountTfd.text = self.validModel.number;
            
            return;
            
            
        }else if ([textField.text integerValue] > 999){
            
            [MBProgressHUD showOnlyTextToView:kAppWindow title:XMFLI(@"äº²,å®å¨ä¸è½åå¤äº")];
            
            //ååæ°é
            self.goodCountTfd.text = self.validModel.number;
            
            return;
            
            
        }else{
            
            //ä»£çæ¹æ³
            if ([self.delegate respondsToSelector:@selector(textFieldOnXMFShoppingCartCellEndInput:textField:)]) {
                
                [self.delegate textFieldOnXMFShoppingCartCellEndInput:self textField:textField];
            }
            
        }
        
        
    }else{
        
        //ååæ°é
        self.goodCountTfd.text = self.validModel.number;
        
    }

    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
