//
//  XMFAlertController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/6.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFAlertController : UIAlertController

/**
 *  自定义"确定"按钮名称, "确定"按钮没有动作的UIAlertController
 */
+ (void)acWithMessage:(NSString *)msg confirmBtnTitle:(NSString *)confirmTitle;


/**
 *  自定义"确定"按钮名称, "确定"按钮有动作的UIAlertController
 */
+ (void)acWithMessage:(NSString *)msg confirmBtnTitle:(NSString *)confirmTitle confirmAction:(void (^)(UIAlertAction *action))confirmAction;


/**
 * 自定义title, 自定义"确定"按钮名称, "确定"按钮有动作的UIAlertController
 */
+ (void)acWithTitle:(NSString *)title message:(NSString *)msg confirmBtnTitle:(NSString *)confirmTitle confirmAction:(void (^)(UIAlertAction *action))confirmAction;


/**
 *  自定义title, "确定"按钮,"取消"按钮, "确定"按钮有动作的UIAlertController
 */
+ (void)acWithTitle:(NSString *)title msg:(NSString *)msg confirmBtnTitle:(NSString *)confirmTitle cancleBtnTitle:(NSString *)cancleTitle confirmAction:(void (^)(UIAlertAction *action))confirmAction;


/**
 *  自定义title,"确定"按钮,"取消"按钮, 点击按钮都有动作的的UIAlertController
 */
+ (void)acWithTitle:(NSString *)title message:(NSString *)message confirmBtnTitle:(NSString *)confirmTitle cancleBtnTitle:(NSString *)cancleTitle confirmAction:(void (^)(UIAlertAction *action))confirmAction cancleAction:(void (^)(UIAlertAction *action))cancleAction;


@end

NS_ASSUME_NONNULL_END
