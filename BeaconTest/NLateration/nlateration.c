//
//  nlateration.c
//  BeaconTest
//
//  Created by Tommaso Frassetto on 03/03/15.
//  Copyright (c) 2015 Tommaso Frassetto. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <float.h>
#include "nmsimplex.h"

double NLbeaconCount;
const double (*NLpositions)[3];
const double * NLdistances;
const double * NLweights;

double NLdistance(const double p[], const double q[]) {
	double xSqr = (p[0] - q[0]) * (p[0] - q[0]);
	double ySqr = (p[1] - q[1]) * (p[1] - q[1]);
	double zSqr = (p[2] - q[2]) * (p[2] - q[2]);
	return sqrt(xSqr + ySqr + zSqr);
}

double NLerror(double p0[]) {
	double sum = 0;

	for (int i = 0; i < NLbeaconCount; ++i) {
		double delta = (NLdistance(p0, NLpositions[i]) - NLdistances[i]) * NLweights[i];
		sum += delta * delta;
	}

	return sum;
}

void NLconstraint(double p[], int n) {
	if (p[2] < 0) {
		p[2] *= -1;
	}
}

void NLcompute(const int beaconCount, const double (* const positions)[3],
			   const double * distances, const double * weights,
			   double * outCoords) {
	NLbeaconCount = beaconCount;
	NLpositions = positions;
	NLdistances = distances;
	NLweights = weights;
	
	double start[3];
	for (int dim = 0; dim < 3; ++dim) {
		double min = DBL_MAX, max = -DBL_MAX;

		for (int i = 0; i < beaconCount; ++i) {
			if (positions[i][dim] < min) {
				min = positions[i][dim];
			} else if (positions[i][dim] > max) {
				max = positions[i][dim];
			}
		}

		start[dim] = min + (max - min) / 2;
	}

	simplex(NLerror, start, 3, 1e-10, .1, NLconstraint);

	for (int i = 0; i < 3; ++i) {
		outCoords[i] = start[i];
	}	
}