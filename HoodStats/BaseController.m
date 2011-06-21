//
//  BaseController.m
//  HoodStats
//
//  Created by Shannon Rush on 4/13/11.
//  Copyright 2011 Rush Devo. All rights reserved.
//

#import "BaseController.h"
#import "HoodStatsAppDelegate.h"


@implementation BaseController

-(NSMutableArray *)getData:(CLLocation *)newLocation {
    
    // Get city/state from lat long for Zillow call
    NSURL *locURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/xml?latlng=%f,%f&sensor=true",newLocation.coordinate.latitude,newLocation.coordinate.longitude]];
    CXMLDocument *locXML = [[[CXMLDocument alloc] initWithContentsOfURL:locURL options:0 error:nil] autorelease];
    NSMutableString *locCity = [NSMutableString stringWithString:@"Cupertino"];
    NSMutableString *locState = [NSMutableString stringWithString:@"CA"];
    if ([[locXML nodesForXPath:@"/GeocodeResponse/result[1]/address_component[type/text()='locality']/long_name"error:nil]count]>0 && [[locXML nodesForXPath:@"/GeocodeResponse/result[1]/address_component[type/text()='administrative_area_level_1']/short_name"error:nil]count]>0) {
        [locCity setString:[[[locXML nodesForXPath:@"/GeocodeResponse/result[1]/address_component[type/text()='locality']/long_name"error:nil]objectAtIndex:0]stringValue]];
        [locState setString:[[[locXML nodesForXPath:@"/GeocodeResponse/result[1]/address_component[type/text()='administrative_area_level_1']/short_name"error:nil]objectAtIndex:0]stringValue]];
    }
    
    location = [self location:locCity withState:locState];
        
    // get data from Zillow
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.zillow.com/webservice/GetDemographics.htm?zws-id=X1-ZWz1bvq9sepl3f_90hcq&city=%@&state=%@",locCity,locState]];
    CXMLDocument *xml = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
    NSMutableArray *data = [[NSMutableArray alloc]init];
    
    // City
    if ([[xml nodesForXPath:@"//city" error:nil]count]>0) {
        NSString *city = [[[xml nodesForXPath:@"//city" error:nil]objectAtIndex:0]stringValue];
        [data addObject:[NSDictionary dictionaryWithObjectsAndKeys:city,@"city",nil]];
    }
    
    //Median Single Family Home
    if ([[xml nodesForXPath:@"//attribute[name='Median Single Family Home Value']/values/city/value" error:nil]count]>0) {
        NSString *medianHomeValue = [[[xml nodesForXPath:@"//attribute[name='Median Single Family Home Value']/values/city/value" error:nil]objectAtIndex:0]stringValue];
        [data addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"$%@",medianHomeValue] ,@"value",@"Average Single Family Home",@"label",nil]];
    }
    
    //Median List Price
    if ([[xml nodesForXPath:@"//attribute[name='Median List Price']/values/city/value" error:nil]count]>0) {
        NSString *medianListPrice = [[[xml nodesForXPath:@"//attribute[name='Median List Price']/values/city/value" error:nil]objectAtIndex:0]stringValue];
        [data addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"$%@",medianListPrice] ,@"value",@"Average List Price",@"label",nil]];
    }
    
    
    //Median Sale Price
    if ([[xml nodesForXPath:@"//attribute[name='Median Sale Price']/values/city/value" error:nil]count]>0) {
        NSString *medianSalePrice = [[[xml nodesForXPath:@"//attribute[name='Median Sale Price']/values/city/value" error:nil]objectAtIndex:0]stringValue];
        [data addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"$%@",medianSalePrice] ,@"value",@"Average Sale Price",@"label",nil]];
    }
    
    //Median Household Income
    if ([[xml nodesForXPath:@"//attribute[name='Median Household Income']/values/city/value" error:nil]count]>0) {
        NSString *medianHouseholdIncome = [[[xml nodesForXPath:@"//attribute[name='Median Household Income']/values/city/value" error:nil]objectAtIndex:0]stringValue];
        [data addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"$%@",medianHouseholdIncome] ,@"value",@"Average Household Income",@"label",nil]];
    }
        
    //Single Males
    if ([[xml nodesForXPath:@"//attribute[name='Single Males']/values/city/value" error:nil]count]>0) {
        NSString *maleString = [[[xml nodesForXPath:@"//attribute[name='Single Males']/values/city/value" error:nil]objectAtIndex:0]stringValue];
        int malePercent = round([maleString floatValue]*100);
        NSString *singleMales = [NSString stringWithFormat:@"%i%%",malePercent];
        [data addObject:[NSDictionary dictionaryWithObjectsAndKeys:singleMales,@"value",@"Single Guys",@"label",nil]];
    }

    //Single Females
    if ([[xml nodesForXPath:@"//attribute[name='Single Females']/values/city/value" error:nil]count]>0) {
        NSString *femaleString = [[[xml nodesForXPath:@"//attribute[name='Single Females']/values/city/value" error:nil]objectAtIndex:0]stringValue];
        int femalePercent = round([femaleString floatValue]*100);
        NSString *singleFemales = [NSString stringWithFormat:@"%i%%",femalePercent];
        [data addObject:[NSDictionary dictionaryWithObjectsAndKeys:singleFemales,@"value",@"Single Ladies",@"label",nil]];
    }

    //Median Age
    if ([[xml nodesForXPath:@"//attribute[name='Median Age']/values/city/value" error:nil]count]>0) {
        NSString *medianAge = [[[xml nodesForXPath:@"//attribute[name='Median Age']/values/city/value" error:nil]objectAtIndex:0]stringValue];
        [data addObject:[NSDictionary dictionaryWithObjectsAndKeys:medianAge,@"value",@"Average Age",@"label",nil]];
    }

    for (NSDictionary *item in data) {
        if ([[item allKeys]containsObject:@"value"]) 
            [self saveHistoryItem:[item objectForKey:@"label"] withValue:[item objectForKey:@"value"]];
    }
    
    NSMutableArray *returnData = [NSMutableArray arrayWithArray:data];
    [data release];
    return returnData;
}

#pragma mark custom

-(NSManagedObject *)location:(NSString *)city withState:(NSString *)state {
    HoodStatsAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(city = %@ and state = %@)", city, state];	
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    [request release];
    if ([objects count]>0) {
        // remove existing historyItems for location if any
        NSSet *historyItems = [[objects objectAtIndex:0] valueForKeyPath:@"HistoryItems"];
        if ([historyItems count]>0) {
            for (NSManagedObject *item in historyItems) {
                [[item managedObjectContext] deleteObject:item];
            }
        }

        [[objects objectAtIndex:0]setValue:[NSDate date] forKey:@"timestamp"];
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        return [objects objectAtIndex:0];
    } else {
        NSManagedObject *locationObject = [NSEntityDescription
                                           insertNewObjectForEntityForName:@"Location" 
                                           inManagedObjectContext:[appDelegate managedObjectContext]];
        [locationObject setValue:city forKey:@"city"];
        [locationObject setValue:state forKey:@"state"];
        [locationObject setValue:[NSDate date] forKey:@"timestamp"];
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        return locationObject;
    }
}

-(void)saveHistoryItem:(NSString *)label withValue:(NSString *)value {
    HoodStatsAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *itemObject = [NSEntityDescription insertNewObjectForEntityForName:@"HistoryItem" inManagedObjectContext:context];
    [itemObject setValue:value forKey:@"value"];
    [itemObject setValue:label forKey:@"label"];
    [itemObject setValue:location forKey:@"location"];
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
        return;
    }
}

-(void)savePhoto:(UIImage *)screenshot {
    HoodStatsAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *photoObject = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
    NSData *imageData = UIImagePNGRepresentation(screenshot);
    NSData *thumbnailData = UIImagePNGRepresentation([self thumbnail:screenshot]);
    [photoObject setValue:imageData forKey:@"image"];
    [photoObject setValue:thumbnailData forKey:@"thumbnail"];
    [photoObject setValue:location forKey:@"location"];
    [photoObject setValue:[NSDate date] forKey:@"timestamp"];
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
        return;
    } else {
        [self performSelectorInBackground:@selector(addPhotoToImageArray:) withObject:screenshot];
    }
}

-(void)addPhotoToImageArray:(UIImage *)screenshot {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop run];
    while (![HoodStatsAppDelegate imageArray]) {
        NSLog(@"Trying to save, waiting...");
    }
    NSString *locationString = [self locationString:location];
    UIImage *thumbnail = [self thumbnail:screenshot];
    NSDictionary *photoDictionary = [NSDictionary dictionaryWithObjectsAndKeys:screenshot,@"image",thumbnail,@"thumbnail",nil];
    NSString *dateString = [self dateString:[NSDate date]];

    BOOL locationExists;
    for (NSDictionary *locDict in [HoodStatsAppDelegate imageArray]) {
        if ([[locDict allKeys] containsObject:locationString]) {
            locationExists = YES;
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K==%@",@"date",dateString];
            NSArray *results = [[locDict objectForKey:locationString] filteredArrayUsingPredicate:pred];
            if ([results count]==0) {
                // add a dictionary with keys date (object dateString) and photos (object array with photoDictionary) 
                NSMutableDictionary *dateDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:dateString,@"date", 
                                                 [NSMutableArray arrayWithObject:photoDictionary],@"photos",
                                                 nil];
                // add date dictionary to location Array
                [[locDict objectForKey:locationString] insertObject:dateDict atIndex:0];
            } else {
                [[[results objectAtIndex:0]objectForKey:@"photos"]insertObject:photoDictionary atIndex:0];
            }
        }
    }
    if (!locationExists) {
        // create a location dictionary with key location string and date array with object dictionary with keys date (object dateString) and photos (object array with photoDictionary)
        NSMutableArray *photoArray = [NSMutableArray arrayWithObject:photoDictionary];
        NSMutableDictionary *dateDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:dateString,@"date",
                                          photoArray,@"photos",nil];
        NSMutableArray *dateArray = [NSMutableArray arrayWithObject:dateDict];
        [[HoodStatsAppDelegate imageArray]addObject:[NSMutableDictionary dictionaryWithObject:dateArray forKey:locationString]];
    }
    [pool release];
}

-(NSString *)locationString:(NSManagedObject *)theLocation {
    return [NSString stringWithFormat:@"%@, %@",[theLocation valueForKey:@"city"],[theLocation valueForKey:@"state"]];
}

-(NSString *)dateString:(NSDate *)date {
    NSDateFormatter *dateFormat =[[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterLongStyle]; // May 8, 1977
    NSString *dateString = [dateFormat stringFromDate:date];   
    [dateFormat release];
    return dateString;
}
        
-(NSArray *)locations {
    HoodStatsAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [request setEntity:entityDesc];
	[request setSortDescriptors:[NSArray arrayWithObject:dateSort]];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    [request release];
    [dateSort release];
    return objects;
}

-(void)initImages {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
	[runLoop run];
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSManagedObject *selectedLocation in [self locations]) {
        NSString *locationString = [self locationString:selectedLocation];
        NSMutableDictionary *locDict = [NSMutableDictionary dictionaryWithObject:[NSMutableArray array] forKey:locationString];
        NSMutableArray *locationPhotos = [NSMutableArray arrayWithArray:[[selectedLocation valueForKey:@"Photos"] allObjects]];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
        [locationPhotos sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        [sortDescriptor release];
        for (NSManagedObject *photo in locationPhotos) {
            NSString *dateString = [[self dateString:[photo valueForKey:@"timestamp"]]retain];
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == %@",@"date",dateString];
            NSArray *results = [[locDict objectForKey:locationString]filteredArrayUsingPredicate:pred];
            if ([results count]==0) {
                [[locDict objectForKey:locationString]addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:dateString,@"date",[NSMutableArray array],@"photos",nil]];
            }
            UIImage *image = [UIImage imageWithData:[photo valueForKey:@"image"]];
            UIImage *thumbnail = [UIImage imageWithData:[photo valueForKey:@"thumbnail"]];
            NSDictionary *photoDictionary = [NSDictionary dictionaryWithObjectsAndKeys:image,@"image",thumbnail,@"thumbnail",nil];
            NSMutableArray *photoArray = [[[locDict objectForKey:locationString]lastObject]objectForKey:@"photos"];
            [photoArray addObject:photoDictionary];
        }
        [imageArray addObject:locDict];
    }
    [HoodStatsAppDelegate setImageArray:imageArray];
    [pool release];
}

-(UIImage *)thumbnail:(UIImage *)image {
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 0, 640.0, 640.0));
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef]; 
    CGImageRelease(imageRef);

    CGSize newSize = CGSizeMake(64.0, 64.0);
    UIGraphicsBeginImageContext(CGSizeMake(newSize.width, newSize.height));
    [croppedImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return thumbnail;
}
 

@end

