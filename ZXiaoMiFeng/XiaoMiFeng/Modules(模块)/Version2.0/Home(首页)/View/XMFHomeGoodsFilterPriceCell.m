//
//  XMFHomeGoodsFilterPriceCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/5.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeGoodsFilterPriceCell.h"
#import "XMFHomeGoodsFilterModel.h"

//在.m文件中添加
@interface  XMFHomeGoodsFilterPriceCell()<UITextFieldDelegate>

/** 是否存在小数点 */
@property (nonatomic , assign) BOOL isHavePoint;


@end

@implementation XMFHomeGoodsFilterPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    //设置代理方法
    self.leftTfd.delegate = self;
    
    self.rightTfd.delegate = self;
    
    /*
    //给最小价格和最大价格添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.leftTfd];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.rightTfd];
    */
    
    
    [self.leftTfd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.rightTfd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
}


//通知绑定方法
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

//移除通知
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//重写set方法
-(void)setSonModel:(XMFHomeGoodsFilterSonModel *)sonModel{
    
    _sonModel = sonModel;
    
    self.leftTfd.text = sonModel.minPrice;
    
    self.rightTfd.text = sonModel.maxPrice;
    
    
}


#pragma mark - ——————— textField的代理方法 ————————
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        self.isHavePoint = NO;
    }
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            //首字母不能为0和小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!self.isHavePoint)//text中还没有小数点
                {
                    self.isHavePoint = YES;
                    return YES;
                }else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (self.isHavePoint) {//存在小数点
                    //判断小数点的位数
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
        } else { //输入的数据格式不正确
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
        /** 第一位用户输入 0 但不包含小数点 用户输入完成后讲0截取掉 */
        if ([first isEqualToString:@"0"] && ![textField.text containsString:@"."]) {
            textField.text = [textField.text substringFromIndex:1];//
        }
        /** 第一位用户输入 0 也输入了小数点 */
        if ([first isEqualToString:@"0"] && [textField.text containsString:@"."]) {
            if([textField.text rangeOfString:@"."].location != NSNotFound) {
                NSRange range;
                range = [textField.text rangeOfString:@"."];
                /** 小数点在0的后面 */
                if (range.location == 1) {
                    
                    /** 小数点不在0的后面 */
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

    
    
    //当最高价小于最低价时
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
