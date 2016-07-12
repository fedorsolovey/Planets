//
//  PlanetsViewController.m
//  Planets
//
//  Created by Fedor Solovev on 30.04.16.
//  Copyright © 2016 FedorX. All rights reserved.
//

#import "PlanetsViewController.h"
#import "AddItemViewController.h"

#import "PlanetCell.h"

@interface PlanetsViewController ()

@end

@implementation PlanetsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerNib:[PlanetCell class]];
    [self addItemButton]; 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.selectedIndexPath != nil) {
        
        [self.dynamicTableView beginUpdates];
        [self.dynamicTableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.dynamicTableView endUpdates];
        
        self.selectedIndexPath = nil;
    }
    
    [self updateListFromLocal:nil];
}

- (NSString *)segueToAdd
{
    return PlanetsToAddItemSegue;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:PlanetsToAddItemSegue]) {
        
        if (self.selectedIndexPath != nil) {
            AddItemViewController *controller = (AddItemViewController *)segue.destinationViewController;
            controller.planetEntity = [self itemAtIndexPath:self.selectedIndexPath];
        }
    }

}

- (Class)cellClass
{
    return [PlanetCell class];
}

+ (nonnull Class)entityClass
{
    return [PlanetsEntity class];
}

- (nonnull NSString*)sortBy
{
    return @"number";
}

- (NSString *)segueToDetail
{
    return PlanetsToAddItemSegue;
}

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PlanetCell heightCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlanetCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self cellClass] reuseIdentifier] forIndexPath:indexPath];
    [cell configWithModel:[self itemAtIndexPath:indexPath]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        [LocalDatastoreObject saveAsyncWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            
            PlanetsEntity *planet = [self itemAtIndexPath:indexPath];
            [PlanetsEntity deleteByPk:planet.pk inContext:localContext];
                
        }
                                      completion:^(BOOL success, NSError * _Nullable error) {
                                          
                                          [self updateListFromLocal:nil];
        }];
    }
}

@end
