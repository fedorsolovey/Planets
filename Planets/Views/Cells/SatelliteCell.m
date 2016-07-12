//
//  SatelliteCell.m
//  Planets
//
//  Created by Fedor Solovev on 03.05.16.
//  Copyright © 2016 FedorX. All rights reserved.
//

#import "SatelliteCell.h"

@interface SatelliteCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *planetNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *diametrLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateOpenLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@end

@implementation SatelliteCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

+ (CGFloat)heightCell
{
    return 170;
}

- (void)configWithModel:(SatellitesEntity *)model
{
    self.nameLabel.text = model.pk;
    self.planetNameLabel.text = model.planet.pk;
    
    self.diametrLabel.text = [NSString stringWithFormat:@"%f", model.descrp.diameter.doubleValue];
    self.periodLabel.text = [NSString stringWithFormat:@"%f", model.descrp.period.doubleValue];
    self.weightLabel.text = [NSString stringWithFormat:@"%f", model.descrp.weight.doubleValue];
    self.dateOpenLabel.text = model.discovery;
    self.noteLabel.text = model.notes;
}

@end
