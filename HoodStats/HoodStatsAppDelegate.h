//
//  HoodStatsAppDelegate.h
//  HoodStats
//
//  Created by Shannon Rush on 4/13/11.
//  Copyright 2011 Rush Devo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchXML.h"

@class HoodStatsViewController;

NSMutableDictionary *imageDictionary;

BOOL dataRetrieved;
UIColor *popColor;

@interface HoodStatsAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet HoodStatsViewController *viewController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+(BOOL)dataRetrieved;
+(void)setDataRetrieved:(BOOL)dataIsRetrieved;
+(NSMutableDictionary *)imageDictionary;
+(void)setImageDictionary:(NSMutableDictionary *)dictionary;
+(UIColor *)popColor;

@end
