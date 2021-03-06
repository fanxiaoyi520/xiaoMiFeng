//
//  XMFMyDeliveryAddressCell.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/9/9.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFMyDeliveryAddressModel,XMFMyDeliveryAddressCell;

@protocol XMFMyDeliveryAddressCellDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ


-(void)buttonsOnXMFMyDeliveryAddressCellDidClick:(XMFMyDeliveryAddressCell *)cell button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end

@interface XMFMyDeliveryAddressCell : UITableViewCell

@property (nonatomic, strong) XMFMyDeliveryAddressModel *addressModel;

@property (nonatomic, weak) id<XMFMyDeliveryAddressCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
