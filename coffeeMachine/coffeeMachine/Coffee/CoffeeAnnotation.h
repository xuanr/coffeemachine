//
//  CoffeeAnnotation.h
//  coffeeMachine
//
//  Created by Beifei on 7/31/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CoffeeAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *key;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
