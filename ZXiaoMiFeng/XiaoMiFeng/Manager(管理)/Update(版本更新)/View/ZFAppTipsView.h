//
//  ZFAppTipsView.h
//  ZFDaYaNews
//
//  Created by 小蜜蜂 on 2019/6/4.
//  Copyright © 2019 Jellyfish. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFAppTipsView : UIView
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLB;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

-(void)show;

-(void)hide;

@end

NS_ASSUME_NONNULL_END
