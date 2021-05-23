//
//  XMFShoppingSplitOrdersView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2021/1/27.
//  Copyright © 2021 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFShoppingSplitOrdersModel,XMFShoppingSplitOrdersView;

@protocol XMFShoppingSplitOrdersViewDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFShoppingSplitOrdersViewDidClick:(XMFShoppingSplitOrdersView *)splitOrdersView button:(UIButton *)button;

@required//必须实现的方法

@end


@interface XMFShoppingSplitOrdersView : UIView

-(void)show;

-(void)hide;

/** 需要拆分的商品数据数组 */
@property (nonatomic, strong) NSArray<XMFShoppingSplitOrdersModel *> *dataSourceArr;


/**
 *  按钮选中,中间值
 */
@property (nonatomic,strong) UIButton *selectedBtn;

/** 选择的row */
@property (nonatomic, assign) NSInteger selectedIndexPathRow;


@property (nonatomic, weak) id<XMFShoppingSplitOrdersViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
