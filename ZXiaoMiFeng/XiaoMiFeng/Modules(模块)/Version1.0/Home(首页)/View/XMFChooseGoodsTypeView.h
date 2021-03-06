//
//  XMFChooseGoodsTypeView.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/4/26.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 
 1ãé¦é¡µ ââ åå«ï¼å®¢æï¼æ¶èï¼å å¥è´­ç©è½¦ï¼ç«å³è´­ä¹°ï¼
 2ãååè¯¦æé¡µ ââ ååéæ©ï¼åå«ï¼å å¥è´­ç©è½¦ï¼
 3ãååè¯¦æé¡µ ââ å å¥è´­ç©è½¦ï¼åå«ï¼ç¡®å®ï¼
 4ãååè¯¦æé¡µ ââ ç«å³è´­ä¹°ï¼åå«ï¼ç¡®å®è´­ä¹°ï¼
 
 */

typedef enum : NSUInteger {
    
    goodsListAddCart,
    goodsDetailChooseType,
    goodsDetailAddCart,
    goodsDetailSoonPay,
    
} chooseGoodsType;



@class XMFGoodsDatailModel;

@class XMFGoodsDatailProductListModel;

@class XMFChooseGoodsTypeView;

@protocol XMFChooseGoodsTypeViewDelegate<NSObject>

@optional//éæ©å®ç°çæ¹æ³

-(void)buttonsOnXMFChooseGoodsTypeViewDidClick:(XMFChooseGoodsTypeView *)typeView button:(UIButton *)button;


@required//å¿é¡»å®ç°çæ¹æ³

@end


@interface XMFChooseGoodsTypeView : UIView

//æ¶è
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

//æ°é
@property (weak, nonatomic) IBOutlet UITextField *amountTfd;

//ååè¯¦æmodel
@property (nonatomic, strong) XMFGoodsDatailModel *model;

//ç±»å
@property (nonatomic, assign) chooseGoodsType chooseType;

@property (nonatomic, weak) id<XMFChooseGoodsTypeViewDelegate> delegate;

-(void)show;

-(void)hide;

//éä¸­çåå
@property (nonatomic, copy) void (^ChooseGoodsTypeBlock)(XMFGoodsDatailProductListModel *productModel , NSString *selectedGoodCount);

//éä¸­çäº§åç±»åmodel
@property (nonatomic, strong) XMFGoodsDatailProductListModel *selectedProductModel;




@end

NS_ASSUME_NONNULL_END
