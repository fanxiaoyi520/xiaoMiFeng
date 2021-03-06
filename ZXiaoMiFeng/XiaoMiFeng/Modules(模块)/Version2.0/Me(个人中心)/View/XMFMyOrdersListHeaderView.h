//
//  XMFMyOrdersListHeaderView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/8/31.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFMyOrdersListModel,XMFMyOrdersListHeaderView;

@protocol XMFMyOrdersListHeaderViewDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFMyOrdersListHeaderViewDidClick:(XMFMyOrdersListHeaderView *)headerView button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end

@interface XMFMyOrdersListHeaderView : UIView

@property (nonatomic, strong) XMFMyOrdersListModel *listModel;

@property (nonatomic, weak) id<XMFMyOrdersListHeaderViewDelegate> delegate;

/** ็ปๅซ */
@property (nonatomic, assign) NSInteger headerViewSection;


@end

NS_ASSUME_NONNULL_END
