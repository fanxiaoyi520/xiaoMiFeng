//
//  XMFOrdersHeaderFooterView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/6/18.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFOrdersCellModel;

@class XMFOrdersHeaderFooterView;

@protocol XMFOrdersHeaderFooterViewDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ


-(void)buttonsOnXMFOrdersHeaderFooterViewDidClick:(XMFOrdersHeaderFooterView *)footerView button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end


@interface XMFOrdersHeaderFooterView : UITableViewHeaderFooterView


@property (nonatomic, strong) XMFOrdersCellModel *orderModel;

//็ปๆฐ
@property (nonatomic, assign) NSInteger sectionNum;

@property (nonatomic, weak) id<XMFOrdersHeaderFooterViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
