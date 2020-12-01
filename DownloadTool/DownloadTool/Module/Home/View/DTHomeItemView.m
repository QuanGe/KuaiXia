//
//  DTHomeItemView.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/12/1.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTHomeItemView.h"

@interface DTHomeItemView()

@property (nonatomic, strong) UILabel *titleTextLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *detailsTextLabel;

@end

@implementation DTHomeItemView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupItemViewUI];
    }
    return self;
}

- (void)setupItemViewUI{
    
}



#pragma mark - Lazy


@end
