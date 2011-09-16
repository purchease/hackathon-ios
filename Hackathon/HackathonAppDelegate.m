//
//  HackathonAppDelegate.m
//  Hackathon
//
//  Created by Ludovic Galabru on 9/16/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "HackathonAppDelegate.h"
#import "Foursquare.h"
#import "FoursquareWebLogin.h"
#import "RestKit/RestKit.h"

@implementation HackathonAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    //	[Foursquare removeAccessToken];
	if ([Foursquare isNeedToAuthorize]) {
        /*
		[self authorizeWithViewController:viewController 
                                 Callback:^(BOOL success,id result){
                                     if (success) {
                                         [Foursquare  getDetailForUser:@"self"
                                                               callback:^(BOOL success, id result){
                                                                   if (success) {
                                                                       [self test_method];
                                                                   }
                                                               }];
                                     }
                                 }];
         */
	}else {
		/*
		[Foursquare  getDetailForUser:@"self"
							  callback:^(BOOL success, id result){
								  if (success) {
									  [self test_method];
								  }
							  }];
        
        //		Example check-in 
        //		[Foursquare  createCheckinAtVenue:@"6522771"
        //									 venue:nil
        //									 shout:@"Testing"
        //								 broadcast:broadcastPublic
        //								  latitude:nil
        //								 longitude:nil
        //								accuracyLL:nil
        //								  altitude:nil
        //							   accuracyAlt:nil
        //								  callback:^(BOOL success, id result){
        //								if (success) {
        //									NSLog(@"%@",result);
        //								}
        //							}];
         */
	}
    
	return YES;
}


-(void)test_method{
    NSLog(@"test");
}

FoursquareCallback authorizeCallbackDelegate;
-(void)authorizeWithViewController:(UIViewController*)controller
						  Callback:(FoursquareCallback)callback{
	authorizeCallbackDelegate = [callback copy];
	NSString *url = [NSString stringWithFormat:@"https://foursquare.com/oauth2/authenticate?display=touch&client_id=%@&response_type=code&redirect_uri=%@",OAUTH_KEY,REDIRECT_URL];
	FoursquareWebLogin *loginCon = [[FoursquareWebLogin alloc] initWithUrl:url];
	loginCon.delegate = self;
	loginCon.selector = @selector(setCode:);
	UINavigationController *navCon = [[UINavigationController alloc]initWithRootViewController:loginCon];
	
	[controller presentModalViewController:navCon animated:YES];
	[navCon release];
	[loginCon release];	
}

-(void)setCode:(NSString*)code{
	[Foursquare getAccessTokenForCode:code callback:^(BOOL success,id result){
		if (success) {
			[Foursquare setBaseURL:[NSURL URLWithString:@"https://api.foursquare.com/v2/"]];
			[Foursquare setAccessToken:[result objectForKey:@"access_token"]];
			authorizeCallbackDelegate(YES,result);
            [authorizeCallbackDelegate release];
		}
	}];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
