//
//  PlanetsEntity+CoreDataProperties.h
//  Planets
//
//  Created by Fedor Solovev on 03.05.16.
//  Copyright © 2016 FedorX. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PlanetsEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlanetsEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *number;
@property (nullable, nonatomic, retain) NSSet<SatellitesEntity *> *satellites;

@end

@interface PlanetsEntity (CoreDataGeneratedAccessors)

- (void)addSatellitesObject:(SatellitesEntity *)value;
- (void)removeSatellitesObject:(SatellitesEntity *)value;
- (void)addSatellites:(NSSet<SatellitesEntity *> *)values;
- (void)removeSatellites:(NSSet<SatellitesEntity *> *)values;

@end

NS_ASSUME_NONNULL_END
