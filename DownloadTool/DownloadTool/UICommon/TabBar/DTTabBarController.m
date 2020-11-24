//
//  DTTabBarController.m
//  DownloadTool
//
//  Created by wsl on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTTabBarController.h"
#import "DTNavigationController.h"
#import "DTHomeViewController.h"
#import "DTDownloadViewController.h"
#import "DTMineViewController.h"

@interface DTTabBarController () <UITabBarControllerDelegate>

@end

@implementation DTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    [self addAllChildViewController];
}


#pragma mark - ADD
- (void)addAllChildViewController{
    [self addChildViewController:[[DTHomeViewController alloc] init] title:@"首页"
                      imageNamed:@"tabBar_home" selectImage:@"tabBar_home_sel"];
    [self addChildViewController:[[DTDownloadViewController alloc] init] title:@"传输"
                      imageNamed:@"tabBar_down" selectImage:@"tabBar_down_sel"];
    [self addChildViewController:[[DTMineViewController alloc] init] title:@"我的"
                      imageNamed:@"tabBar_mine" selectImage:@"tabBar_mine_sel"];
}

- (void)addChildViewController:(UIViewController *)vc title:(NSString *)title imageNamed:(NSString *)imageNamed selectImage:(NSString *)selImgNamed{
    DTNavigationController *navigationVC = [[DTNavigationController alloc] initWithRootViewController:vc];
    [self controller:vc title:title tabBarItemImage:imageNamed tabBarItemSelectedImage:selImgNamed];
    [self addChildViewController:navigationVC];
}

- (void)controller:(UIViewController *)controller title:(NSString *)title tabBarItemImage:(NSString *)image tabBarItemSelectedImage:(NSString *)selectedImage{
    controller.title = title;
    controller.tabBarItem.image = [UIImage imageNamed:image];
    UIImage *imageHome = [UIImage imageNamed:selectedImage];
    imageHome = [imageHome imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [controller.tabBarItem setSelectedImage:imageHome];
    NSDictionary *dictHome = [NSDictionary dictionaryWithObject:DTRGB(58, 68, 219) forKey:NSForegroundColorAttributeName];
    [controller.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateSelected];
}



#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}

@end
