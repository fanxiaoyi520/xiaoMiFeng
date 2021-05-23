//
//  XMFSearchHeaderView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/26.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFSearchHeaderView.h"
#import "UITextField+TextLeftOffset_ffset.h"

/*! leftView 的宽度  */
static NSInteger leftViewWidth = 30 ;
/*! 图片和label的间距 */
static NSInteger space = 15;

//在.m文件中添加
@interface  XMFSearchHeaderView()<UITextFieldDelegate>

/*! 默认文字 默认居中存在 */
@property(nonatomic,strong)UILabel *placeholderLabel;

/*! 方法镜图片 */
@property(nonatomic,strong)UIImageView *searchImage;

/*! 扫一扫 */
@property (nonatomic, strong) UIButton *scanBtn;

/*! 我的按钮 */
@property(nonatomic,strong)UIButton *cancelBtn;



/*! label文字大小 */
@property(nonatomic,assign)CGSize size;


@end

@implementation XMFSearchHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
       
        [self addSubview:self.textField];
        [self baseSetting];
        [_textField addSubview:self.placeholderLabel];
        [_textField addSubview:self.searchImage];
        [self setAllFrame];
        [self addSubview:self.cancelBtn];
        
//        [self addSubview:self.scanBtn];
        
    }
    return self;
}

/*! 基础配置 */

- (void)baseSetting{
    /*! 边框处理 */
    _textField.layer.cornerRadius = (self.frame.size.height - 10)/2;
    _textField.layer.masksToBounds = YES;
    /*! 字体其他 */
    _textField.font = [UIFont systemFontOfSize:14];
    _textField.backgroundColor = UIColorFromRGB(0xF6EFCB);
//    _textField.tintColor = UIColorFromRGB(0x333333);
    _textField.keyboardType = UIKeyboardTypeDefault;
    _textField.delegate =self;
    /*! 设置键盘return样式为搜索样式 */
    _textField.returnKeyType = UIReturnKeySearch;
    /*! 设置为无文字就灰色不可点 */
    _textField.enablesReturnKeyAutomatically = YES;
    /*! 开启系统清除样式 */
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    /*! 添加左边遮盖 */
    [_textField setTextOffsetWithLeftViewRect:CGRectMake(52, 0, leftViewWidth, self.frame.size.height) WithMode:UITextFieldViewModeAlways];
    /*! 编辑事件观察 */
    [_textField addTarget:self action:@selector(textFieldDidEditing:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark --- 懒加载

-(UIButton *)scanBtn{
    
    if (!_scanBtn) {
           _scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scanBtn.tag = 0;
           _scanBtn.frame = CGRectMake(0, 0, 52, self.frame.size.height);
        [_scanBtn addTarget:self action:@selector(buttonsOnViewDidClick:) forControlEvents:UIControlEventTouchUpInside];
         [_scanBtn setImage:[UIImage imageNamed:@"icon_common_return_white"] forState:UIControlStateNormal];
       }
       return _scanBtn;
    
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(15, 5, self.frame.size.width - 15 - 52, self.frame.size.height - 10)];
        //限制位数
        [_textField setValue:@36 forKey:@"LimitInput"];
    }
    return _textField;
}

- (UILabel *)placeholderLabel{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _placeholderLabel.text = @"请输入关键词";
        _placeholderLabel.textColor = UIColorFromRGB(0x333333);
        _placeholderLabel.font = [UIFont systemFontOfSize:14];
     
    }
    return _placeholderLabel;
}

- (UIImageView *)searchImage{
    if (!_searchImage) {
        _searchImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        _searchImage.image = [UIImage imageNamed:@"icon_home_search"];
    }
    return _searchImage;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.tag = 1;
        _cancelBtn.frame = CGRectMake(CGRectGetMaxX(_textField.frame), 0, 52, self.frame.size.height);
        [_cancelBtn addTarget:self action:@selector(buttonsOnViewDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
      
    }
    return _cancelBtn;
}

#pragma mark --- 设置尺寸
- (void)setAllFrame{
    _size = [_placeholderLabel.text boundingRectWithSize:CGSizeMake(500, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
    [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textField).offset(0);
        make.size.mas_equalTo(CGSizeMake(_size.width + 10, _textField.frame.size.height));
        make.centerX.equalTo(_textField);
    }];
    [_searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerX.mas_equalTo(_textField).offset(-space-_size.width/2);
        make.centerY.mas_equalTo(_textField);
    }];
    
}

#pragma mark - ——————— 扫描按钮点击事件 ————————

//页面上的按钮被点击
-(void)buttonsOnViewDidClick:(UIButton *)button{
    
    switch (button.tag) {
        case 0:{//返回
            
            [self scanAction:button];
            
        }
            break;
        case 1:{//取消
            
            [self cancelAction];
            
            if ([self.XMFSearchHeaderViewDelegate respondsToSelector:@selector(buttonsOnXMFSearchHeaderView:button:)]) {
                
                [self.XMFSearchHeaderViewDelegate buttonsOnXMFSearchHeaderView:self button:button];
            }
            
            
        }
            break;
            
        default:
            break;
    }
    
    
    
}


-(void)scanAction:(UIButton *)sender{
    
    
    if ([self.XMFSearchHeaderViewDelegate respondsToSelector:@selector(buttonsOnXMFSearchHeaderView:button:)]) {
        
        [self.XMFSearchHeaderViewDelegate buttonsOnXMFSearchHeaderView:self button:sender];
    }
    
}

#pragma mark --- 取消按钮点击事件

- (void)cancelAction{
    DLog(@"点击了取消");
    [self endEditing:YES];
    _placeholderLabel.hidden  = NO;
    _textField.text = @"";
    [_placeholderLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_textField);
    }];
    /*! _searchImage移动到关标左边 */
    [_searchImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_textField).offset(-space-_size.width/2);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        //        执行更新
        [self.textField layoutIfNeeded];
    }];
}

#pragma mark --- UITextFieldDelegate

/*! 当输入框开始编辑的时候 */
- (void)textFieldDidBeginEditing:(UITextField *)textField{
   
//    _textField.frame = CGRectMake(15, 5, self.frame.size.width - 15 - 52, self.frame.size.height - 10);
    
    /*! _placeholderLabel移动到关标右边*/
    [_placeholderLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_textField).offset(-_textField.frame.size.width/2 + leftViewWidth + _size.width/2 + 5);
    }];
    /*! _searchImage移动到关标左边 */
    [_searchImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_textField).offset(-_textField.frame.size.width/2-space+leftViewWidth);
    }];
    
    
    //更新返回按钮宽度和输入框的frame
//    _scanBtn.frame = CGRectMake(0, 0, 15, self.frame.size.height);
//    _scanBtn.hidden = YES;
    
    
    [UIView animateWithDuration:0.25 animations:^{
//        执行更新
        [self layoutIfNeeded];
    }];
    
}
/*! 输入框结束编辑 */
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    //更新返回按钮宽度和输入框的frame
//    _textField.frame = CGRectMake(52, 5, self.frame.size.width - 52 - 52, self.frame.size.height - 10);
//    _scanBtn.frame = CGRectMake(0, 0, 52, self.frame.size.height);
//    _scanBtn.hidden = NO;
    
    if (textField.text.length > 0) {
        DLog(@"进行搜索");
        [_XMFSearchHeaderViewDelegate searchWithStr:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_textField resignFirstResponder];
    [_XMFSearchHeaderViewDelegate searchWithStr:textField.text];
    DLog(@"点击了搜索");
    return YES;
}

#pragma mark --- textFieldDidEditing:
/*! 输入框编辑中 */

- (void)textFieldDidEditing:(UITextField *)textField{
    [self isHiddenLabel:textField];
}

- (void)isHiddenLabel:(UITextField *)textField{
    if (textField.text.length==0) {
        _placeholderLabel.hidden  = NO;
    }else{
        _placeholderLabel.hidden = YES;
    }
}
- (void)dealloc{
    DLog(@"%@ 已经dealloc",NSStringFromClass(self.class));
}

@end
