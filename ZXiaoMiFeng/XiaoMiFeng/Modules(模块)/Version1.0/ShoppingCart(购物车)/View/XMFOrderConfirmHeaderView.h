//
//  XMFOrderConfirmHeaderView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/4/30.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFOrderConfirmModel;

@class XMFOrderConfirmHeaderView;

@class XMFAddressListModel;

@protocol XMFOrderConfirmHeaderViewDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)tapGestureOnXMFOrderConfirmHeaderViewDidTap:(XMFOrderConfirmHeaderView *)headerView;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end

@interface XMFOrderConfirmHeaderView : UIView

@property (nonatomic, strong) XMFOrderConfirmModel *headerModel;

//ๅฐๅๅ่กจ็model
@property (nonatomic, strong) XMFAddressListModel *addressListModel;

@property (nonatomic, weak) id<XMFOrderConfirmHeaderViewDelegate> delegate;

//่ฏฆ็ปๅฐๅ
@property (weak, nonatomic) IBOutlet UILabel *addressLB;

@end

NS_ASSUME_NONNULL_END
