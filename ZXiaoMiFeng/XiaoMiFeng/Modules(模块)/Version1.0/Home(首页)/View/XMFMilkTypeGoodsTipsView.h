//
//  XMFMilkTypeGoodsTipsView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/29.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFMilkTypeGoodsTipsView : UIView

@property (weak, nonatomic) IBOutlet UIView *bgView;

//描述Txw
@property (weak, nonatomic) IBOutlet UITextView *descTxw;


-(void)show;

-(void)hide;

@end

NS_ASSUME_NONNULL_END
