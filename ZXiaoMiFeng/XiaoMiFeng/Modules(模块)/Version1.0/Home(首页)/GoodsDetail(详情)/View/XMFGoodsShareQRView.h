//
//  XMFGoodsShareQRView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/11.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFGoodsDatailModel;

@interface XMFGoodsShareQRView : UIView

-(void)show;

-(void)hide;

@property (nonatomic, strong) XMFGoodsDatailModel *detailModel;

@end

NS_ASSUME_NONNULL_END
