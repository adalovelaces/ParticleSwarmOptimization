//===================================================//
//                      VF-PSO SWARM                 //
//===================================================//

class SwarmZPSO extends Swarm{

    //===================================================//
    //                 CONSTRUCTOR                       //
    //===================================================//

    SwarmZPSO( FlowField _flowField, ValueField _valueField, String _neighborhoodTitle, ParticleCommand _command ){

        super( cfg.SWARM_ZPSO_SIZE, cfg.COLOR_SWARM_ZPSO, _neighborhoodTitle, _flowField, _valueField, _command );

    }
    //===================================================//
    //                     CALC                          //
    //===================================================//

    void calcPsoVector( Particle p ){

        p.coefficientA = cfg.PSO_COEFFICIENT_A.copy();
        p.coefficientB = cfg.PSO_COEFFICIENT_B.copy();

        p.coefficientA.mult( random( 0, 1 ) );
        p.coefficientB.mult( random( 0, 1 ) );


        float x = cfg.PSO_WEIGHT * p.velocity.x + p.coefficientA.x * ( p.pBestPosition.x - p.position.x ) + p.coefficientB.x * ( p.gBestPosition.x - p.position.x );
        float y = cfg.PSO_WEIGHT * p.velocity.y + p.coefficientA.y * ( p.pBestPosition.y - p.position.y ) + p.coefficientB.y * ( p.gBestPosition.y - p.position.y );


        if( countIter < 1 ){//} p.getNeighborList().size() == 0 ){

            //Random r = new Random();
            int max = 2;
            int min = -2;
            x = -1;//r.nextFloat() * ( max - min + 1 ) + min;
            y = 1;//r.nextFloat() * ( max - min + 1 ) + min;

        }

        p.psoVector = new VectorCoord( x, y );
        p.psoVector.limit( cfg.PARTICLE_VELOCITY_MAX );

        if( p.laser.isActive() ){
            p.laser.doPSO();
            //p.psoVector = new VectorCoord(0,0);
        }


    }

    VectorCoord getCorrectionVector( Particle p ){

        VectorCoord oldVel = p.velocity.copy();
        VectorCoord oldPso = p.steeringVector.copy();

        VectorCoord corrVec = new VectorCoord( 0, 0 );
        corrVec = oldVel;
        corrVec.sub( oldPso );

        return corrVec.copy();

    }

    VectorCoord getRotatedPSO( Particle p ){

        VectorCoord flow = this.flowField.getFlow( p.position ).copy();
        VectorCoord a = getCorrectionVector( p );
        VectorCoord b = p.psoVector.copy();
        VectorCoord rotatedPSO = p.psoVector.copy();

        double angleCorrPSO = a.getAngle( b );
        double rotationAngle = getRotationAngle( angleCorrPSO );

        if( rotationAngle != 0 ){
            rotatedPSO.rotate( rotationAngle );
        }

        VectorCoord goalMove = rotatedPSO.copy();
        goalMove.sub( a.copy() );

        return goalMove.copy();

    }

    double getRotationAngle( double angle ){

        double angleDifference = 180 - cfg.SIM_ZPSO_MAX_DEGREE;

        if( angle < 0 ){
            angleDifference = angleDifference * (-1);
        }

        if( angle < 0 && angle < angleDifference ){
            //angleDifference = angleDifference * (-1);
            return - ( angle - angleDifference );
        }

        if( angle > 0 && angle > angleDifference ){
            return - (angle - angleDifference);
        }

        return 0;

    }

    void calcMove( Particle p ){


        VectorCoord pso = p.psoVector.copy();
        VectorCoord flow = this.flowField.getFlow( p.position ).copy();
        VectorCoord rotatedPSO = this.getRotatedPSO( p );
        flow.limit( cfg.PARTICLE_FLOW_MAX );


        if( p.getNeighborList().size() == 0 && countIter > 2 ){

            rotatedPSO = new VectorCoord( 0, 0 );

        }



        if( cfg.SIM_USE_ENERGY ){

              rotatedPSO = p.calcEnergyUsage( rotatedPSO.copy(), flow.copy() );

        }



        VectorCoord result = new VectorCoord( 0, 0 );
        result.add( rotatedPSO.copy() );
        result.add( flow.copy() );

        p.discVelocity = result.copy();
        p.discVelocity.discretize();
        p.discVelocity.limit( cfg.PARTICLE_VELOCITY_MAX / cfg.SIMULATION_SUBITERATIONS );

        p.psoVector = p.psoVector.copy();
        p.velocity = result.copy();
        p.flowVector = flow.copy();
        p.steeringVector = rotatedPSO.copy();

    }

}
