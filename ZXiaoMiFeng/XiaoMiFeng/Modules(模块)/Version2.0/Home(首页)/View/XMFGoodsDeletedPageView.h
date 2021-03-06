//
//  XMFGoodsDeletedPageView.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/12/3.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeGoodsCellModel,XMFGoodsDeletedPageView,XMFHomeAllGoodsCell;


@protocol XMFGoodsDeletedPageViewDelegate<NSObject>

@optional//éæ©å®ç°çæ¹æ³

/** è¿åæé®è¢«ç¹å» */
-(void)buttonsOnXMFGoodsDeletedPageViewDidClick:(XMFGoodsDeletedPageView *)pageView button:(UIButton *)button;

/** é¡µé¢ä¸çcellè¢«ç¹å» */
-(void)cellOnXMFGoodsDeletedPageViewDidSelected:(XMFGoodsDeletedPageView *)pageView model:(XMFHomeGoodsCellModel *)model;


/** é¡µé¢ä¸cellçå å¥è´­ç©è½¦æé®è¢«ç¹å» */
-(void)addBtnOnCellDidClick:(XMFGoodsDeletedPageView *)pageView cell:(XMFHomeAllGoodsCell *)goodsCell button:(UIButton *)button indexPath:(NSIndexPath *)selectedIndexPath;



@required//å¿é¡»å®ç°çæ¹æ³

@end


@interface XMFGoodsDeletedPageView : UIView


@property (nonatomic, weak) id<XMFGoodsDeletedPageViewDelegate> delegate;

-(void)showOnView:(UIView *)view;

-(void)hide;


/** æ°æ®æ°ç» */
@property (nonatomic, strong) NSMutableArray<XMFHomeGoodsCellModel *> *dataSourceArr;

@end

NS_ASSUME_NONNULL_END
