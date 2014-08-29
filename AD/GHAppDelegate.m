//
//  GHAppDelegate.m
//  AD
//
//  Created by Gareth Harte on 29/01/2014.
//  Copyright (c) 2014 Gareth Harte. All rights reserved.
//

#import "GHAppDelegate.h"

@implementation GHAppDelegate (Private)

- (NSString *)plistFilePathForName:(NSString *)name
{
	return [[[NSBundle mainBundle] resourcePath]
			stringByAppendingPathComponent:name];
}
@end

@implementation GHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    sleep(2.3);
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.window.viewForBaselineLayout.alpha = 1; // and at this alpha
                     }
                     completion:^(BOOL finished){
                     }];


    
    return YES;
    
    
}

- (NSDictionary *)applicationFramesConfiguration
{
	static NSString *_plistFramesConfigFilePath;
    
	if (!_plistFramesConfigFilePath)
	{
		_plistFramesConfigFilePath = [self plistFilePathForName:@"FramesConfigurations.plist"];
	}
    NSDictionary *_applicationFramesConfiguration = nil;
	if (!_applicationFramesConfiguration)
	{
		_applicationFramesConfiguration = [[NSDictionary alloc] initWithContentsOfFile:_plistFramesConfigFilePath];
	}
    
	return _applicationFramesConfiguration;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.window.viewForBaselineLayout.alpha = 0; // and at this alpha
                     }
                     completion:^(BOOL finished){
                     }];
    
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        UIStoryboard *storyBoard;
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        CGFloat scale = [UIScreen mainScreen].scale;
        result = CGSizeMake(result.width * scale, result.height * scale);
        
        if(result.height != 1136){
            storyBoard = [UIStoryboard storyboardWithName:@"MainIphone4" bundle:nil];
            UIViewController *initViewController = [storyBoard instantiateInitialViewController];
            [self.window setRootViewController:initViewController];
        }
    }
    
    return YES;

    
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
