//
//  AddSatelliteViewController.h
//  Planets
//
//  Created by Fedor Solovev on 03.05.16.
//  Copyright © 2016 FedorX. All rights reserved.
//

#import "AbstractViewController.h"

@interface AddSatelliteViewController : AbstractViewController

@property (nonatomic, nonnull) NSString *planetPk;

@property (nonatomic, nonnull) SatellitesEntity *satelliteEntity;

@end
