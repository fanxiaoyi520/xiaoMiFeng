//
//  XMFAddressListCell.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/5/6.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFAddressListModel;

@class XMFAddressListCell;

@protocol XMFAddressListCellDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFAddressListCellDidClick:(XMFAddressListCell *)cell button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end

@interface XMFAddressListCell : UITableViewCell


@property (nonatomic, strong) XMFAddressListModel *model;

@property (nonatomic, weak) id<XMFAddressListCellDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
