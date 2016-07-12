//
//  DescriptionEntity+CoreDataProperties.h
//  Planets
//
//  Created by Fedor Solovev on 16.05.16.
//  Copyright © 2016 FedorX. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DescriptionEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface DescriptionEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *diameter;
@property (nullable, nonatomic, retain) NSNumber *period;
@property (nullable, nonatomic, retain) NSNumber *weight;
@property (nullable, nonatomic, retain) SatellitesEntity *satellite;

@end

NS_ASSUME_NONNULL_END
