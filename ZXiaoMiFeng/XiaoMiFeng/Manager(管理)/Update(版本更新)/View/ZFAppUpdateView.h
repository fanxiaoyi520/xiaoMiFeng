//
//  ZFAppUpdateView.h
//  ZFDaYaNews
//
//  Created by 小蜜蜂 on 2019/5/28.
//  Copyright © 2019 Jellyfish. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFAppUpdateView : UIView
@property (weak, nonatomic) IBOutlet UILabel *versionLB;
@property (weak, nonatomic) IBOutlet UILabel *notesLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBtnWidth;

-(void)show;

-(void)hide;

@property (nonatomic, copy) void (^updateBtnBlock)(UIButton *button);

@property (nonatomic, copy) void (^cancelBtnBlock)(UIButton *button);

@end

NS_ASSUME_NONNULL_END
