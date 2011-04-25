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
    
    // Get zip code from lat long for Zillow call
    NSURL *locURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/xml?latlng=%f,%f&sensor=true",newLocation.coordinate.latitude,newLocation.coordinate.longitude]];
    CXMLDocument *locXML = [[[CXMLDocument alloc] initWithContentsOfURL:locURL options:0 error:nil] autorelease];
    NSLog(@"%@",locXML);
    NSString *locCity = [[[locXML nodesForXPath:@"/GeocodeResponse/result[1]/address_component[type/text()='locality']/long_name"error:nil]objectAtIndex:0]stringValue];
    NSString *locState = [[[locXML nodesForXPath:@"/GeocodeResponse/result[1]/address_component[type/text()='administrative_area_level_1']/short_name"error:nil]objectAtIndex:0]stringValue];
    location = [self location:locCity withState:locState];
    
    // remove existing historyItems for location if any
    NSSet *historyItems = [location valueForKeyPath:@"HistoryItems"];
    if ([historyItems count]>0) {
        HoodStatsAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        for (NSManagedObject *item in historyItems) {
            [context deleteObject:item];
        }
    }
    
    // get data from Zillow
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.zillow.com/webservice/GetDemographics.htm?zws-id=X1-ZWz1bvq9sepl3f_90hcq&city=%@&state=%@",locCity,locState]];
    CXMLDocument *xml = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
    NSLog(@"%@",xml);
    NSMutableArray *data = [[NSMutableArray alloc]init];
    
    //lat long
    NSString *latitude = [[[xml nodesForXPath:@"//latitude" error:nil]objectAtIndex:0]stringValue];
    NSString *longitude = [[[xml nodesForXPath:@"//longitude" error:nil]objectAtIndex:0]stringValue];
    
    [data addObject:[NSDictionary dictionaryWithObjectsAndKeys:latitude,@"latitude",longitude,@"longitude",nil]];
    
    // City
    NSString *city = [[[xml nodesForXPath:@"//city" error:nil]objectAtIndex:0]stringValue];
    [data addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@               %@                   %@",city,city,city],@"label",nil]];
    
    //Median Single Family Home
    NSString *medianHomeValue = [[[xml nodesForXPath:@"//attribute[name='Median Single Family Home Value']/values/city/value" error:nil]objectAtIndex:0]stringValue];
    [data addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"$%@",medianHomeValue] ,@"value",@"Average Single Family Home",@"label",nil]];
    
    //Median List Price
    NSString *medianListPrice = [[[xml nodesForXPath:@"//attribute[name='Median List Price']/values/city/value" error:nil]objectAtIndex:0]stringValue];
    [data addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"$%@",medianListPrice] ,@"value",@"Average List Price",@"label",nil]];
    
    //Median Sale Price
    NSString *medianSalePrice = [[[xml nodesForXPath:@"//attribute[name='Median Sale Price']/values/city/value" error:nil]objectAtIndex:0]stringValue];
    [data addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"$%@",medianSalePrice] ,@"value",@"Average Sale Price",@"label",nil]];
    
    //Median Household Income
    NSString *medianHouseholdIncome = [[[xml nodesForXPath:@"//attribute[name='Median Household Income']/values/city/value" error:nil]objectAtIndex:0]stringValue];
    [data addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"$%@",medianHouseholdIncome] ,@"value",@"Average Household Income",@"label",nil]];
    
    //Single Males
    NSString *maleString = [[[xml nodesForXPath:@"//attribute[name='Single Males']/values/city/value" error:nil]objectAtIndex:0]stringValue];
    int malePercent = round([maleString floatValue]*100);
    NSString *singleMales = [NSString stringWithFormat:@"%i%%",malePercent];
    [data addObject:[NSDictionary dictionaryWithObjectsAndKeys:singleMales,@"value",@"Single Guys",@"label",nil]];
    
    //Single Females
    NSString *femaleString = [[[xml nodesForXPath:@"//attribute[name='Single Females']/values/city/value" error:nil]objectAtIndex:0]stringValue];
    int femalePercent = round([femaleString floatValue]*100);
    NSString *singleFemales = [NSString stringWithFormat:@"%i%%",femalePercent];
    [data addObject:[NSDictionary dictionaryWithObjectsAndKeys:singleFemales,@"value",@"Single Ladies",@"label",nil]];
    
    //Median Age
    NSString *medianAge = [[[xml nodesForXPath:@"//attribute[name='Median Age']/values/city/value" error:nil]objectAtIndex:0]stringValue];
    [data addObject:[NSDictionary dictionaryWithObjectsAndKeys:medianAge,@"value",@"Average Age",@"label",nil]];
    
    for (NSDictionary *item in data) {
        if ([[item allKeys]containsObject:@"value"]) 
            [self saveHistoryItem:[item objectForKey:@"label"] withValue:[item objectForKey:@"value"]];
    }
    
    //TODO: Finish gathering data
    NSMutableArray *returnData = [NSMutableArray arrayWithArray:data];
    [data release];
    return returnData;
}

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
        return [objects objectAtIndex:0];
    } else {
        NSManagedObject *locationObject = [NSEntityDescription
                                           insertNewObjectForEntityForName:@"Location" 
                                           inManagedObjectContext:context];
        [locationObject setValue:city forKey:@"city"];
        [locationObject setValue:state forKey:@"state"];
        [locationObject setValue:[NSDate date] forKey:@"timestamp"];
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
            return;
        }
        return locationObject;
    }
}

-(void)saveHistoryItem:(NSString *)label withValue:(NSString *)value {
    HoodStatsAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
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
    HoodStatsAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *photoObject = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
    NSData *imageData = UIImagePNGRepresentation(screenshot);
    [photoObject setValue:imageData forKey:@"image"];
    [photoObject setValue:location forKey:@"location"];
    [photoObject setValue:[NSDate date] forKey:@"timestamp"];
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
        return;
    }
}


@end

