//
//  XMFRefreshNormalHeader.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/10.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFRefreshNormalHeader.h"

@implementation XMFRefreshNormalHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)prepare {
    
    [super prepare];
    
    [self setTitle:NSLocalizedString(@"下拉刷新数据", nil) forState:MJRefreshStateIdle];
    [self setTitle:NSLocalizedString(@"松开立即刷新", nil) forState:MJRefreshStatePulling];
    [self setTitle:NSLocalizedString(@"加载中...", nil) forState:MJRefreshStateRefreshing];
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.font = [UIFont systemFontOfSize:13.0];
    [self isAutomaticallyChangeAlpha];
}

@end
