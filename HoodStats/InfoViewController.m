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
    locations = [[NSArray alloc]initWithArray:[self locations]];
    infoTable.backgroundColor = [UIColor clearColor];
    infoTable.backgroundView = nil;
    infoTable.separatorColor = [UIColor clearColor];
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
    NSManagedObject *sectionLocation = [locations objectAtIndex:section];
    label.text = [self locationString:sectionLocation];
    [sectionView addSubview:label];
    [label release];
    return sectionView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSManagedObject *sectionLocation = [locations objectAtIndex:section];
    NSSet *historyItems = [sectionLocation valueForKeyPath:@"HistoryItems"];
    NSSet *photos = [sectionLocation valueForKey:@"Photos"];
    if ([photos count]>0) {
        return [historyItems count]+1;
    } else {
        return [historyItems count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    NSManagedObject *sectionLocation = [locations objectAtIndex:indexPath.section];
    if ([[sectionLocation valueForKey:@"HistoryItems"]count]<=[indexPath row]) {
        cell.textLabel.text = @"Photos";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Your photos taken in %@",[sectionLocation valueForKey:@"city"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"label" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        [sortDescriptor release];
        NSArray *historyItems = [[sectionLocation valueForKeyPath:@"HistoryItems"] sortedArrayUsingDescriptors:sortDescriptors];
        NSManagedObject *item = [historyItems objectAtIndex:[indexPath row]];
        cell.textLabel.text = [item valueForKey:@"label"];
        cell.detailTextLabel.text = [item valueForKey:@"value"];
    }
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
        // load galleryView
        GalleryViewController *gallery = [[GalleryViewController alloc]initWithNibName:@"GalleryViewController" bundle:[NSBundle mainBundle]];
        gallery.selectedLocation = [locations objectAtIndex:[indexPath section]];
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
