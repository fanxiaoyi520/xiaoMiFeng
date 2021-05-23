//
//  XMFShoppingCartCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/2.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFShoppingCartCell.h"
#import "XMFShoppingCartCellModel.h"//购物车的总model
#import "UILabel+TextAlign.h"


#define NUMBERS @"0123456789"


//在.m文件中添加
@interface  XMFShoppingCartCell()<UITextFieldDelegate>

/** 选择按钮 */
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;


/** 商品图片 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsPicImgView;

/** 商品名称 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLB;

/** 商品规格 */
@property (weak, nonatomic) IBOutlet UILabel *goodTypeLB;


/** 包税 */
@property (weak, nonatomic) IBOutlet KKPaddingLabel *taxTagLB;

/** 包税标签宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taxTagLBWidth;


/** 包邮 */
@property (weak, nonatomic) IBOutlet KKPaddingLabel *postageTagLB;

/** 包邮标签左边间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postageTagLBLeftSpace;

/** 运费 */
@property (weak, nonatomic) IBOutlet UILabel *postageFeeLB;


/** 税费 */
@property (weak, nonatomic) IBOutlet UILabel *taxFeeLB;

/** 实价 */
@property (weak, nonatomic) IBOutlet UILabel *actPriceLB;


/** 数量减 */
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;

/** 数量加 */
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

/** 商品数量 */
@property (weak, nonatomic) IBOutlet UITextField *goodCountTfd;

/** 购买数量提示语 */
@property (weak, nonatomic) IBOutlet UILabel *tipsLB;

/** 购买数量提示语的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsLBHeight;


/** 是否存在小数点 */
@property (nonatomic , assign) BOOL isHavePoint;


@end

@implementation XMFShoppingCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //设置代理方法
    self.goodCountTfd.delegate = self;
    
    [self.goodCountTfd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    

}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    //以下三行代码防止图片变形
    self.goodsPicImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.goodsPicImgView.autoresizesSubviews = YES;
    
    self.goodsPicImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    
    [self.goodsPicImgView cornerWithRadius:5.f];



}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    
    switch (sender.tag) {
        case 0:{//选择
            
 
            if ([self.delegate respondsToSelector:@selector(buttonsOnXMFShoppingCartCellDidClick:button:)]) {
                
                [self.delegate buttonsOnXMFShoppingCartCellDidClick:self button:sender];
            }
            
        }
            break;
            
        case 1:{//减
        
            
            static NSTimeInterval time = 0.0;
            
            NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
            
            //限制用户点击按钮的时间间隔大于1秒钟
            
            if (currentTime - time > 0.5) {
                
                //大于这个时间间隔就处理
                
                if ([self.delegate respondsToSelector:@selector(buttonsOnXMFShoppingCartCellDidClick:button:)]) {
                    
                    [self.delegate buttonsOnXMFShoppingCartCellDidClick:self button:sender];
                }
                
                
            }
            
            time = currentTime;
            
            
            
        }
            break;
            
        case 2:{//加
        
            
            static NSTimeInterval time = 0.0;
            
            NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
            
            //限制用户点击按钮的时间间隔大于1秒钟
            
            if (currentTime - time > 0.5) {
                
                //大于这个时间间隔就处理
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
    
    
    //选择按钮
    self.selectBtn.selected = [validModel.checked boolValue];
        

    //图片
    [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:validModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    //商品名称
    self.goodsNameLB.text = validModel.goodsName;
    
    
    //选中的商品类型
    self.goodTypeLB.text = @"";
    for (int i= 0; i < validModel.specifications.count; ++i) {
        
        self.goodTypeLB.text = [NSString stringWithFormat:@"%@  %@",self.goodTypeLB.text,validModel.specifications[i]];
        
    }
    
    /** 是否包税 0-否 1-是p */
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
        
        //税费
        self.taxFeeLB.text = [NSString stringWithFormat:@"税费 HK$ %@",[NSString removeSuffix:validModel.incomeTax]];
        
    }
    
    /** 是否包邮 0-否 1-是 */
    if ([validModel.freeShipping boolValue]) {
        
        self.postageTagLB.hidden = NO;
        
        self.postageFeeLB.hidden = YES;
        
    }else{
        
        self.postageTagLB.hidden = YES;
        
        self.postageFeeLB.hidden = NO;
        
        self.postageFeeLB.text = [NSString stringWithFormat:@"运费 HK$ %@",[NSString removeSuffix:validModel.postage]];

    }
    

    
    
    //实际价格
    self.actPriceLB.text = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:validModel.retailPrice]];
    
    //商品数量
    self.goodCountTfd.text = validModel.number;
    
    
    //当数量大于库存的时候显示
    if ([validModel.number integerValue] >= [validModel.stock integerValue]) {
        
        self.tipsLB.text = [NSString stringWithFormat:@"最多购买%@件",validModel.stock];
        
        [self.tipsLB topAlignment];
        
        self.tipsLB.hidden = NO;
        
        self.tipsLBHeight.constant = 28.f;

        
    }else{
        
        self.tipsLB.hidden = YES;
        
        self.tipsLBHeight.constant = 0.f;
        
    }
    
    
    //当商品数量大于存库数量时，加号按钮置灰
    if ([validModel.number integerValue] >= [validModel.stock integerValue]){
        
        self.addBtn.enabled = NO;
        
    }else{
        
        self.addBtn.enabled = YES;

    }
    
    
}


#pragma mark - ——————— 绑定方法 ————————
//通知绑定方法
-(void)textFieldDidChange: (UITextField *)textField{
    
    
    
}



/*
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        self.isHavePoint = NO;
    }
    
    
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            //首字母不能为0和小数点
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
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!self.isHavePoint)//text中还没有小数点
                {
                    self.isHavePoint = YES;
                    return NO;
                }else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (self.isHavePoint) {//存在小数点
                 
                        return NO;
                    
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
        // 第一位用户输入 0 但不包含小数点 用户输入完成后讲0截取掉
        if ([first isEqualToString:@"0"] && ![textField.text containsString:@"."]) {
            textField.text = [textField.text substringFromIndex:1];//
        }
        //第一位用户输入 0 也输入了小数点
        if ([first isEqualToString:@"0"] && [textField.text containsString:@"."]) {
            if([textField.text rangeOfString:@"."].location != NSNotFound) {
                NSRange range;
                range = [textField.text rangeOfString:@"."];
                // 小数点在0的后面
                if (range.location == 1) {
                    
                    //小数点不在0的后面
                } else if (range.location != 1) {
                    textField.text = nil;
                }
            } else {
            }
        }
    }
  
    
    
    //代理方法
    if ([self.delegate respondsToSelector:@selector(textFieldOnXMFShoppingCartCellEndInput:textField:)]) {
        
        [self.delegate textFieldOnXMFShoppingCartCellEndInput:self textField:textField];
    }
    
    

    
}*/


#pragma mark - ——————— UITextField的代理方法 ————————

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string{
    
    //限制只能输入纯数字
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
            
            [MBProgressHUD showOnlyTextToView:kAppWindow title:XMFLI(@"亲,实在不能再少了")];
            
            //商品数量
            self.goodCountTfd.text = self.validModel.number;
            
            return;
            
            
        }else if ([textField.text integerValue] > 999){
            
            [MBProgressHUD showOnlyTextToView:kAppWindow title:XMFLI(@"亲,实在不能再多了")];
            
            //商品数量
            self.goodCountTfd.text = self.validModel.number;
            
            return;
            
            
        }else{
            
            //代理方法
            if ([self.delegate respondsToSelector:@selector(textFieldOnXMFShoppingCartCellEndInput:textField:)]) {
                
                [self.delegate textFieldOnXMFShoppingCartCellEndInput:self textField:textField];
            }
            
        }
        
        
    }else{
        
        //商品数量
        self.goodCountTfd.text = self.validModel.number;
        
    }

    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
