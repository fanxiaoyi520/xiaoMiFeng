//
//  XMFAlertController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/6.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFAlertController.h"



@interface XMFAlertController ()

/** 弹窗 **/
@property(nonatomic, strong) UIAlertController *alertController;

@end

@implementation XMFAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (void)acWithMessage:(NSString *)msg confirmBtnTitle:(NSString *)confirmTitle
{
    [self acWithTitle:@""
                               message:msg
                       confirmBtnTitle:confirmTitle
                        cancleBtnTitle:nil
                         confirmAction:nil
                          cancleAction:nil];
}


+ (void)acWithMessage:(NSString *)msg confirmBtnTitle:(NSString *)confirmTitle confirmAction:(void (^)(UIAlertAction *action))confirmAction
{
    // 弹窗
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    // 改变msg字体大小
    NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:msg];
    [messageAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, msg.length)];
    [alertvc setValue:messageAtt forKey:@"attributedMessage"];
    
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:confirmTitle style:0 handler:^(UIAlertAction * _Nonnull action) {
        confirmAction(action);
    }];
    [alertvc addAction:confirm];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertvc animated:YES completion:nil];
}


/**
 * 自定义title, 自定义"确定"按钮名称, "确定"按钮有动作的UIAlertController
 */
+ (void)acWithTitle:(NSString *)title message:(NSString *)msg confirmBtnTitle:(NSString *)confirmTitle confirmAction:(void (^)(UIAlertAction *action))confirmAction{
    
   // 弹窗
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    // 改变msg字体大小
    NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:msg];
    [messageAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, msg.length)];
    [alertvc setValue:messageAtt forKey:@"attributedMessage"];
    
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:confirmTitle style:0 handler:^(UIAlertAction * _Nonnull action) {
        confirmAction(action);
    }];
    [alertvc addAction:confirm];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertvc animated:YES completion:nil];
    
    
}


+ (void)acWithTitle:(NSString *)title msg:(NSString *)msg confirmBtnTitle:(NSString *)confirmTitle cancleBtnTitle:(NSString *)cancleTitle confirmAction:(void (^)(UIAlertAction *action))confirmAction
{
    [self acWithTitle:title
              message:msg
       confirmBtnTitle:confirmTitle
        cancleBtnTitle:cancleTitle
         confirmAction:^(UIAlertAction *action) {
             confirmAction(action);}
          cancleAction:^(UIAlertAction *action) {
              
          }];
}

// 基础的
+ (void)acWithTitle:(NSString *)title message:(NSString *)message confirmBtnTitle:(NSString *)confirmTitle cancleBtnTitle:(NSString *)cancleTitle confirmAction:(void (^)(UIAlertAction *action))confirmAction cancleAction:(void (^)(UIAlertAction *action))cancleAction {
    
    dispatch_async(dispatch_get_main_queue(), ^{
      
        // 弹窗
        UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        if (message) {
            // 改变msg字体大小
            NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:message];
            [messageAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, message.length)];
            [alertvc setValue:messageAtt forKey:@"attributedMessage"];
        }
        
        if (cancleTitle.length != 0) // 有确定按钮
        {
            // 取消按钮,有动作
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:cancleTitle style:0 handler:^(UIAlertAction * _Nonnull action) {
                cancleAction(action);
            }];
            [alertvc addAction:cancle];
            
            // 确定按钮,有动作
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:confirmTitle style:0 handler:^(UIAlertAction * _Nonnull action) {
                confirmAction(action);
            }];
            [alertvc addAction:confirm];
        } else  // 没有确定按钮
        {
            // 确定按钮,没动作
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:confirmTitle style:0 handler:nil];
            [alertvc addAction:confirm];
        }
        
        // 弹出
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertvc animated:YES completion:nil];
    });
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
