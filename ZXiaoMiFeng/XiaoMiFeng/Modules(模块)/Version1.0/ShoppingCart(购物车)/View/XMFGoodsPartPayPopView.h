//
//  XMFGoodsPartPayPopView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/6/2.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFShopCartDetailModel;

@class XMFGoodsPartPayPopView;

@protocol XMFGoodsPartPayPopViewDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFGoodsPartPayPopViewDidClick:(XMFGoodsPartPayPopView *)popView selectedButton:(UIButton *)button;

@required//必须实现的方法

@end


@interface XMFGoodsPartPayPopView : UIView


@property (weak, nonatomic) IBOutlet UIView *bgView;


//海外
@property (weak, nonatomic) IBOutlet UIButton *abroadGoodsBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *abroadGoodsBtnHeight;


//国内
@property (weak, nonatomic) IBOutlet UIButton *inlandBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inlandBtnHeight;


//奶粉
@property (weak, nonatomic) IBOutlet UIButton *milkGoodsBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *milkGoodsBtnHeight;


@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;


@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

//选中的cell的model数组
@property (nonatomic, strong) NSMutableArray<XMFShopCartDetailModel *> *selectedGoodsArr;

//选中的商品数量
@property (nonatomic, strong) NSMutableArray *selectedGoodsCountArr;

@property (nonatomic, weak) id<XMFGoodsPartPayPopViewDelegate> delegate;


-(void)show;

-(void)hide;

@end

NS_ASSUME_NONNULL_END
