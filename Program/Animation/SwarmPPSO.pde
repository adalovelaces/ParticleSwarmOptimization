//===================================================//
//                      VF-PSO SWARM                 //
//===================================================//

class SwarmPPSO extends Swarm{

    //===================================================//
    //                 CONSTRUCTOR                       //
    //===================================================//

    SwarmPPSO( FlowField _flowField, ValueField _valueField, String _neighborhoodTitle, ParticleCommand _command ){

        super( cfg.SWARM_PPSO_SIZE, cfg.COLOR_SWARM_PPSO, _neighborhoodTitle, _flowField, _valueField, _command );

    }
    //===================================================//
    //                     CALC                          //
    //===================================================//

    void calcPsoVector( Particle p ){

        p.coefficientA = cfg.PSO_COEFFICIENT_A.copy();
        p.coefficientB = cfg.PSO_COEFFICIENT_B.copy();

        p.coefficientA.mult( random( 0, 1 ) );

        float x = cfg.PSO_WEIGHT * p.velocity.x + p.coefficientA.x * ( p.pBestPosition.x - p.position.x ) + p.coefficientB.x * ( p.gBestPosition.x - p.position.x );
        float y = cfg.PSO_WEIGHT * p.velocity.y + p.coefficientA.y * ( p.pBestPosition.y - p.position.y ) + p.coefficientB.y * ( p.gBestPosition.y - p.position.y );

        VectorCoord newPso = new VectorCoord( x, y );

        // If move vector is very small, make it bigger
        int count = 0;
        while( 0 < newPso.mag() && newPso.mag() < 1 && count < 100 ){

            newPso.mult( 10 );

            count++;

        }

        // If move vector is equal to zero, use old vector
        if( newPso.mag() <= 0 ){

            newPso = p.psoVector.copy();

        }


        //if( p.getNeighborList().size() == 0 ){

            //x = random( 0, 2 );
            //y = random( 0, 2 );
            //newPso = new VectorCoord( x, y );

        //}

        p.psoVector = newPso.copy();
        p.psoVector.limit( cfg.PARTICLE_VELOCITY_MAX );

        if( p.laser.isActive() ){
            p.laser.doPSO();
            //p.psoVector = new VectorCoord(0,0);
        }

    }

    void calcMove( Particle p ){

        VectorCoord pso = p.psoVector.copy();
        VectorCoord flow = this.flowField.getFlow( p.position ).copy();

        flow.limit( cfg.PARTICLE_FLOW_MAX );

        if( cfg.SIM_USE_ENERGY ){

              pso = p.calcEnergyUsage( pso.copy(), flow.copy() );

        }

        VectorCoord result = new VectorCoord( 0, 0 );
        result.add( pso.copy() );
        result.add( flow.copy() );

        p.discVelocity = result.copy();
        p.discVelocity.discretize();
        p.discVelocity.limit( cfg.PARTICLE_VELOCITY_MAX / cfg.SIMULATION_SUBITERATIONS );

        p.psoVector = p.psoVector.copy();
        p.velocity = result.copy();
        p.flowVector = flow.copy();
        p.steeringVector = pso.copy();

        //println(p.getNum() + " " + p.getPBestValue() + " " + p.getGBestValue());
        //flow = this.flowField.getFlow( p.position ).copy();
        //VectorCoord vel = p.steeringVector.copy();
        //println("ANGLE NEW: " + p.getNum() + " " + (float) flow.getAngle(vel));

    }

}
