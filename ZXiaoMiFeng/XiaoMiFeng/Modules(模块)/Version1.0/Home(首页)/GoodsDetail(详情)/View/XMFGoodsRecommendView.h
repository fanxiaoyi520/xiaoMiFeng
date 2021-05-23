//
//  XMFGoodsRecommendView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFGoodsRecommendModel;
@class XMFGoodsRecommendView;

@protocol XMFGoodsRecommendViewDelegate<NSObject>

@optional//选择实现的方法

-(void)goodsRecommendCellOnXMFGoodsRecommendViewDidSelected:(XMFGoodsRecommendView *)recommendView recommendModel:(XMFGoodsRecommendModel *)recommendModel;

@required//必须实现的方法

@end



@interface XMFGoodsRecommendView : UIView

@property (nonatomic, strong) NSMutableArray *dataSourceArr;


@property (nonatomic, weak) id<XMFGoodsRecommendViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
