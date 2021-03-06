//
//  XMFGoodsHTMLDetailCell.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/5/12.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFGoodsHTMLDetailCell.h"
#import "XMFGoodsHTMLDetailModel.h"
//#import "BAKit_WebView.h"

//å¨.mæä»¶ä¸­æ·»å 
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
    
    
    // è®¾ç½®å­ä½å¤§å°ï¼å¾çå®½åº¦ééå±å¹ï¼é«åº¦èªéåº
    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                            "<head> \n"
                            "<style type=\"text/css\"> \n"
                            "body {font-size:36px;}\n"// å­ä½å¤§å°ï¼pxæ¯åç´ 
                            "</style> \n"
                            "</head> \n"
                            "<body>"
                            "<script type='text/javascript'>"
                            "window.onload = function(){\n"
                            "var $img = document.getElementsByTagName('img');\n"
                            "for(var p in  $img){\n"
                            "$img[p].style.width = '100%%';\n"// å¾çå®½åº¦
                            "$img[p].style.height ='auto'\n"// é«åº¦èªéåº
                            "}\n"
                            "}"
                            "</script>%@"
                            "</body>"
                            "</html>", model.contentHtml];
    
    //ä¿®æ¹HTMLæ ç­¾çé»è®¤å­ä½å¤§å°
//    htmls = [NSString stringWithFormat:@"<span style=\"font-size: %f\">%@</span>", 20.0, htmls];
    
    if (self.model.height == 100) {
        
//        [self.webView ba_web_loadHTMLString:htmls];
    }
    
    
}




#pragma mark - âââââââ æå è½½ ââââââââ


- (WKWebView *)webView{
    if (!_webView)
    {
//        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.webConfig];
        _webView = [WKWebView new];
//        _webView.ba_web_isAutoHeight = YES;
        //  æ·»å  WKWebView çä»£çï¼æ³¨æï¼ç¨æ­¤æ¹æ³æ·»å ä»£ç
//        BAKit_WeakSelf
//        [_webView ba_web_initWithDelegate:weak_self.webView uIDelegate:weak_self.webView];
        
        _webView.userInteractionEnabled = false;
        
//        self.webView.ba_web_getCurrentHeightBlock = ^(CGFloat currentHeight) {
//
//            BAKit_StrongSelf
//            self.cell_height = currentHeight;
//            NSLog(@"html é«åº¦2ï¼%f", currentHeight);
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
//            NSLog(@"html size:ï¼%@", NSStringFromCGSize(fittingSize));
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
