//
//  InfoViewController.m
//  HoodStats
//
//  Created by Shannon Rush on 4/14/11.
//  Copyright 2011 Rush Devo. All rights reserved.
//

#import "InfoViewController.h"
#import "HoodStatsAppDelegate.h"
#import "GalleryViewController.h"


@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLocations];
    infoTable.backgroundColor = [UIColor clearColor];
    infoTable.backgroundView = nil;
    infoTable.separatorColor = [UIColor clearColor];
    waitLabel.font = [UIFont fontWithName:@"Bellerose" size:18.0];
}


-(void)initLocations {
    locations = [[NSMutableArray alloc]init];
    for (NSManagedObject *theLocation in [self locations]) {
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:[self locationString:theLocation],@"title",
                              [NSMutableArray arrayWithArray:[[theLocation valueForKey:@"historyItems"]allObjects]],@"historyItems",
                              [theLocation valueForKey:@"Photos"],@"photos",
                              theLocation,@"locationObject",
                              nil];
        [locations addObject:data];
    }
}

# pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [locations count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[[UIView alloc]initWithFrame:CGRectMake(20, 0, 280.0, 35.0)]autorelease];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 280.0, 35.0)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [HoodStatsAppDelegate popColor];
    label.font = [UIFont fontWithName:@"Bellerose" size:28.0];
    label.text = [[locations objectAtIndex:section]valueForKey:@"title"];
    [sectionView addSubview:label];
    [label release];
    return sectionView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sectionLocation = [locations objectAtIndex:section];
    NSMutableArray *historyItems = [sectionLocation valueForKey:@"historyItems"];
    NSSet *photos = [sectionLocation valueForKey:@"photos"];
    if ([photos count]>0)
        [historyItems insertObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Photos",@"label",[NSString stringWithFormat:@"Your photos taken in %@",[sectionLocation valueForKey:@"title"]],@"value",nil]atIndex:0];
    return [historyItems count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    NSDictionary *sectionLocation = [locations objectAtIndex:indexPath.section];
    NSMutableArray *historyItems = [sectionLocation objectForKey:@"historyItems"];
    NSManagedObject *item = [historyItems objectAtIndex:[indexPath row]];
    cell.textLabel.text = [item valueForKey:@"label"];
    cell.detailTextLabel.text = [item valueForKey:@"value"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([cell.textLabel.text isEqualToString:@"Photos"]) 
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIImage *cellImage = [UIImage imageNamed:@"infoCellBG.png"];
    UIImageView *cellView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 280, 44)];
    cellView.layer.opacity = 0.5;
    cellView.image = cellImage;
    cell.backgroundView = cellView;
    [cellView release];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Photos"]) {
        while (![HoodStatsAppDelegate imageDictionary]) {
            waitLabel.hidden = NO;
        }
        waitLabel.hidden = YES;
        // load galleryView
        GalleryViewController *gallery = [[GalleryViewController alloc]initWithNibName:@"GalleryViewController" bundle:[NSBundle mainBundle]];
        gallery.selectedLocation = [[locations objectAtIndex:[indexPath section]]objectForKey:@"locationObject"];
        [self presentModalViewController:gallery animated:YES];
        [gallery release];
    }
}

#pragma mark navigation

-(IBAction)loadMainScreen {
    [self.parentViewController dismissModalViewControllerAnimated: YES];
}


#pragma mark memory management

- (void)viewDidUnload {
    [super viewDidUnload];
    locations = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [super dealloc];
}



@end
