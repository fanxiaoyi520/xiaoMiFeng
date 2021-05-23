//
//  XMFLoginRemindView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/10/19.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFLoginRemindView : UIView

/** view被点击的block */
@property (nonatomic, copy) void (^loginRemindViewTapBlock)(void);

@end

NS_ASSUME_NONNULL_END
