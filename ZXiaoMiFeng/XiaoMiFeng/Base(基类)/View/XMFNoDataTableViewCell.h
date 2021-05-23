//
//  XMFNoDataTableViewCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/22.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFNoDataTableViewCell : UITableViewCell

//顶部间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;


//无数据图片
@property (weak, nonatomic) IBOutlet UIImageView *nodataImgView;

//无数据提示语
@property (weak, nonatomic) IBOutlet UILabel *nodataTipsLB;



@end

NS_ASSUME_NONNULL_END
