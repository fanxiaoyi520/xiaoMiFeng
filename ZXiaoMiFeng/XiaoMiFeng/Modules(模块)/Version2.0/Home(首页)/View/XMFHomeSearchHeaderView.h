//
//  XMFXMFHomeSearchHeaderView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/3.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFHomeSearchHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (nonatomic, copy) void (^buttonsClickBlock)(UIButton *button);

@end

NS_ASSUME_NONNULL_END
