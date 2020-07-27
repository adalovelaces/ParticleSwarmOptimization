//===================================================//
//                    PSO SWARM                      //
//===================================================//

class SwarmPSO extends Swarm{

    //===================================================//
    //                    CONSTRUCTOR                    //
    //===================================================//

    SwarmPSO( FlowField _flowField, ValueField _valueField, String _neighborhoodTitle, ParticleCommand _command ){

        super( cfg.SWARM_PSO_SIZE, cfg.COLOR_SWARM_PSO, _neighborhoodTitle, _flowField, _valueField, _command );

    }

    //===================================================//
    //                      CALC                         //
    //===================================================//

    void calcPsoVector( Particle p ){

        p.coefficientA = cfg.PSO_COEFFICIENT_A.copy();
        p.coefficientB = cfg.PSO_COEFFICIENT_B.copy();

        p.coefficientA.mult( random( 0, 1 ) );
        p.coefficientB.mult( random( 0, 1 ) );

        float x = cfg.PSO_WEIGHT * p.velocity.x + p.coefficientA.x * ( p.pBestPosition.x - p.position.x ) + p.coefficientB.x * ( p.gBestPosition.x - p.position.x );
        float y = cfg.PSO_WEIGHT * p.velocity.y + p.coefficientA.y * ( p.pBestPosition.y - p.position.y ) + p.coefficientB.y * ( p.gBestPosition.y - p.position.y );

        p.psoVector = new VectorCoord( x, y );
        p.psoVector.limit( cfg.PARTICLE_VELOCITY_MAX );

        if( p.laser.isActive() ){
            p.laser.doPSO();
            p.psoVector = new VectorCoord(0,0);
        }

    }

    void calcMove( Particle p ){

        VectorCoord pso = p.psoVector.copy();
        VectorCoord flow = this.flowField.getFlow( p.position ).copy();

        flow.limit( cfg.PARTICLE_FLOW_MAX );

        if( cfg.SIM_USE_ENERGY ){

              //pso = p.calcEnergyUsage( pso.copy(), flow.copy() );

        }

        VectorCoord result = new VectorCoord( 0, 0 );
        result.add( pso.copy() );
        //result.add( flow.copy() );

        p.discVelocity = result.copy();
        p.discVelocity.discretize();
        p.discVelocity.limit( cfg.PARTICLE_VELOCITY_MAX / cfg.SIMULATION_SUBITERATIONS );

        p.velocity = result.copy();
        p.flowVector = flow.copy();
        p.steeringVector = pso.copy();

    }

}
