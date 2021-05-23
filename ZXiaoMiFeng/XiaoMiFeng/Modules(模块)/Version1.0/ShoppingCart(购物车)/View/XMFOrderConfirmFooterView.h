//
//  XMFOrderConfirmFooterView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/30.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFOrderConfirmModel;

@interface XMFOrderConfirmFooterView : UIView

@property (nonatomic, strong) XMFOrderConfirmModel *footerModel;

//留言
@property (weak, nonatomic) IBOutlet UITextView *messageTxW;


@end

NS_ASSUME_NONNULL_END
