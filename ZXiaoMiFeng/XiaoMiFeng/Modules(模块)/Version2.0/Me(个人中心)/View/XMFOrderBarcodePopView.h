//
//  XMFOrderBarcodePopView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2021/1/22.
//  Copyright © 2021 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFMyOrdersListModel;


@interface XMFOrderBarcodePopView : UIView

-(void)show;

-(void)hide;

@property (nonatomic, strong) XMFMyOrdersListModel *detailModel;


@end

NS_ASSUME_NONNULL_END
