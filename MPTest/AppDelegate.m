//
//  AppDelegate.m
//  MPTest
//
//  Created by Jared McFarland on 1/21/15.
//  Copyright (c) 2015 Jared McFarland. All rights reserved.
//

#import "AppDelegate.h"
#import <Mixpanel/Mixpanel.h>
#import <AdSupport/AdSupport.h>

#define MIXPANEL_TOKEN @"4273def7ede898606e72925316938d92"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    NSString *data = @"event_bindings";
//    NSString *token = @"4273def7ede898606e72925316938d92";
//    NSString *filename = [NSString stringWithFormat:@"mixpanel-%@-%@.plist", token, data];
//    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]
//            stringByAppendingPathComponent:filename];
//    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        NSError *error;
//        BOOL removed = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
//        if (!removed) {
//            NSLog(@"%@ unable to remove archived file at %@ - %@", self, filePath, error);
//        }
//    }
//    
//    if (![NSKeyedArchiver archiveRootObject:[NSSet set] toFile:filePath]) {
//        NSLog(@"%@ unable to archive tracking events data", self);
//    }
    
    // Initialize the library with your
    // Mixpanel project token, MIXPANEL_TOKEN
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN launchOptions:launchOptions];
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        [[Mixpanel sharedInstance] trackPushNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
    }
    NSString * distinctID = [Mixpanel sharedInstance].distinctId;
    NSString * uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *ifa = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
    
    [[Mixpanel sharedInstance] identify:distinctID];
    [Mixpanel sharedInstance].showSurveyOnActive = NO;
    [Mixpanel sharedInstance].checkForSurveysOnActive = NO;
    
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge |
                                                                                                     UIUserNotificationTypeSound |
                                                                                                     UIUserNotificationTypeAlert)
                                                                                         categories:UIUserNotificationActionContextDefault];
    [[Mixpanel sharedInstance].people setOnce:@{@"$created":[NSDate date]}];
    
    [[Mixpanel sharedInstance].people append:@{@"Brand Names":@[@"Brand A", @"Brand B"]}];
    [[Mixpanel sharedInstance].people union:@{@"Brand Names":@[@"Brand A",@"Brand B",@"Brand C"]}];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[Mixpanel sharedInstance] track:@"applicationWillTerminate"];
    [[Mixpanel sharedInstance] archive];
    // NSLog(@"app delegate will terminate");
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    Mixpanel *mp = [Mixpanel sharedInstance];
    [mp.people addPushDeviceToken:deviceToken];
    [mp identify:mp.distinctId];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [[Mixpanel sharedInstance] trackPushNotification:userInfo];
}
@end
