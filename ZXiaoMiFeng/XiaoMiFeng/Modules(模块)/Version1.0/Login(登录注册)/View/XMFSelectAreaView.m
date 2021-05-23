//
//  XMFSelectAreaView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/6/10.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFSelectAreaView.h"
#import "XMFAreaCode.h"


//在.m文件中添加
@interface  XMFSelectAreaView()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UIView *keywordsBgView;


@property (weak, nonatomic) IBOutlet UITextField *keywordTfd;


@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myTableViewHeight;

//现有的地区model数组
@property (nonatomic, strong) NSMutableArray<XMFAreaCode *> *nowAreaModelArr;


@end

@implementation XMFSelectAreaView

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
    
    self.myTableView.dataSource = self;
    
    self.myTableView.delegate = self;
    
    self.myTableView.tableFooterView = [[UIView alloc]init];
    
    
    //初始化一个无数据的emptyView 點擊重試
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_common_pic"
                                                             titleStr:@""
                                                            detailStr:XMFLI(@"暂无相关数据")
                                                          btnTitleStr:@""
                                                        btnClickBlock:^{
        
        
    }];
    
    emptyView.autoShowEmptyView = NO;
    
    
    self.myTableView.ly_emptyView = emptyView;
    
    
    self.keywordTfd.delegate = self;
    
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.keywordsBgView cornerWithRadius:self.keywordsBgView.height/2.0];
    
//    self.myTableViewHeight.constant = KScreenHeight * 0.4;
    
    
}


-(void)setAreaArr:(NSArray<XMFAreaCode *> *)areaArr{
    
    
    _areaArr = areaArr;
    
    self.nowAreaModelArr = [NSMutableArray arrayWithArray:areaArr];
    
    [self.myTableView ly_startLoading];
    
    [self.myTableView reloadData];
    
    [self.myTableView ly_endLoading];

}


//取消按钮被点击
- (IBAction)cancelBtnDidClick:(UIButton *)sender {
    
    [self hide];
    
}

//点击手势隐藏
- (IBAction)hideSelf:(UITapGestureRecognizer *)sender {
    
    
    //判断点击的点是否在某个区域范围内
    CGPoint tapPoint = [sender locationInView:self];
    
    CGRect bgViewRect = [self convertRect:self.myTableView.bounds fromView:self.myTableView];
    
    if (!CGRectContainsPoint(bgViewRect, tapPoint)) {
        
        [self hide];
        
    }
    
}



//显示在整个界面上
-(void)show{
    
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        self.frame = [UIScreen mainScreen].bounds;
        [keyWindow addSubview:self];
        
    }];
    
}

//隐藏弹框
-(void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}

#pragma mark - ——————— textField的代理方法 ————————

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSLog(@"文本框实时内容%@",text);
    
    //搜索框文本有值和无值的时候
    if (text.length > 0) {
        
        [self.nowAreaModelArr removeAllObjects];
        
        //搜索
        for (XMFAreaCode *areaModel in self.areaArr) {
            
            if ([areaModel.country containsString:text] || [areaModel.areaCode containsString:text]) {
                
                [self.nowAreaModelArr addObject:areaModel];
                
            }
            
            
        }
        
    }else{
        
        self.nowAreaModelArr = [NSMutableArray arrayWithArray:self.areaArr];
        
    }
    
    
    [self.myTableView ly_startLoading];
    
    [self.myTableView reloadData];
    
    [self.myTableView ly_endLoading];
    
    
    return YES;
}

//回车按钮
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    [textField resignFirstResponder];
    
    return YES;
    
}

//clearButtonMode清空代理方法
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    
    self.nowAreaModelArr = [NSMutableArray arrayWithArray:self.areaArr];
    
    [self.myTableView ly_startLoading];
    
    [self.myTableView reloadData];
    
    [self.myTableView ly_endLoading];
    
    return YES;
}

#pragma mark - ——————— tableview的代理方法和数据源 ————————

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.nowAreaModelArr.count;
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    XMFAreaCode *areaModel = self.nowAreaModelArr[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",areaModel.country,areaModel.areaCode];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //选中的地区
    if (_selectedAreaBlock) {
        _selectedAreaBlock(self.nowAreaModelArr[indexPath.row]);
        
    }
    
    [self hide];
    
}

#pragma mark - ——————— 懒加载 ————————

/*
-(NSMutableArray<XMFAreaCode *> *)nowAreaModelArr{
    
    if (_nowAreaModelArr == nil) {
        _nowAreaModelArr = [[NSMutableArray alloc] init];
    }
    return _nowAreaModelArr;
    
    
}*/



@end
