//
//  AppDelegate.m
//  DownloadTool
//
//  Created by wsl on 2020/11/18.
//

#import "AppDelegate.h"
#import "AppDelegate+DTHUD.h"
#import "DTTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setupHUD];
    [self setupCreatWindow];
    
    return YES;
}


- (void)setupCreatWindow{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    DTTabBarController *tabVC = [[DTTabBarController alloc] init];
    self.window.rootViewController = tabVC;
    [self.window makeKeyAndVisible];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"后台");
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    NSLog(@"从后台进入前台");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"程序被杀死");
}

@end
