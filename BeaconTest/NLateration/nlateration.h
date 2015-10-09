//
//  nlateration.h
//  BeaconTest
//
//  Created by Tommaso Frassetto on 11/03/15.
//  Copyright (c) 2015 Tommaso Frassetto. All rights reserved.
//

#pragma once

void NLcompute(const int beaconCount, const double (* const positions)[3],
			   const double * distances, const double * weights,
			   double * outCoords);