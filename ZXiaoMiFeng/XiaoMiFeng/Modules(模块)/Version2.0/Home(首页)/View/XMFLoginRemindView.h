//
//  XMFLoginRemindView.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/10/19.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFLoginRemindView : UIView

/** viewè¢«ç¹å»çblock */
@property (nonatomic, copy) void (^loginRemindViewTapBlock)(void);

@end

NS_ASSUME_NONNULL_END
