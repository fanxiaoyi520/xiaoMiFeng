//
//  XMFGoodsHTMLDetailCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/12.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsHTMLDetailCell.h"
#import "XMFGoodsHTMLDetailModel.h"
//#import "BAKit_WebView.h"

//在.m文件中添加
@interface  XMFGoodsHTMLDetailCell()

@end


@implementation XMFGoodsHTMLDetailCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
}

+(id)creatCellWithTableView:(UITableView *)tableView{
    
    XMFGoodsHTMLDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMFGoodsHTMLDetailCell class])];
    
    if (!cell) {
        
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([XMFGoodsHTMLDetailCell class])];
        
    }
    
    return cell;
    
}

- (void)setupUI{
    
//    self.webView.hidden = NO;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.webView.frame = self.bounds;
//    self.webView.scrollView.contentInset = UIEdgeInsetsMake(self.webView.scrollView.contentInset.top, 0, 0, 0);
//    self.webView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - self.webView.scrollView.contentInset.top);
}



-(void)setModel:(XMFGoodsHTMLDetailModel *)model{
    
    _model = model;
    
    
    // 设置字体大小，图片宽度适配屏幕，高度自适应
    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                            "<head> \n"
                            "<style type=\"text/css\"> \n"
                            "body {font-size:36px;}\n"// 字体大小，px是像素
                            "</style> \n"
                            "</head> \n"
                            "<body>"
                            "<script type='text/javascript'>"
                            "window.onload = function(){\n"
                            "var $img = document.getElementsByTagName('img');\n"
                            "for(var p in  $img){\n"
                            "$img[p].style.width = '100%%';\n"// 图片宽度
                            "$img[p].style.height ='auto'\n"// 高度自适应
                            "}\n"
                            "}"
                            "</script>%@"
                            "</body>"
                            "</html>", model.contentHtml];
    
    //修改HTML标签的默认字体大小
//    htmls = [NSString stringWithFormat:@"<span style=\"font-size: %f\">%@</span>", 20.0, htmls];
    
    if (self.model.height == 100) {
        
//        [self.webView ba_web_loadHTMLString:htmls];
    }
    
    
}




#pragma mark - ——————— 懒加载 ————————


- (WKWebView *)webView{
    if (!_webView)
    {
//        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.webConfig];
        _webView = [WKWebView new];
//        _webView.ba_web_isAutoHeight = YES;
        //  添加 WKWebView 的代理，注意：用此方法添加代理
//        BAKit_WeakSelf
//        [_webView ba_web_initWithDelegate:weak_self.webView uIDelegate:weak_self.webView];
        
        _webView.userInteractionEnabled = false;
        
//        self.webView.ba_web_getCurrentHeightBlock = ^(CGFloat currentHeight) {
//
//            BAKit_StrongSelf
//            self.cell_height = currentHeight;
//            NSLog(@"html 高度2：%f", currentHeight);
//
//            if (self.WebLoadFinish)
//            {
//                self.WebLoadFinish(self.cell_height);
//            };
//        };
        
       

        
//        self.webView.ba_web_didFinishBlock = ^(WKWebView * _Nonnull webView, WKNavigation * _Nonnull navigation) {
//
//            BAKit_StrongSelf
//
//            CGRect frame = webView.frame;
////            frame.size.height = 1;
////            webView.frame = frame;
//            CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
//            frame.size = fittingSize;
//            NSLog(@"html size:：%@", NSStringFromCGSize(fittingSize));
//            self.webView.frame = frame;
//
//            self.cell_height = fittingSize.height;
//
//            if (self.WebLoadFinish)
//            {
//                self.WebLoadFinish(self.cell_height);
//            };
//
//        };
        
        [self.contentView addSubview:_webView];
    }
    return _webView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
