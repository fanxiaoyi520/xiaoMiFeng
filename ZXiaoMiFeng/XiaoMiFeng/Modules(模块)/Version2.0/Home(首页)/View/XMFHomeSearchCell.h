//
//  XMFHomeSearchCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/3.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeSearchCell;

@protocol XMFHomeSearchCellDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFHomeSearchCellDidClick:(XMFHomeSearchCell *)cell button:(UIButton *)button;

@required//必须实现的方法

@end

@interface XMFHomeSearchCell : UICollectionViewCell

@property (nonatomic, copy) NSString *keywordStr;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id<XMFHomeSearchCellDelegate> delegate;

/** 是否选中按钮 */
@property (nonatomic, assign) BOOL isSelectedBtn;


@end

NS_ASSUME_NONNULL_END
