//
//  XMFHomeGoodsFilterView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/5.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//来自于哪里
typedef enum : NSUInteger {
    fromSearchResultVc,
    fromHomeSimpleVc,
} GoodsFilterViewFromType;


@class XMFHomeGoodsFilterView;

@protocol XMFHomeGoodsFilterViewDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFHomeGoodsFilterViewDidClick:(XMFHomeGoodsFilterView *)filterView button:(UIButton *)button selectedDic:(NSMutableDictionary *)selectedTagDic;

@required//必须实现的方法

@end

@interface XMFHomeGoodsFilterView : UIView

-(void)show;

-(void)hide;


@property (nonatomic, weak) id<XMFHomeGoodsFilterViewDelegate> delegate;

/** 自定义创建方法 */
+(instancetype)xibGoodsFilterViewFromType:(GoodsFilterViewFromType)type;


@end

NS_ASSUME_NONNULL_END
