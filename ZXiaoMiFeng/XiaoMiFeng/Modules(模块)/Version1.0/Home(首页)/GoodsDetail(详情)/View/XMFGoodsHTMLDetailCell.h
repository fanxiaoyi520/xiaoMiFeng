//
//  XMFGoodsHTMLDetailCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/12.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFGoodsHTMLDetailModel;

@interface XMFGoodsHTMLDetailCell : UITableViewCell

@property (nonatomic, strong) XMFGoodsHTMLDetailModel *model;


@property(nonatomic, strong) WKWebView *webView;

@property(nonatomic, assign) CGFloat cell_height;

@property(nonatomic, copy) void (^WebLoadFinish)(CGFloat cell_h);

+ (id)creatCellWithTableView:(UITableView *)tableView;


@end

NS_ASSUME_NONNULL_END
