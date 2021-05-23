//
//  XMFConfirmOrderFooterView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/2.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFConfirmOrderModel;

@interface XMFConfirmOrderFooterView : UIView

//留言
@property (weak, nonatomic) IBOutlet UITextView *messageTxW;

@property (nonatomic, strong) XMFConfirmOrderModel *orderModel;

@end

NS_ASSUME_NONNULL_END
