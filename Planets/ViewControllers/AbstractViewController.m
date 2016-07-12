//
//  AbstractViewController.m
//  Planets
//
//  Created by Fedor Solovev on 26.04.16.
//  Copyright © 2016 FedorX. All rights reserved.
//

#import "AbstractViewController.h"

@interface AbstractViewController ()

@end

@implementation AbstractViewController

- (void)didTapOnAddButton:(UIBarButtonItem *)button
{
    [self performSegueWithIdentifier:[self segueToAdd] sender:self];
}

- (NSString *)segueToAdd
{
    NSAssert(0, @"Method must be overriden");
    return nil;
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)addItemButton
{
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                      target:self action:@selector(didTapOnAddButton:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
}

@end
