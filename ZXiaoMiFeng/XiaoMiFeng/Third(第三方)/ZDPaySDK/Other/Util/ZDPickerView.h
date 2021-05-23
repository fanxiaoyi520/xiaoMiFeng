//
//  ZFPickerView.h
//  Agent
//
//  Created by 中付支付 on 2018/9/11.
//  Copyright © 2018年 中付支付. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UIView+Frame.h"
@protocol ZDPickerViewDelegate <NSObject>
///tag 视图tag值   index 选择的序列
- (void)selectZDPickerViewTag:(NSInteger)tag index:(NSInteger)index;

@end

@interface ZDPickerView : UIView<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSArray *dataArray;
///不需要分割
@property (nonatomic, assign)BOOL notNeedSeparated;

@property (nonatomic, weak)id<ZDPickerViewDelegate>delegate;

- (void)show;

@end
