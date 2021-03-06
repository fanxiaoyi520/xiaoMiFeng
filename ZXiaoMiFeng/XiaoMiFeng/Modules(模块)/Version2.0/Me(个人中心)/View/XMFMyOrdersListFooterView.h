//
//  XMFMyOrdersListFooterView.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/8/31.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFMyOrdersListModel,XMFMyOrdersListFooterCell,XMFMyOrdersListFooterView;

@protocol XMFMyOrdersListFooterViewDelegate<NSObject>

@optional//éæ©å®ç°çæ¹æ³

//viewä¸çcellè¢«ç¹å»
-(void)cellOnXMFMyOrdersListFooterViewDidSelected:(XMFMyOrdersListFooterView *)footerView cell:(XMFMyOrdersListFooterCell *)cell;


//viewä¸çæé®è¢«ç¹å»
-(void)buttonsOnXMFMyOrdersListFooterViewDidClick:(XMFMyOrdersListFooterView *)footerView button:(UIButton *)button;


@required//å¿é¡»å®ç°çæ¹æ³

@end

@interface XMFMyOrdersListFooterView : UIView

/** ç»å« */
@property (nonatomic, assign) NSInteger footerViewSection;

@property (nonatomic, strong) XMFMyOrdersListModel *listModel;

@property (nonatomic, weak) id<XMFMyOrdersListFooterViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
