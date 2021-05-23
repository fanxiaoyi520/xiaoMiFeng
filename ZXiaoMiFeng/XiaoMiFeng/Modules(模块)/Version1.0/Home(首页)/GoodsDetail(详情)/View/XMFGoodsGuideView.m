//
//  XMFGoodsGuideView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/10.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsGuideView.h"
#import "XMFGoodsGuideCell.h"
#import "XMFGoodsDatailModel.h"//商品详情model
#import "XMFGoodsDetailIssueModel.h"//购买说明model


//在.m文件中添加
@interface  XMFGoodsGuideView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;



@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;



@property (weak, nonatomic) IBOutlet KKPaddingLabel *contentLB;


@property (weak, nonatomic) IBOutlet UITableView *mytableView;


@end

@implementation XMFGoodsGuideView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
    
    self.mytableView.dataSource = self;
    
    self.mytableView.delegate = self;
    
    self.mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.mytableView.showsVerticalScrollIndicator = YES;
     
    
    [self.mytableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFGoodsGuideCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XMFGoodsGuideCell class])];
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
}


-(void)setDetailModel:(XMFGoodsDatailModel *)detailModel{
    
    _detailModel = detailModel;
    
    [self.mytableView reloadData];
    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    [self hide];
}


//显示在整个界面上
-(void)show{
    
    //可以底部弹出
    [UIView animateWithDuration:0.3 animations:^{
        
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
           self.frame = [UIScreen mainScreen].bounds;
           [keyWindow addSubview:self];
        
        
        self.bgView.centerY = self.bgView.centerY - CGRectGetHeight(self.bgView.frame);

        
    } completion:^(BOOL finished) {
        
       
        
    }];
    
}

//隐藏弹框
-(void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bgView.centerY = self.bgView.centerY+CGRectGetHeight(self.bgView.frame);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}


//隐藏弹框
- (IBAction)hideSelf:(UITapGestureRecognizer *)sender {
    
    //判断点击的点是否在某个区域范围内
    CGPoint tapPoint = [sender locationInView:self];
    
    CGRect bgViewRect = [self convertRect:self.bgView.bounds fromView:self.bgView];
    
    if (!CGRectContainsPoint(bgViewRect, tapPoint)) {
        
        [self hide];
        
    }
    
 
    
}


#pragma mark - ——————— tableview的代理方法和数据源 ————————

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.detailModel.issue.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    XMFGoodsGuideCell *guideCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMFGoodsGuideCell class])];
    
    guideCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self setModelOfCell:guideCell atIndexPath:indexPath];
    
        
    return guideCell;
       
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    kWeakSelf(self)
    
    
    return [self.mytableView fd_heightForCellWithIdentifier:NSStringFromClass([XMFGoodsGuideCell class]) configuration:^(XMFGoodsGuideCell *cell) {
        
        [weakself setModelOfCell:cell atIndexPath:indexPath];
        
    }];
        
    
}



-(void)setModelOfCell:(XMFGoodsGuideCell *)Cell atIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row < self.detailModel.issue.count) {
        
        
        XMFGoodsDetailIssueModel *issueModel = self.detailModel.issue[indexPath.row];
        
        //人工修改序号
        issueModel.issueId = [NSString stringWithFormat:@"%zd",indexPath.row + 1];
       
        Cell.model = issueModel;
        
    }

}


@end
