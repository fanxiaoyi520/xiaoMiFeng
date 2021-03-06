//
//  XMFGoodsPartPayPopView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/6/2.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFShopCartDetailModel;

@class XMFGoodsPartPayPopView;

@protocol XMFGoodsPartPayPopViewDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFGoodsPartPayPopViewDidClick:(XMFGoodsPartPayPopView *)popView selectedButton:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end


@interface XMFGoodsPartPayPopView : UIView


@property (weak, nonatomic) IBOutlet UIView *bgView;


//ๆตทๅค
@property (weak, nonatomic) IBOutlet UIButton *abroadGoodsBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *abroadGoodsBtnHeight;


//ๅฝๅ
@property (weak, nonatomic) IBOutlet UIButton *inlandBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inlandBtnHeight;


//ๅฅถ็ฒ
@property (weak, nonatomic) IBOutlet UIButton *milkGoodsBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *milkGoodsBtnHeight;


@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;


@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

//้ไธญ็cell็modelๆฐ็ป
@property (nonatomic, strong) NSMutableArray<XMFShopCartDetailModel *> *selectedGoodsArr;

//้ไธญ็ๅๅๆฐ้
@property (nonatomic, strong) NSMutableArray *selectedGoodsCountArr;

@property (nonatomic, weak) id<XMFGoodsPartPayPopViewDelegate> delegate;


-(void)show;

-(void)hide;

@end

NS_ASSUME_NONNULL_END
