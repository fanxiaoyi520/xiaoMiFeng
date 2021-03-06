//
//  XMFMyOrdersDetailHeaderView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/9/10.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFMyOrdersListModel,XMFOrdersLogisticsModel,XMFMyOrdersDetailHeaderView;

@protocol XMFMyOrdersDetailHeaderViewDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)viewsOnXMFGoodsDetailHeaderViewDidTap:(XMFMyOrdersDetailHeaderView *)headerView tapView:(UIView *)tapView;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end


@interface XMFMyOrdersDetailHeaderView : UIView

@property (nonatomic, strong) XMFMyOrdersListModel *detailModel;

/** ็ฉๆตๆฐๆฎmodel */
@property (nonatomic, strong) XMFOrdersLogisticsModel *logisticsModel;


@property (nonatomic, weak) id<XMFMyOrdersDetailHeaderViewDelegate> delegate;

/** ่ฎขๅ็ถๆๆ็คบ */
@property (weak, nonatomic) IBOutlet UILabel *orderTipsLB;

@end

NS_ASSUME_NONNULL_END
