//
//  AttractionData.m
//  TaipeiPark
//
//  Created by Vivi on 11/07/2017.
//  Copyright © 2017 Vivi. All rights reserved.
//

#import "AttractionData.h"

@implementation AttractionData

- (id)initWithName:(NSString *)name parkName:(NSString *)parkName introduction:(NSString *)introduction imageName:(NSString *)imageName {
    if (self = [super init]) {
        self.name = name;
        self.parkName = parkName;
        self.introduction = introduction;
        self.imageName = imageName;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ (%p) Name: %@, Park name: %@, Introduction: %@, Image name: %@", self.class, self, self.name, self.parkName, self.introduction, self.imageName];
}

@end
