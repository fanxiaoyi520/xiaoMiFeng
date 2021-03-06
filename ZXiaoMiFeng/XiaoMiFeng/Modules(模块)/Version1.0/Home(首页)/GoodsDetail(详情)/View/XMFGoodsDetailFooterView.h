//
//  XMFGoodsDetailFooterView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/5/8.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFGoodsDetailFooterView;
@class XMFGoodsDatailModel;


@protocol XMFGoodsDetailFooterViewDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFGoodsDetailFooterViewDidClick:(XMFGoodsDetailFooterView *)footerView button:(UIButton *)button;


@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end


@interface XMFGoodsDetailFooterView : UIView

@property (nonatomic, weak) id<XMFGoodsDetailFooterViewDelegate> delegate;

@property (nonatomic, strong) XMFGoodsDatailModel *detailModel;

@end

NS_ASSUME_NONNULL_END
