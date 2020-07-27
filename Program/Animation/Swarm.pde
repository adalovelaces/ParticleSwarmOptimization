//===================================================//
//                  VFM-PSO SWARM                    //
//===================================================//

abstract class Swarm{

    protected color c;
    protected int size;
    protected Particle [] particles;
    protected ArrayList<Float> gBestList;
    protected ArrayList<Float> angleList;
    protected float gBestValue;
    protected VectorCoord gBestPosition;
    protected Neighborhood neighborhood;
    protected Interaction interaction;
    protected String neighborhoodTitle;

    protected VectorCoord coefficientA;
    protected VectorCoord coefficientB;
    protected VectorCoord swarmCenter;

    protected FlowField flowField;
    protected ValueField valueField;

    protected ParticleCommand command;

    //===================================================//
    //                 CONSTRUCTOR                       //
    //===================================================//

    Swarm( int size, color c, String nTitle, FlowField _flowField, ValueField _valueField, ParticleCommand _command ){

        this.size = size;
        this.c = c;
        this.neighborhoodTitle = nTitle;

        this.coefficientA = cfg.PSO_COEFFICIENT_A.copy();
        this.coefficientB = cfg.PSO_COEFFICIENT_B.copy();

        this.flowField = _flowField;
        this.valueField = _valueField;
        this.command = _command;

        this.init();

    }

    //===================================================//
    //                 INITIALISATION                    //
    //===================================================//

    void init(){

        this.neighborhood = new Neighborhood( this.size );
        this.interaction = new Interaction( this.size );
        this.particles = new Particle[ this.size ];

        for ( int i = 0; i < this.size; i++ ) {

            int num = this.neighborhood.nodes[ i ].getNum();

            Particle p = new Particle( this.c, num, this.neighborhoodTitle, this.size, this.flowField, this.valueField, this.command );

            this.particles[ i ] = p;

        }

        this.resetOptimum();
        this.swarmCenter = this.getSwarmCenter();
        this.calcWholeSwarmCenter();
        this.gBestList = new ArrayList<Float>();
        this.angleList = new ArrayList<Float>();

    }

    //===================================================//
    //                   ABSTRACT                        //
    //===================================================//

    abstract void calcPsoVector( Particle p );

    abstract void calcMove( Particle p );

    //===================================================//
    //                   GETTER                          //
    //===================================================//

    ArrayList<Particle> getParticles(){

        ArrayList<Particle> list = new ArrayList<Particle>();

        for( int i = 0; i < this.particles.length; i++ ){

            list.add( particles[ i ] );

        }

        return list;

    }

    float getGBestValue(){

        return this.gBestValue;

    }

    float getAngleValue(){

        float sum = 0;

        for( int i = 0; i < particles.length; i++ ){

            Particle p = this.particles[ i ];
            VectorCoord psoVector = p.psoVector.copy();
            VectorCoord flowVector = p.flowVector.copy();//this.flowField.getFlow( p.position ).copy();

            float angle = (float) Math.abs( psoVector.getAngle( flowVector ) );
            float angleRange = 180 - cfg.SIM_ZPSO_MAX_DEGREE;

            if( angle > angleRange ){
                sum += 1;
            }

        }

        return sum/this.size;

    }

    float getSumEnergyValue(){

        float energy = 0;

        for( Particle p : this.particles ){

            energy += p.battery;

        }

        return energy;

    }

    float getAvgEnergyValue(){

        float sumEnergy = this.getSumEnergyValue();
        return sumEnergy / this.particles.length;

    }

    float getMinEnergyValue(){

        float minEnergy = cfg.PARTICLE_BATTERY;

        for( Particle p : this.particles ){

            if( p.battery < minEnergy ){
                minEnergy = p.battery;
            }

        }

        return minEnergy;

    }

    float getMaxEnergyValue(){

        float maxEnergy = 0;

        for( Particle p : this.particles ){

            if( p.battery > maxEnergy ){
                maxEnergy = p.battery;
            }

        }

        return maxEnergy;

    }

    float getAvgNeighborValue(){

        float sumNeighbor = 0;

        for( Particle p : this.particles ){

            sumNeighbor += p.getNeighborList().size();

        }

        return sumNeighbor / this.particles.length;

    }

    float getMinNeighborValue(){

        float minNeighbor = 100;

        for( Particle p : this.particles ){

            int neighbor = p.getNeighborList().size();

            if( neighbor < minNeighbor ){
                minNeighbor = neighbor;
            }

        }

        return minNeighbor;

    }

    float getMaxNeighborValue(){

        float maxNeighbor = 0;

        for( Particle p : this.particles ){

            int neighbor = p.getNeighborList().size();

            if( neighbor > maxNeighbor ){
                maxNeighbor = neighbor;
            }

        }

        return maxNeighbor;

    }

    ArrayList<Float> getAngleList(){

        return this.angleList;

    }

    ArrayList<Float> getGBestList(){

        return this.gBestList;

    }

    VectorCoord getSigma( VectorCoord _center ){

        VectorCoord center = _center.copy();
        VectorCoord sum = new VectorCoord( 0, 0 );

        for( int i = 0; i < this.particles.length; i++ ){

            VectorCoord pos = this.particles[ i ].position.copy();
            pos.sub( center );
            pos.mult( pos );

            sum.add( pos.copy() );

        }

        sum.div( particles.length - 1 );

        return sum;

    }

    VectorCoord getSigma( Particle p ){

        VectorCoord center = this.getNeighborCenter( p );

        VectorCoord sum = new VectorCoord( 0, 0 );

        float a = 0;
        float b = 0;

        float centerX = center.x;
        float centerY = center.y;

        float sumX = 0;
        float sumY = 0;

        ArrayList<Particle> neighbors = p.getNeighborList();

        for( Particle neighbor : neighbors ){

            float posX = neighbor.position.x;
            float posY = neighbor.position.y;

            float subX = posX - centerX;
            float subY = posY - centerY;

            subX = subX * subX;
            subY = subY * subY;

            sumX += subX;
            sumY += subY;

        }

        sumX = sumX / ( neighbors.size() - 1 );
        sumY = sumY / ( neighbors.size() - 1 );

        return new VectorCoord( sumX, sumY );

    }

    VectorCoord getNeighborCenter( Particle p ){

        return p.getNeighborsCenter().copy();

    }

    VectorCoord getSwarmCenter(){

        this.calcWholeSwarmCenter();
        return this.swarmCenter.copy();

    }

    //===================================================//
    //                  CALCULATIONS CENTER              //
    //===================================================//

    void calcWholeSwarmCenter(){

        float a = 0;
        float b = 0;

        for( int i = 0; i < particles.length; i++ ){

            a += particles[ i ].position.x;
            b += particles[ i ].position.y;

        }

        a = a / particles.length;
        b = b / particles.length;

        VectorCoord centerPos = new VectorCoord( a, b );

        this.swarmCenter = centerPos.copy();

    }

    //===================================================//
    //                CALCULATIONS MOVE                  //
    //===================================================//

    void calcSteering(){

        for( int i = 0; i < this.particles.length; i++ ){

            Particle p = this.particles[ i ];

            this.calcMove( p );

        }

    }

    void calcEnergy(){

        for( Particle p : this.particles ){

            VectorCoord lastPos = p.lastPosition.copy();
            VectorCoord flow = this.flowField.getFlow( lastPos.copy() );

            p.useEnergy( flow.copy() );

        }

    }

    //===================================================//
    //                CALCULATIONS PSO                   //
    //===================================================//

    void calcNeighbors(){

        this.neighborhood.calcNeighbors( this.particles, this.neighborhoodTitle );

    }

    void calcPSO(){

        if( cfg.SIM_USE_PSO_ASYNCHRONOUS ) this.calcAsynchronousPSO();
        if( !cfg.SIM_USE_PSO_ASYNCHRONOUS ) this.calcSynchronousPSO();

    }

    void calcAsynchronousPSO(){

        for( int i = 0; i < particles.length; i++ ){

            particles[ i ].update( particles );

            this.neighborhood.calcNeighbors( this.particles, this.neighborhoodTitle );

            // Calculate psoVector
            this.calcPsoVector( particles[ i ] );

            this.update();

        }

    }

    void calcSynchronousPSO(){

        for( int i = 0; i < particles.length; i++ ){

            //Update all pso values
            particles[ i ].update( particles );

        }

        this.neighborhood.calcNeighbors( this.particles, this.neighborhoodTitle );

        for( int i = 0; i < this.particles.length; i++ ){

            // Calculate psoVector for each particle
            this.calcPsoVector( particles[ i ] );

        }

        // Update swarm (neighborhood)
        this.update();

    }

    //===================================================//
    //                CALCULATIONS DISTRIBUTIONS         //
    //===================================================//

    //ItoDistribution
    double calcBrownianDistribution( double x ){

        // VARIABLES
        int steps = 1; // iterations for discretization
        double mu = 0.0;
        double sigma = 1.0;
        double price = 1.0; // velocity
        double T = 1.0; // discretization
        double deltat = 1.0;// discretization step --> T / (double)steps

        // CALCULATION
        double[] sequence = new double[steps];
        double tmp = price;
        double ito = 0.0;
        double w1 = 0.0;
        Random rando = new Random();
        int k;

        for (k = 0; k < steps; k++) {
            // Wiener Process step used in each step
            w1 = rando.nextGaussian() * Math.sqrt(deltat);

            // Calculate the continuous compounding rate at each step
            ito = (mu - Math.pow(sigma, 2) * .5) * deltat + sigma * w1;

            // Previous price is compounded or discounted
            sequence[k] = tmp * Math.exp(ito);

            // Set the variable for the last price
            tmp = sequence[k];
        }


        return sequence[0];

    }

    double calcLevyDistribution( double x ){

        double beta = 1.5;

        Random r = new Random();

        /*

        num = gamma(1+beta)*sin(pi*beta/2); % used for Numerator
        den = gamma((1+beta)/2)*beta*2^((beta-1)/2); % used for Denominator
        sigma_u = (num/den)^(1/beta);% Standard deviation
        u = random('Normal',0,sigma_u^2,n,m);
        v = random('Normal',0,1,n,m);
        z = u./(abs(v).^(1/beta));
        */

        double num = calcGamma( 1 + beta ) * Math.sin( Math.PI * beta / 2 );
        double den = calcGamma( ( 1 + beta ) / 2 ) * beta * Math.pow(2, (beta-1) / 2 );
        double sigma_u = Math.pow( ( num / den ), ( 1 / beta ) );
        double u = r.nextGaussian() * Math.pow( sigma_u, 2 ) + 0;
        double v = r.nextGaussian() * 1 + 0;
        double z = u / Math.pow( Math.abs( v ), ( 1 / beta ) );//Math.pow( ( u / Math.abs( v ) ), ( 1 / beta ) );

        return z;

    }

    double calcGamma(double x){

        double[] p = {0.99999999999980993, 676.5203681218851, -1259.1392167224028,
        			     	  771.32342877765313, -176.61502916214059, 12.507343278686905,
        			     	  -0.13857109526572012, 9.9843695780195716e-6, 1.5056327351493116e-7};
    	int g = 7;
    	if(x < 0.5) return Math.PI / (Math.sin(Math.PI * x)*calcGamma(1-x));

        x -= 1;
        double a = p[0];
        double t = x+g+0.5;
    	for(int i = 1; i < p.length; i++){
    		a += p[i]/(x+i);
    	}

    	return Math.sqrt(2*Math.PI)*Math.pow(t, x+0.5)*Math.exp(-t)*a;

    }

    //===================================================//
    //                     DISPLAY                       //
    //===================================================//

    void display(){

        for( int i = 0; i < particles.length; i++ ){

            particles[ i ].draw();

        }

        if( cfg.SIM_SHOW_PARTICLE_CONNECTIONS ) this.neighborhood.drawConnections( this.particles );

        for( int i = 0; i < particles.length; i++ ){

            particles[ i ].drawOnlyParticle();

        }

        if( cfg.SIM_SHOW_CENTER && !cfg.SIM_USE_NEIGHBORCENTER ) this.drawSwarmCenter();
        if( cfg.SIM_SHOW_NEIGHBOR ) this.neighborhood.draw();
        if( cfg.SIM_SHOW_INTERACTION ) this.interaction.draw();

        if( cfg.SIM_SHOW_LASER ){

            for( int i = 0; i < particles.length; i++ ){

                particles[ i ].drawLaser();

            }

        }

    }

    void drawSwarmCenter(){

        VectorScreen center = this.swarmCenter.transToScreen();

        fill( this.c, 100 );
        stroke( cfg.COLOR_NEIGHBOR_CENTER );
        strokeWeight( 3 );
        pushMatrix();
        float size = 10;
        line( center.x - size / 2, center.y + size / 2, center.x + size / 2 , center.y - size / 2 );
        line( center.x - size / 2 , center.y - size / 2, center.x + size / 2 , center.y + size / 2 );
        strokeWeight( 1 );
        popMatrix();

    }

    //===================================================//
    //                     MOVE                          //
    //===================================================//

    void move(){

        this.updateAngleList();
        this.updateGBestList();

        // REDO
        //this.setPositions();
        //this.neighborhood.calcNeighbors( this.particles, this.neighborhoodType );

        // UNDO
        for( int i = 0; i < particles.length; i++ ){

            particles[ i ].move();

        }

        //this.neighborhood.calcNeighbors( this.particles, this.neighborhoodType );

    }

    //===================================================//
    //                      UPDATE                       //
    //===================================================//

    void update(){

        this.updateGBest();
        this.updateNeighborhood();
        this.updateInteraction();

    }

    void updateGBest(){

        for( int i = 0; i < particles.length; i++ ){

            float value = particles[ i ].getGBestValue();

            if( ( cfg.PSO_MINIMIZING && value < this.gBestValue ) || ( cfg.PSO_MAXIMIZING && value > this.gBestValue ) ){

                this.gBestValue = value;

            }

        }

    }

    void updateNeighborhood(){

        for( int i = 0; i < particles.length; i++ ){

            int index = particles[ i ].getNum();
            NeighborNode n = this.neighborhood.nodes[ index ];

            // Get neighbors of particle p
            ArrayList<Particle> neighborList = particles[ i ].getNeighborList();
            n.edges = new ArrayList<NeighborNode>();
            for( Particle neighbor : neighborList ){

                int indexNeighbor = neighbor.getNum();
                NeighborNode neighborNode = this.neighborhood.nodes[ indexNeighbor ];

                n.edges.add( neighborNode );

            }

        }

    }

    void updateInteraction(){

        for( int i = 0; i < particles.length; i++ ){

            int index = particles[ i ].getNum();
            InteractionNode n = this.interaction.nodes[ index ];

            // Get neighbors of particle p
            ArrayList<Particle> interactionList = particles[ i ].getInteractions();

            for( Particle interaction : interactionList ){

                int indexInteractionParticle = interaction.getNum();
                InteractionNode interactionNode = this.interaction.nodes[ indexInteractionParticle ];

                n.edges.add( interactionNode );

            }

        }

    }

    void updateGBestList(){

        this.gBestList.add( this.gBestValue );

    }

    void updateAngleList(){

        float sum = 0;

        for( int i = 0; i < particles.length; i++ ){

            Particle p = this.particles[ i ];
            VectorCoord psoVector = p.psoVector.copy();
            VectorCoord flowVector = this.flowField.getFlow( p.position ).copy();

            float angle = (float) Math.abs( psoVector.getAngle( flowVector ) );
            float angleRange = 180 - cfg.SIM_ZPSO_MAX_DEGREE;

            if( angle > angleRange ){
                sum += 1;
            }

        }

        this.angleList.add( sum/this.size );

    }

    //===================================================//
    //                      HELPER                       //
    //===================================================//

    void resetOptimum(){

        this.resetOptimumValue();
        this.resetOptimumPosition();
        this.resetOptimumParticle();

    }

    void resetOptimumParticle(){

        for( int i = 0; i < this.particles.length; i++ ){

            particles[ i ].resetOptimum();

        }

    }

    void resetOptimumValue(){

        if( cfg.PSO_MINIMIZING )    this.gBestValue = cfg.PSO_INIT;

    }

    void resetOptimumPosition(){

        float xMin = cfg.SIMULATION_MIN_X;
        float xMax = cfg.SIMULATION_MAX_X;
        float yMin = cfg.SIMULATION_MIN_Y;
        float yMax = cfg.SIMULATION_MAX_Y;

        float posX = ( float ) ( Math.random() * ( ( xMax - xMin ) ) ) + xMin;
        float posY = ( float ) ( Math.random() * ( ( yMax - yMin ) ) ) + yMin;

        this.gBestPosition = new VectorCoord( posX, posY );

    }

}
