//
//  DTTextView.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTTextView.h"

@implementation DTTextView

- (instancetype)init{
    if (self = [super init]) {
        [self addNotification];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addNotification];
    }
    return self;
}

//文本内容改变时发布通知
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textchange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textchange{
    //重新绘制
    [self setNeedsDisplay];
}

//这个方法每次执行会先把之前绘制的去掉
- (void)drawRect:(CGRect)rect{
    //self.hasText这个是判断textView上是否输入了东东
    if(!self.hasText){
        //文字的属性
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        //设置字体大小
        dict[NSFontAttributeName] = self.font;
        //设置字体颜色
        dict[NSForegroundColorAttributeName] = self.placeColor;
        //画文字(rect是textView的bounds）
        CGRect textRect = CGRectMake(5, 8, rect.size.width-10, rect.size.height-16);
        [self.placeholder drawInRect:textRect withAttributes:dict];
    }
}

@end
