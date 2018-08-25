//
//  AppDelegate.m
//  Restaurants
//
//  Created by anthony volkov on 7/19/18.
//  Copyright © 2018 playgendary. All rights reserved.
//

#import "AppDelegate.h"
#import "InitialViewController.h"
#import "FavoritesViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.tabBar.backgroundImage = [UIImage imageNamed:@"2Fav.png"];
    tabBarController.tabBar.tintColor = [UIColor blackColor];
    
    if (@available(iOS 10.0, *)) {
        [tabBarController.tabBar setUnselectedItemTintColor:[UIColor grayColor]];
    } else {
        // Fallback on earlier versions
    }
    
    
    UINavigationController *rootViewController = [[UINavigationController alloc] initWithRootViewController:[[InitialViewController alloc] init]];
    rootViewController.tabBarItem.image = [UIImage imageNamed:@"restaurants-icon.png"];
    rootViewController.tabBarItem.title = @"Restaurants";
    [rootViewController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1Res.png"] forBarMetrics:UIBarMetricsDefault];
    
    UINavigationController *favoritesViewController = [[UINavigationController alloc] initWithRootViewController:[[FavoritesViewController alloc] init]];
    favoritesViewController.tabBarItem.image = [UIImage imageNamed:@"star.png"];
    favoritesViewController.tabBarItem.title = @"Favorites";
    [favoritesViewController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1Res.png"] forBarMetrics:UIBarMetricsDefault];
    
    NSMutableArray *viewControllersArray = [[NSMutableArray alloc] initWithCapacity:2];
    [viewControllersArray addObject:rootViewController];
    [viewControllersArray addObject:favoritesViewController];
    
    tabBarController.viewControllers = viewControllersArray;
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
