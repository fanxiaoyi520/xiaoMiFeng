//
//  XMFHomeGoodsSortView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/8.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeGoodsSortView,XMFHomeGoodsSortCell;

@protocol XMFHomeGoodsSortViewDelegate<NSObject>

@optional//选择实现的方法

-(void)cellOnXMFHomeGoodsSortViewDidSelected:(XMFHomeGoodsSortView *)sortView selectedDic:(NSMutableDictionary *)selectedTagDic seletedTitle:(NSString *)titleStr;

@required//必须实现的方法

@end

@interface XMFHomeGoodsSortView : UIView

-(void)showWithFrame:(CGRect)frame;

-(void)hide;

@property (nonatomic, weak) id<XMFHomeGoodsSortViewDelegate> delegate;

/** 弹框显示与隐藏 */
@property (nonatomic, copy) void (^GoodsSortViewIsShowBlock)(BOOL isShow);


@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

NS_ASSUME_NONNULL_END
