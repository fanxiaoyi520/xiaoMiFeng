//
//  XMFRefreshAutoNormalFooter.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/10.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFRefreshAutoNormalFooter.h"

@implementation XMFRefreshAutoNormalFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)prepare {
    [super prepare];
    
    [self setTitle:NSLocalizedString(@"点击或上拉加载更多", nil) forState:MJRefreshStateIdle];
    [self setTitle:NSLocalizedString(@"正在加载更多数据...", nil) forState:MJRefreshStateRefreshing];
    [self setTitle:NSLocalizedString(@"没有更多数据", nil) forState:MJRefreshStateNoMoreData];
    
    self.stateLabel.font = [UIFont systemFontOfSize:13.0];
    self.automaticallyRefresh = NO;
    self.automaticallyHidden = YES;
    self.refreshingTitleHidden = YES;
}

@end
