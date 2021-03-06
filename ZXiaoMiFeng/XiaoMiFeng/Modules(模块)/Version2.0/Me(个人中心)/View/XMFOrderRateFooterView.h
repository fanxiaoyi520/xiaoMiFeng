//
//  XMFOrderRateFooterView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/9/13.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFOrderRateFooterView;

@protocol XMFOrderRateFooterViewDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFOrderRateFooterViewDidClick:(XMFOrderRateFooterView *)footerView button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end

@interface XMFOrderRateFooterView : UIView

@property (nonatomic, weak) id<XMFOrderRateFooterViewDelegate> delegate;


/** ๅฟๅ่ฏไปท */
@property (weak, nonatomic) IBOutlet UIButton *anonymousBtn;



@end

NS_ASSUME_NONNULL_END
