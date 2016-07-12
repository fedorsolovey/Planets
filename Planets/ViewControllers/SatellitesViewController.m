//
//  SatellitesViewController.m
//  Planets
//
//  Created by Fedor Solovev on 03.05.16.
//  Copyright © 2016 FedorX. All rights reserved.
//

#import "SatellitesViewController.h"

#import "SatelliteCell.h"
#import "AddSatelliteViewController.h"

@interface SatellitesViewController ()

@end

@implementation SatellitesViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.selectedIndexPath != nil) {
        
        self.selectedIndexPath = nil;
    }
    
    [self updateListFromLocal:nil]; 
}

- (NSString *)segueToAdd
{
    return SattelitesToAddSattelliteSegue;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SattelitesToAddSattelliteSegue]) {
        
        if (self.selectedIndexPath != nil) {
            AddSatelliteViewController *controller = (AddSatelliteViewController *)segue.destinationViewController;
            controller.satelliteEntity = [self itemAtIndexPath:self.selectedIndexPath];
        }
    }
}

- (Class)cellClass
{
    return [SatelliteCell class];
}

+ (nonnull Class)entityClass
{
    return [SatellitesEntity class];
}

- (nonnull NSString*)sortBy
{
    return @"pk";
}

- (nullable NSPredicate *)queryForLocalRequest
{
    NSMutableArray *formatParts = [NSMutableArray arrayWithCapacity:2];
    NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:2];
    
    if (self.searchString.length > 0) {
        [formatParts addObject:@"pk contains[cd] %@"];
        [arguments addObject:self.searchString];
    }

    if (self.planetPk.length != 0) {
        [formatParts addObject:@"planet.pk like[cd] %@"];
        [arguments addObject:self.planetPk];
    }

    if (formatParts.count == 0 || arguments.count != formatParts.count) {
        return nil;
    }
    
    return [NSPredicate predicateWithFormat:[formatParts componentsJoinedByString:@" AND "]
                              argumentArray:arguments];
    
    return nil;
}

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SatelliteCell heightCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SatelliteCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self cellClass] reuseIdentifier] forIndexPath:indexPath];
    [cell configWithModel:[self itemAtIndexPath:indexPath]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [LocalDatastoreObject saveAsyncWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            
            SatellitesEntity *satellite = [self itemAtIndexPath:indexPath];
            [SatellitesEntity deleteByPk:satellite.pk inContext:localContext];
            
        }
                                      completion:^(BOOL success, NSError * _Nullable error) {
                                          
                                          [self updateListFromLocal:nil];
                                      }];
    }
}

@end
