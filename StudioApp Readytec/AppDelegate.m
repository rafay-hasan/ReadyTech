//
//  AppDelegate.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 10/23/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "AppDelegate.h"
#import "User Details.h"
#import "RHWebServiceManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        NSLog(@"TESTING: %@", @"Anwar");
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeNewsstandContentAvailability| UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        NSLog(@"TESTING: %@", @"SUmon");
    }
    

    
    return YES;
}

#pragma mark push notification


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /*
     [[[UIAlertView alloc]initWithTitle:@"Notification" message:@"Registered for notification" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
     */
    
    //By Anwar
    //Stripping < > and spaces from token string
    NSString* myToken = [[[NSString stringWithFormat:@"%@",deviceToken]
                          stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    NSString *thisToken = [NSString stringWithFormat: @"%@", myToken];
    
    [[NSUserDefaults standardUserDefaults] setObject:thisToken forKey:@"bbs_device_token"];
    
    //Just temporary to check if device gets its token
    NSLog(@"My token is: %@", thisToken);
    
    
}


- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    [[[UIAlertView alloc]initWithTitle:@"Notification" message:err.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    NSString* userDetailsID = [User_Details sharedInstance].userDetailsId ;
    
    NSLog(@"userid: %@", userDetailsID);
    
    
    
    NSString *alertValue = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    NSLog(@"value for key alert: %@", alertValue);
    
    NSNumber *num = [[userInfo valueForKey:@"aps"] valueForKey:@"push_type"];
    int push_type = [num intValue];
    
    //if([userDetailsID isEqual: [NSNull null]])
    if(userDetailsID.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login"
                                                        message:@"Esegui il login per tutti gli aggiornamenti"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
        NSString* userTypeIDStringValue = [User_Details sharedInstance].userTypeId ;
        int userTypeID = [userTypeIDStringValue intValue];
        
        if(push_type==3)//3 means Event
        {
            //Event
            NSNumber *operation_num = [[userInfo valueForKey:@"aps"] valueForKey:@"push_operation"];
            int push_operation = [operation_num intValue];
            
            if(push_operation==1)//1 means new
            {
                NSString *pushTitle = @"Nuovo evento!";
                NSString *events_name = [[userInfo valueForKey:@"aps"] valueForKey:@"events_name"];
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pushTitle
                                                                message:events_name
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
            
            
            
        }
        else if(push_type==1)//1 PUSH_TYPE_NEWS
        {
            NSString *pushTitle = @"Nuova News!";
            NSString *news_title = [[userInfo valueForKey:@"aps"] valueForKey:@"news_title"];
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pushTitle
                                                            message:news_title
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else if(push_type==2)//2 SERVICE UPDATE
        {
            NSString *service_id_string = [NSString stringWithFormat:@"%@",[[userInfo valueForKey:@"aps"] valueForKey:@"ref_services_update_services_id"]];
            
            
            
            
            if(userTypeID==1)//UserType is Admin
            {
                NSString *request_url=[NSString stringWithFormat:@"%@app_service_active_for_studio/%@/%@/%@", BASE_URL_API,[User_Details sharedInstance].userDetailsId,[User_Details sharedInstance].studio_Details_ID,service_id_string];
                
                //Working with db
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:request_url]];
                NSLog(@"request%@",request);
                NSError         * e;
                
                NSData      *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&e];
                
                NSError *jsonError = nil;
                id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                
                NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
                
                if([[jsonDictionary objectForKey:@"login_status"] isEqualToNumber:[NSNumber numberWithInt:1]])
                {
                    if([[jsonDictionary objectForKey:@"studio_has_this_service"] isEqualToNumber:[NSNumber numberWithInt:1]])
                    {
                        NSString *pushTitle = @"Nuovo aggiornamento disponibile!";
                        NSString *services_update_title = [[userInfo valueForKey:@"aps"] valueForKey:@"services_update_title"];
                        
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pushTitle
                                                                        message:services_update_title
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }
                    else
                    {
                        //This service update not for this user
                        
                        
                        NSString *pushTitle = @"Nuova notifica";
                        NSString *services_update_title = @"Vedi tutti gli aggiornamenti per te";
                        
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pushTitle
                                                                        message:services_update_title
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                        
                    }
                    
                }
            }
            else if(userTypeID==2)//UserType is User
            {
                
                NSString *request_url=[NSString stringWithFormat:@"%@app_service_active_for_user/%@/%@", BASE_URL_API,[User_Details sharedInstance].userDetailsId,service_id_string];
                
                
                //Working with db
                
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:request_url]];
                
                NSError         * e;
                
                NSData      *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&e];
                
                NSError *jsonError = nil;
                id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                
                NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
                
                if([[jsonDictionary objectForKey:@"login_status"] isEqualToNumber:[NSNumber numberWithInt:1]])
                {
                    if([[jsonDictionary objectForKey:@"user_has_this_service"] isEqualToNumber:[NSNumber numberWithInt:1]])
                    {
                        NSString *pushTitle = @"Nuovo aggiornamento disponibile!";
                        NSString *services_update_title = [[userInfo valueForKey:@"aps"] valueForKey:@"services_update_title"];
                        
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pushTitle
                                                                        message:services_update_title
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }
                    else
                    {
                        
                        //This service update not for this user
                        
                        
                        NSString *pushTitle = @"Nuova notifica";
                        NSString *services_update_title = @"Vedi tutti gli aggiornamenti per te";
                        
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pushTitle
                                                                        message:services_update_title
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                        
                    }
                }
                else
                {//User is not active
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problema nella fase di login"
                                                                    message:@"Esegui il logout e prova ad eseguire il login di nuovo"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problema nella fase di login"
                                                                message:@"segui il logout e prova ad eseguire il login di nuovo"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
            
            
            
        }
        else if(push_type==4)//4 Message
        {
            if(userTypeID==2)//UserType is User
            {
                //No message option for normal users
                
                NSString *pushTitle = @"Nuova notifica";
                NSString *title = @"Vedi tutti gli aggiornamenti per te";
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pushTitle
                                                                message:title
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
            else if(userTypeID==1)//UserType is Admin
            {
                NSNumber *push_message_type_num = [[userInfo valueForKey:@"aps"] valueForKey:@"push_message_type"];
                int push_message_type = [push_message_type_num intValue];
                
                if(push_message_type==1)//General or Normal message
                {
                    //General message
                    //This message for all kind of admin
                    
                    NSString *pushTitle = @"Nuovo messaggio!";
                    NSString *title = [[userInfo valueForKey:@"aps"] valueForKey:@"message_title"];
                    
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pushTitle
                                                                    message:title
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                else if(push_message_type==2)//Studio Message
                {
                    NSNumber *studio_details_id_num = [[userInfo valueForKey:@"aps"] valueForKey:@"studio_details_id"];
                    int studio_details_id = [studio_details_id_num intValue];
                    if([User_Details sharedInstance].studio_Details_ID.intValue ==studio_details_id)
                    {
                        NSString *pushTitle = @"Nuovo messaggio!";
                        NSString *title = [[userInfo valueForKey:@"aps"] valueForKey:@"message_title"];
                        
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pushTitle
                                                                        message:title
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                    }
                    else
                    {
                        
                        //No message option for normal users
                        
                        NSString *pushTitle = @"Nuova notifica";
                        NSString *title = @"Vedi tutti gli aggiornamenti per te";
                        
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pushTitle
                                                                        message:title
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                    }
                }
                else if(push_message_type==3)//message by services
                {
                    NSString *service_id_string = [NSString stringWithFormat:@"%@",[[userInfo valueForKey:@"aps"] valueForKey:@"service_id"]];
                    
                    NSString *request_url=[NSString stringWithFormat:@"%@app_service_active_for_studio/%@/%@/%@", BASE_URL_API,[User_Details sharedInstance].userDetailsId,[User_Details sharedInstance].studio_Details_ID,service_id_string];
                    
                    //Working with db
                    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:request_url]];
                    NSLog(@"request%@",request);
                    NSError         * e;
                    
                    NSData      *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&e];
                    
                    NSError *jsonError = nil;
                    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                    
                    NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
                    
                    if([[jsonDictionary objectForKey:@"login_status"] isEqualToNumber:[NSNumber numberWithInt:1]])
                    {
                        if([[jsonDictionary objectForKey:@"studio_has_this_service"] isEqualToNumber:[NSNumber numberWithInt:1]])
                        {
                            NSString *pushTitle = @"Nuovo messaggio!";
                            NSString *title = [[userInfo valueForKey:@"aps"] valueForKey:@"message_title"];
                            
                            
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pushTitle
                                                                            message:title
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                            [alert show];
                        }
                    }
                }
                
                
            }
            else
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problema nella fase di login"
                                                                message:@"segui il logout e prova ad eseguire il login di nuovo"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
            
        }
        else if(push_type==5)//5 training
        {
            
            NSString *pushTitle = @"Nuovo corso disponibile!";
            NSString *training_course_title = [[userInfo valueForKey:@"aps"] valueForKey:@"training_course_title"];
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pushTitle
                                                            message:training_course_title
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
        else if(push_type==6)//6 offfer
        {
            if(userTypeID==1)//UserType is Admin
            {
                NSString *pushTitle = @"Nuova offerta!";
                NSString *offer_title = [[userInfo valueForKey:@"aps"] valueForKey:@"offer_title"];
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pushTitle
                                                                message:offer_title
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else{
                
                NSString *pushTitle = @"Nuova notifica";
                NSString *title = @"Vedi tutti gli aggiornamenti per te";
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pushTitle
                                                                message:title
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
            
            
            
            
        }
        else if(push_type==7)//7 ticket
        {
            NSNumber *ticket_user_details_id_num = [[userInfo valueForKey:@"aps"] valueForKey:@"user_details_id"];
            int ticket_user_details_id = [ticket_user_details_id_num intValue];
            
            if([User_Details sharedInstance].userDetailsId.intValue==ticket_user_details_id)
            {
                NSString *pushTitle = @"Stato del ticket aggiornato!";
                NSString *ticket_id = [[userInfo valueForKey:@"aps"] valueForKey:@"ticket_id"];
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pushTitle
                                                                message:ticket_id
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else{
                
                NSString *pushTitle = @"-";
                NSString *ticket_id = @"Vedi tutti gli aggiornamenti per te";
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pushTitle
                                                                message:ticket_id
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
            
        }
    }
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
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"StudioApp_Readytec"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
