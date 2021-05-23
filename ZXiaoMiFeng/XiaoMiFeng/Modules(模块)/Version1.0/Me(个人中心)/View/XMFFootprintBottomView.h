//
//  XMFFootprintBottomView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/13.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFFootprintBottomView;

@protocol XMFFootprintBottomViewDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFFootprintBottomViewDidClick:(XMFFootprintBottomView *)bottomView button:(UIButton *)button;


@required//必须实现的方法

@end


@interface XMFFootprintBottomView : UIView

@property (weak, nonatomic) IBOutlet UIButton *allSelectedBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@property (nonatomic, weak) id<XMFFootprintBottomViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
