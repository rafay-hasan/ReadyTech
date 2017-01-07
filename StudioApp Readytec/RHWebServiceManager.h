//
//  RHWebServiceManager.h
//  MCP
//
//  Created by Rafay Hasan on 9/7/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define BASE_URL_API @"http://app.hiredaweb.it/"


enum {
    HTTPRequestTypeGeneralMessages,
    HTTPRequestTypeStudioMessages,
    HTTPRequestTypeUpComingCourses,
    HTTPRequestTypeOngoingCourses,
    HTTPRequestTypeOngoingEvents,
    HTTPRequestTypUpcomingEvents,
    HTTPRequestypeNews,
    HTTPRequestypeOffer,
    HTTPRequestypLogin,
    HTTPRequestypeAllWebservice,
    HTTPRequestypeMyWebservice,
    HTTPRequestypeUserAllWebservice,
    HTTPRequestypeServiceDetails,
    HTTPRequestypeAddRemoveService,
    HTTPRequestypeUsersWebService,
    HTTPRequestypeEditUsersWebService,
    HTTPRequestypeUserActiveDeactivateWebService,
    HTTPRequestypeUserProfile,
    HTTPRequestypeAdminProfile,
    HTTPRequestypTickets,
    HTTPRequestypTicketDetails,
    HTTPRequestypeMakeServiceRead
    
    
};
typedef NSUInteger HTTPRequestType;


@protocol RHWebServiceDelegate <NSObject>

@optional

-(void) dataFromWebReceivedSuccessfully:(id) responseObj;
-(void) dataFromWebReceiptionFailed:(NSError*) error;
-(void) dataFromWebDidnotReceiveSuccessMessage:( id )responseObj;


@end


@interface RHWebServiceManager : NSObject

@property (nonatomic, retain) id <RHWebServiceDelegate> delegate;


@property (readwrite, assign) HTTPRequestType requestType;

-(id) initWebserviceWithRequestType: (HTTPRequestType )reqType Delegate:(id) del;

-(void)getDataFromWebURL:(NSString *)requestURL;

-(void)getPostDataFromWebURLWithUrlString:(NSString *)requestURL dictionaryData:(NSDictionary *)postDataDic;


@end
