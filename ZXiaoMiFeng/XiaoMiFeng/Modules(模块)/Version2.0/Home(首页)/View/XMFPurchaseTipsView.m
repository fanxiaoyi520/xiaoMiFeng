//
//  XMFPurchaseTipsView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/25.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFPurchaseTipsView.h"
#import "XMFPurchaseTipsCell.h"
#import "XMFHomeGoodsDetailModel.h"


//在.m文件中添加
@interface  XMFPurchaseTipsView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;



@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;


@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myTableViewHeight;




@property (weak, nonatomic) IBOutlet UILabel *contentLB;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLBHeight;



@end

@implementation XMFPurchaseTipsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.backgroundColor = UIColorFromRGBA(0x000000, 0.7);
    
    
    self.myTableView.dataSource = self;
    
    self.myTableView.delegate = self;
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.myTableView.showsVerticalScrollIndicator = YES;
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFPurchaseTipsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XMFPurchaseTipsCell class])];
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.bgView cornerWithRadius:10.f direction:CornerDirectionTypeTopLeft | UIRectCornerTopRight];
    
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



//页面上的按钮被点击

- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    

    [self hide];
}



-(void)setContentStr:(NSString *)contentStr{
    
    _contentStr = contentStr;
    
    CGFloat contentLBHeight = [NSString getStrHeightWithFont:15.f withWidth:self.width withContentStr:contentStr];
    
    self.contentLB.text = contentStr;
    
    self.contentLBHeight.constant = contentLBHeight;
    
}


-(void)setInstructionsModelArr:(NSArray<XMFHomeGoodsDetailPurchaseInstructionsModel *> *)instructionsModelArr{
    
    _instructionsModelArr = instructionsModelArr;
    
    [self.myTableView reloadData];
    
}


#pragma mark - ——————— tableView的代理方法和数据源 ————————

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
//    return self.detailModel.purchaseInstructions.count;
    
    return self.instructionsModelArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    XMFPurchaseTipsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMFPurchaseTipsCell class])];
        

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    [self setModelOfCell:cell atIndexPath:indexPath];
    
    
    return cell;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    kWeakSelf(self)
    
    return [self.myTableView fd_heightForCellWithIdentifier:NSStringFromClass([XMFPurchaseTipsCell class]) configuration:^(XMFPurchaseTipsCell *cell) {
        
        [weakself setModelOfCell:cell atIndexPath:indexPath];
        
    }];
    
}

-(void)setModelOfCell:(XMFPurchaseTipsCell *)Cell atIndexPath:(NSIndexPath *)indexPath{
    
    
    Cell.cellRow = indexPath.row;
    
//    Cell.instructionsModel = self.detailModel.purchaseInstructions[indexPath.row];
    
    Cell.instructionsModel = self.instructionsModelArr[indexPath.row];

    
}


@end
