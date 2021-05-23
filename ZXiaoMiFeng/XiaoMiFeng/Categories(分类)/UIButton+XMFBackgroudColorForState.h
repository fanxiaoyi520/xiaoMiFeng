//
//  UIButton+XMFBackgroudColorForState.h
//  gofun
//
//  Created by 邹花平 on 2016/11/16.
//  Copyright © 2016年 邹花平. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (XMFBackgroudColorForState)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@property (nonatomic, strong) NSString * titleName;

@end
