class Laser{

    private VectorCoord pBestPosition;
    private float pBestValue;
    private VectorCoord gBestPosition;
    private float gBestValue;

    private VectorCoord particlePos;

    private VectorCoord position;
    private VectorCoord velocity;

    private ValueField valueField;

    private float failures;

    private boolean isActive;

    Laser(ValueField valueField){

        this.valueField = valueField;
        this.position = new VectorCoord(0,0);
        this.velocity = new VectorCoord(0,0);
        this.particlePos = new VectorCoord(0,0);
        this.failures = 0;
        this.resetOptimumPosition();
        this.resetOptimumValues();

    }

    void resetOptimumValues(){

        if( cfg.PSO_MINIMIZING ){

            this.gBestValue = cfg.PSO_INIT;
            this.pBestValue = cfg.PSO_INIT;

        }

    }

    void resetOptimumPosition(){

        float xMin = cfg.SIMULATION_MIN_X;
        float xMax = cfg.SIMULATION_MAX_X;
        float yMin = cfg.SIMULATION_MIN_Y;
        float yMax = cfg.SIMULATION_MAX_Y;

        float posX = ( float ) ( Math.random() * ( ( xMax - xMin ) ) ) + xMin;
        float posY = ( float ) ( Math.random() * ( ( yMax - yMin ) ) ) + yMin;

        this.position = new VectorCoord( posX, posY );
        this.particlePos = new VectorCoord( posX, posY );
        this.gBestPosition = new VectorCoord( posX, posY );
        this.pBestPosition = new VectorCoord( posX, posY );

    }

    boolean isActive(){

        return this.isActive;

    }

    VectorCoord getGBestPosition(){

        return this.gBestPosition.copy();

    }

    float getGBestValue(){

        return this.gBestValue;

    }

    VectorCoord getPBestPosition(){

        return this.pBestPosition.copy();

    }

    float getPBestValue(){

        return this.pBestValue;

    }

    void doPSO(){

        VectorCoord coefficientA = cfg.PSO_COEFFICIENT_A.copy();
        VectorCoord coefficientB = cfg.PSO_COEFFICIENT_B.copy();

        coefficientA.mult( random( 0, 1 ) );
        coefficientB.mult( random( 0, 1 ) );

        float x = cfg.PSO_WEIGHT * this.velocity.x + coefficientA.x * ( this.pBestPosition.x - this.position.x ) + coefficientB.x * ( this.gBestPosition.x - this.position.x );
        float y = cfg.PSO_WEIGHT * this.velocity.y + coefficientA.y * ( this.pBestPosition.y - this.position.y ) + coefficientB.y * ( this.gBestPosition.y - this.position.y );

        //this.velocity = new VectorCoord( x, y );
        //this.velocity.limit( cfg.PARTICLE_LASER_RADIUS );

        VectorCoord newVel = new VectorCoord( x, y );
        newVel.limit( cfg.PARTICLE_VELOCITY_MAX );
        newVel.discretize();
        newVel.limit( cfg.PARTICLE_VELOCITY_MAX / cfg.SIMULATION_SUBITERATIONS );

        this.velocity = newVel;
        //this.velocity= new VectorCoord(0,0);

    }

    void move(){

        this.position.x = this.position.x + this.velocity.x;
        this.position.y = this.position.y + this.velocity.y;

        this.resetPosInsideRadius();

    }

    void updateParticlePos( VectorCoord particlePos ){

        this.particlePos = particlePos.copy();

        this.resetPosInsideRadius();

    }

    void resetPosInsideRadius(){

        float x1 = this.particlePos.x;
        float y1 = this.particlePos.y;

        float x2 = this.position.x;
        float y2 = this.position.y;

        float x = x2 - x1;
        float y = y2 - y1;

        VectorCoord vec = new VectorCoord( x, y );

        if( vec.mag() > cfg.PARTICLE_LASER_RADIUS ){

            vec.normalize();
            vec.mult( cfg.PARTICLE_LASER_RADIUS );

            float posX = this.particlePos.x;
            float posY = this.particlePos.y;

            posX += vec.x;
            posY += vec.y;

            //this.position = this.particlePos.copy();
            this.position = new VectorCoord( posX, posY );

        }

    }

    void update( VectorCoord particlePos, VectorCoord pBestPosition, float pBestValue, VectorCoord gBestPosition, float gBestValue ){

        float value = this.valueField.getValue( this.position );

        // Update local pbest
        if( ( cfg.PSO_MINIMIZING && value < pBestValue ) || ( cfg.PSO_MAXIMIZING && value > pBestValue ) ){

            this.pBestValue = value;
            this.pBestPosition = position.copy();
            this.failures = 0;

        }
        else{

            this.failures += 1;

        }


        // Update local gbest
        if( ( cfg.PSO_MINIMIZING && value < gBestValue ) || ( cfg.PSO_MAXIMIZING && value > gBestValue ) ){

            this.gBestValue = value;
            this.gBestPosition = position.copy();

        }

        if( pBestValue < this.pBestValue ){

            this.pBestPosition = pBestPosition.copy();
            this.pBestValue = pBestValue;

        }

        if( gBestValue < this.gBestValue ){

            this.gBestPosition = gBestPosition.copy();
            this.gBestValue = gBestValue;
            this.failures = 0;

        }

        if( this.failures >= cfg.PARTICLE_LASER_FAILURES ){
            this.deactivate();
        }

    }

    void activate(){

        this.failures = 0;
        this.isActive = true;
        this.position = this.particlePos.copy();
        this.velocity = new VectorCoord(0,0);

    }

    void deactivate(){

        this.failures = 0;
        this.isActive = false;

    }

    void draw(){

        if( this.isActive ){

            VectorScreen screenPos = this.position.copy().transToScreen();
            fill( cfg.COLOR_BUTTON_STANDARD );
            strokeWeight( 2 );
            stroke( cfg.COLOR_BUTTON_STANDARD );
            pushMatrix();
            ellipseMode(CENTER);
            ellipse( screenPos.x, screenPos.y, cfg.PARTICLE_SIZE/2, cfg.PARTICLE_SIZE/2 );
            popMatrix();
            strokeWeight( 1 );

        }


    }

}
