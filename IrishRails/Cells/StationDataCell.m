//
//  StationDataCell.m
//  IrishRails
//
//  Created by Jaanus Siim on 2/25/13.
//  Copyright (c) 2013 JaanusSiim. All rights reserved.
//

#import "StationDataCell.h"
#import "StationData.h"
#import "Station.h"

@interface StationDataCell ()

@property (nonatomic, strong) IBOutlet UILabel *stationNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *routeLabel;
@property (nonatomic, strong) IBOutlet UILabel *dueInLabel;

@end

@implementation StationDataCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)configureWithData:(StationData *)data {
  [self.stationNameLabel setText:data.station.name];
  [self.routeLabel setText:[NSString stringWithFormat:@"%@ - %@", data.origin, data.destination]];
  [self.dueInLabel setText:data.dueIn];
}

@end
