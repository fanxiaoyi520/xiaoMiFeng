//
//  XMFFootprintBottomView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/5/13.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFFootprintBottomView;

@protocol XMFFootprintBottomViewDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFFootprintBottomViewDidClick:(XMFFootprintBottomView *)bottomView button:(UIButton *)button;


@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end


@interface XMFFootprintBottomView : UIView

@property (weak, nonatomic) IBOutlet UIButton *allSelectedBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@property (nonatomic, weak) id<XMFFootprintBottomViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
