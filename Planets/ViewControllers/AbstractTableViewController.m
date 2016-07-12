//
//  AbstractTableViewController.m
//  Planets
//
//  Created by Fedor Solovev on 26.04.16.
//  Copyright © 2016 FedorX. All rights reserved.
//

#import "AbstractTableViewController.h"
#import "AppDelegate.h"

@interface AbstractTableViewController ()

@property NSMutableIndexSet *deletedSections, *insertedSections;
/// List of items for displaying
@property (nonatomic, copy, nullable) NSMutableArray *items;
@end

@implementation AbstractTableViewController

@synthesize frc = _frc;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self cellClass]) bundle:nil];
    [self.dynamicTableView registerNib:nib forCellReuseIdentifier:[[self cellClass] reuseIdentifier]];
    
    self.dynamicTableView.tableFooterView = [UIView new];
}

#pragma mark - Dynamic Table Configuration Methods

- (nonnull Class)cellClass
{
    NSAssert(0, @"Method must be overriden");
    return [UITableViewCell class];
}

#pragma mark - NSFetchedResultsController Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.dynamicTableView beginUpdates];
    
    self.deletedSections = [NSMutableIndexSet new];
    self.insertedSections = [NSMutableIndexSet new];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.dynamicTableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)theType newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(theType) {
        case NSFetchedResultsChangeDelete:
            [self.dynamicTableView deleteRowsAtIndexPaths:@[indexPath]
                                         withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeInsert:
            [self.dynamicTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeMove:
            // @MARK: iOS 9.0 bug. Move sent instead of update. indexPath = newIndexPath.
            if([indexPath isEqual:newIndexPath]) {
                [self.dynamicTableView deleteRowsAtIndexPaths:@[indexPath]
                                             withRowAnimation:UITableViewRowAnimationNone];
                [self.dynamicTableView insertRowsAtIndexPaths:@[newIndexPath]
                                             withRowAnimation:UITableViewRowAnimationNone];
            }
            // iOS 9.0b5 sends the same index path twice instead of delete
            // @MARK: iOS 9.0 bug. Move sent instead of update. indexPath = newIndexPath.
            else if ([indexPath isEqual:newIndexPath] == NO) {
                [self.dynamicTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self.dynamicTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            else if([self.insertedSections containsIndex:indexPath.section]) {
                // iOS 9.0b5 bug: Moving first item from section 0 (which becomes section 1 later) to section 0
                // Really the only way is to delete and insert the same index path...
                [self.dynamicTableView deleteRowsAtIndexPaths:@[indexPath]
                                             withRowAnimation:UITableViewRowAnimationNone];
                [self.dynamicTableView insertRowsAtIndexPaths:@[indexPath]
                                             withRowAnimation:UITableViewRowAnimationNone];
            }
            else if([self.deletedSections containsIndex:indexPath.section]) {
                // iOS 9.0b5 bug: same index path reported after section was removed
                // we can ignore item deletion here because the whole section was removed anyway
                [self.dynamicTableView insertRowsAtIndexPaths:@[indexPath]
                                             withRowAnimation:UITableViewRowAnimationNone];
            }
            
            break;
            
        case NSFetchedResultsChangeUpdate:
            // On iOS 9.0b5 NSFetchedResultsController may not even contain such indexPath anymore
            // when removing last item from section.
            if(![self.deletedSections containsIndex:indexPath.section] &&
               ![self.insertedSections containsIndex:indexPath.section])
            {
                // iOS 9.0b5 sends update before delete therefore we cannot use reload
                // this will never work correctly but at least no crash.
                __unused UITableViewCell<ConfigurableCell> *cell = [self.dynamicTableView cellForRowAtIndexPath:indexPath];
//                [self configureCell:cell atIndexPath:indexPath];
            }
            
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex];
    
    switch (type)
    {
        case NSFetchedResultsChangeInsert: {
            [self.insertedSections addIndexes:indexSet];
            [self.dynamicTableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
            
        case NSFetchedResultsChangeDelete: {
            [self.deletedSections addIndexes:indexSet];
            [self.dynamicTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITableView Delegate

- (void)reloadTableView
{
    _frc = nil;
    [self.dynamicTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfItemsForSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell<ConfigurableCell> *cell = [tableView dequeueReusableCellWithIdentifier:[[self cellClass] reuseIdentifier] forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:[self segueToAdd] sender:self];
}

- (void)registerNib:(Class)theClass
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([theClass class]) bundle:nil];
    [self.dynamicTableView registerNib:nib forCellReuseIdentifier:[theClass reuseIdentifier]];
}

#pragma mark - Methods with state for override

+ (nonnull Class)entityClass
{
    NSAssert(0, @"Method must be overriden");
    return nil;
}

#pragma mark - Methods with behavior for override

- (nonnull NSString*)sortBy
{
    NSAssert(0, @"Method must be overriden");
    return nil;
}

- (nullable NSPredicate *)queryForLocalRequest
{
    NSMutableArray *formatParts = [NSMutableArray arrayWithCapacity:2];
    NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:2];
    
    if (self.searchString.length > 0) {
        [formatParts addObject:@"pk contains[cd] %@"];
        [arguments addObject:self.searchString];
    }
    
    if (formatParts.count == 0 || arguments.count != formatParts.count) {
        return nil;
    }
    
    return [NSPredicate predicateWithFormat:[formatParts componentsJoinedByString:@" AND "]
                              argumentArray:arguments];
}

- (BOOL)ascending
{
    return YES;
}

- (NSInteger)numberOfSections
{
    return self.frc.sections.count;
}

- (NSInteger)numberOfItemsForSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionData = self.frc.sections[section];
    return sectionData.numberOfObjects;
}

- (nonnull id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_items == nil) {
        _items = [NSMutableArray arrayWithCapacity:[self numberOfItemsForSection:0]];
    }
    
    if (_items.count > indexPath.row) {
        return _items[indexPath.row];
    }
    
    id entity = [self.frc objectAtIndexPath:indexPath];
    [_items addObject:entity];
    
    return entity;
}

- (nullable NSFetchedResultsController*)frc
{
    if (_frc == nil) {
        Class entityClass = [self.class entityClass];
        
        NSString *kCacheName = [NSString stringWithFormat:@"%@ListCache", NSStringFromClass(entityClass)];
        [NSFetchedResultsController deleteCacheWithName:kCacheName];
        
        NSFetchRequest *request = [entityClass fetchRequestInContext:LocalDatastoreObject.mainQueueContext];
        request.fetchBatchSize = 30;
        request.predicate = [self queryForLocalRequest];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:[self sortBy] ascending:[self ascending]]];
        
        _frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                   managedObjectContext:LocalDatastoreObject.mainQueueContext
                                                     sectionNameKeyPath:nil
                                                              cacheName:kCacheName];
        
//        if ([self.delegate conformsToProtocol:@protocol(NSFetchedResultsControllerDelegate)]) {
//            _frc.delegate = (id<NSFetchedResultsControllerDelegate>)self.delegate;
//        }
        
        NSError *error = nil;
        [_frc performFetch:&error];
        if (error) {
            NSLog(@"%@. FRC fetching error: %@", NSStringFromClass(self.class), error);
        }
    }
    return _frc;
}

- (BOOL)supportsFRC
{
    return YES;
}

#pragma mark - Data updating

- (void)updateListFromLocal:(nullable LogicalResponseBlock)completionBlock
{
    _items = nil;
    _frc = nil;
    
    if ([self supportsFRC]) {
                NSError *error = nil;
                [self.frc performFetch:&error];
                if (error) {
                    NSLog(@"%@. FRC fetching error: %@", NSStringFromClass(self.class), error);
                }
        NSLog(@"cache: %@", self.frc.cacheName);
    }
    
    if (completionBlock) {
        call_completion_block(completionBlock, YES, nil);
    }
    else {
        [self.dynamicTableView reloadData];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchString = searchText;
    [self updateListFromLocal:nil];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    self.searchString = @"";
    [self updateListFromLocal:nil];
    
    [searchBar resignFirstResponder];
}

@end
