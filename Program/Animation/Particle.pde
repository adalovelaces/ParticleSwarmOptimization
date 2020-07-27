//===================================================//
//                    PARTICLE                       //
//===================================================//

class Particle extends MovingEntity {

    protected VectorCoord pBestPosition;
    protected float pBestValue;
    protected float lastPBestValue;
    protected int pBestUpdate;

    protected VectorCoord gBestPosition;
    protected float gBestValue;
    protected float lastGBestValue;

    protected VectorCoord flowVector;
    protected VectorCoord psoVector;
    protected VectorCoord oldPsoVector;
    protected VectorCoord steeringVector;

    protected Particle[] neighbors;
    protected float[] neighborsMemory;
    protected HashMap<String, Float> coalitionHashMap = new HashMap<String, Float>();
    protected String neighborhoodTitle;
    protected int failures;
    protected VectorCoord neighborsCenter;
    protected float strategyChangeFactor;
    protected String strategy;
    protected ArrayList<Particle> group;

    protected ArrayList<Particle> interactions;
    protected int bestNeighbor;

    protected VectorCoord coefficientA;
    protected VectorCoord coefficientB;

    protected FlowField flowField;
    protected ValueField valueField;

    protected ParticleCommand command;

    //===================================================//
    //                 CONSTRUCTOR                       //
    //===================================================//

    Particle( color c, int num, String nTitle, int size, FlowField _flowField, ValueField _valueField, ParticleCommand _command ) {

        super( c, num );

        this.flowVector = new VectorCoord( 0, 0 );
        this.psoVector = new VectorCoord( 0, 0 );
        this.oldPsoVector = new VectorCoord( 0, 0 );
        this.steeringVector = new VectorCoord( 0, 0 );

        this.neighborhoodTitle = nTitle;
        this.interactions = new ArrayList<Particle>();
        this.neighbors = new Particle[ size ];
        this.neighborsMemory = new float[ size ];
        this.initNeighborsMemory();

        this.coalitionHashMap = new HashMap<String, Float>();
        this.strategy = "Cooperate";
        this.strategyChangeFactor = 0;
        this.group = new ArrayList<Particle>();

        this.bestNeighbor = -1;
        this.failures = 0;

        this.coefficientA = cfg.PSO_COEFFICIENT_A.copy();
        this.coefficientB = cfg.PSO_COEFFICIENT_B.copy();

        this.flowField = _flowField;
        this.valueField = _valueField;

        this.command = _command;
        this.neighborsCenter = new VectorCoord( 0, 0 );

        this.resetOptimum();

        this.laser = new Laser( _valueField );

    }

    void initNeighborsMemory(){

        Random r = new Random();
        for( int i = 0; i < this.neighborsMemory.length; i++ ){

            this.neighborsMemory[ i ] = r.nextFloat();

        }

    }

    //===================================================//
    //                      GETTER                       //
    //===================================================//

    Particle getGroupLeader(){

        int smallestNum = 100;
        Particle leader = this;

        if( this.num < smallestNum ){

            smallestNum = this.num;
            leader = this;

        }

        for( Particle p : this.group ){

            if( p.getNum() < smallestNum ){

                smallestNum = p.getNum();
                leader = p;

            }

        }


        return leader;

    }

    ArrayList<Particle> getGroup(){

        return this.group;

    }

    float getPBestValue(){

        return this.pBestValue;

    }

    VectorCoord getPBestPosition(){

        return this.pBestPosition;

    }

    float getGBestValue(){

        return this.gBestValue;

    }

    VectorCoord getGBestPosition(){

        return this.gBestPosition;

    }


    Particle[] getNeighborArray(){

        return this.neighbors;

    }

    ArrayList<Particle> getNeighborList(){

        ArrayList<Particle> list = new ArrayList<Particle>();
        for( int i = 0; i < this.neighbors.length; i++ ){

            Particle p = this.neighbors[ i ];
            if( p != null ){
                    list.add( p );
            }

        }

        return list;

    }

    ArrayList<Particle> getInteractions(){

        return this.interactions;

    }

    VectorCoord getNeighborsCenter(){

        this.calcNeighborsCenter();

        return this.neighborsCenter.copy();

    }

    float getCoalitionHashMapValue( String key ){

        float value = 0;

        //If first called, value is 0.5
        if( this.coalitionHashMap.get( key ) != null ){

            Random r = new Random();
            value = r.nextFloat();//0.5;
            this.coalitionHashMap.put( key, value );

        }

        return value;

    }

    float getUsedEnergy(){

        return this.usedEnergy;

    }

    float getLeftEnergy(){

        return this.battery;

    }

    String getNeighborString(){

        String n = "[";

        for( Particle p : this.getNeighborList() ){

            n += p.getNum();
            n += ",";

        }

        n = n.substring( 0, n.length() - 1 );
        n += "]";
        return n;

    }

    Float getDistOpt(){

        VectorCoord optPos = new VectorCoord( cfg.PSO_X, cfg.PSO_Y );
        VectorCoord selfPos = this.position.copy();

        return optPos.distance( selfPos );

    }


    Float getPBest(){

        return this.pBestValue;

    }

    Float getPBestUpdate(){

        return new Float( this.pBestUpdate );
    }


    Float getOrientationOpt(){

        VectorCoord optPos = new VectorCoord( cfg.PSO_X, cfg.PSO_Y );
        VectorCoord opt = optPos.copy();
        VectorCoord vel = this.steeringVector.copy();
        opt.sub(vel);

        if( vel.mag() == 0 ){
            return 0.0;
        }

        return (float) opt.getAngle(vel);

    }

    Float getOrientationWind(){

        VectorCoord flow = this.flowField.getFlow( this.position ).copy();//this.flowVector.copy();
        VectorCoord vel = this.steeringVector.copy();

        if( vel.mag() == 0 ){
            return 0.0;
        }

        return (float) flow.getAngle(vel);

    }

    //===================================================//
    //                      SETTER                       //
    //===================================================//

    void setCoalitionHashMapValue( String key, float value ){

        Float floatValue = Float.valueOf( value );
        this.coalitionHashMap.put( key, floatValue );

    }

    void setCenter( VectorCoord center ){

        this.neighborsCenter = center.copy();

    }

    //===================================================//
    //                      HELPER                       //
    //===================================================//

    boolean isGroupLeader(){

        int leaderNum = this.getGroupLeader().getNum();

        return leaderNum == this.num;

    }

    void addSingleGroupMember( Particle p ){

        this.group.add( p );

    }

    void addMultipleGroupMember( ArrayList<Particle> list ){

        for( Particle p : list ){

            if( !this.group.contains( p ) && p.getNum() != this.num ){

                this.group.add( p );

            }

        }

    }

    boolean isGroupMember( Particle p ){

        for( Particle member : group ){

            if( member.getNum() == p.getNum() ){

                return true;

            }

        }

        return false;

    }

    void execute(){

        ArrayList<Particle> neighbors = this.getNeighborList();

        this.command.execute( this.num, this.battery, neighbors );

    }

    Particle deleteNeighbor( int i ){

        this.neighbors[ i ] = null;
        return this;

    }

    void calcNeighborsCenter(){

        float a = this.position.x;
        float b = this.position.y;

        ArrayList<Particle> neighborList = this.getNeighborList();

        for( Particle p : neighborList ){

            a += p.position.x;
            b += p.position.y;

        }

        a = a / ( neighborList.size() + 1 );
        b = b / ( neighborList.size() + 1 );

        this.neighborsCenter = new VectorCoord( a, b );

    }

    //===================================================//
    //                      PSO                          //
    //===================================================//

    void update( Particle [] swarm ){

        this.laser.update( this.position.copy(), this.pBestPosition, this.pBestValue, this.gBestPosition, this.gBestValue );

        this.updateByLaser();
        this.updatePBest();
        this.updateGBest();

        this.laser.update( this.position.copy(), this.pBestPosition, this.pBestValue, this.gBestPosition, this.gBestValue );

        boolean otherParticleIsClose = false;
        for( int i = 0; i < swarm.length; i++ ){

            if( i == this.getNum() ){
                break;
            }

            VectorCoord ownPos = this.position.copy();
            VectorCoord otherPos = swarm[ i ].position.copy();
            float distance = ownPos.distance( otherPos );

            if( distance < cfg.PARTICLE_SIZE + 0.2 ){
                otherParticleIsClose = true;
            }

        }

        if( this.failures >= cfg.PARTICLE_FAILURES && otherParticleIsClose ){

            this.laser.activate();
            this.failures = 0;

        }

    }

    void updateByLaser(){

        float lpBest = this.laser.getPBestValue();
        if(  lpBest < this.pBestValue ){

            this.lastPBestValue = this.pBestValue;
            this.pBestValue = lpBest;
            this.pBestPosition = this.laser.getPBestPosition();
            this.pBestUpdate = countIter;

        }

        float lgBest = this.laser.getGBestValue();
        if( lgBest < this.lastGBestValue ){

            this.lastGBestValue = this.gBestValue;
            this.gBestValue = lgBest;
            this.gBestPosition = this.laser.getGBestPosition();

        }

    }

    void updateGBest(){

        ArrayList<Particle> list = this.getNeighborList();

        if( cfg.PSO_USE_NEIGHOR_GBEST ){

            this.lastGBestValue = this.gBestValue;
            this.gBestValue = this.getPBestValue();
            this.gBestPosition = this.getPBestPosition().copy();
            this.bestNeighbor = this.getNum();

        }

        for( Particle p : list ){

            if( ( cfg.PSO_MINIMIZING && p.getGBestValue() < this.gBestValue ) || ( cfg.PSO_MAXIMIZING && p.getGBestValue() > this.gBestValue ) ){

                this.lastGBestValue = this.gBestValue;
                this.gBestValue = p.getGBestValue();
                this.gBestPosition = p.getGBestPosition().copy();

                this.bestNeighbor = p.getNum();

            }

        }

        if( this.bestNeighbor >= 0 && this.bestNeighbor != this.getNum() ){

            Particle p = this.neighbors[ this.bestNeighbor ];

            if( p != null ){
                this.interactions.add( p );
            }

        }

    }

    void updatePBest(){

        float value = valueField.getValue( position );

        // Update local pbest
        if( ( cfg.PSO_MINIMIZING && value < pBestValue ) || ( cfg.PSO_MAXIMIZING && value > pBestValue ) ){

            this.failures = 0;

            this.lastPBestValue = this.pBestValue;
            this.pBestValue = value;
            this.pBestPosition = position.copy();
            this.pBestUpdate = countIter;

        }

        else{

            this.failures += 1;

        }

        // Update local gbest
        if( ( cfg.PSO_MINIMIZING && value < gBestValue ) || ( cfg.PSO_MAXIMIZING && value > gBestValue ) ){

            this.lastGBestValue = this.gBestValue;
            this.gBestValue = value;
            this.gBestPosition = position.copy();

        }


    }

    void resetOptimum(){

        this.resetOptimumValues();
        this.resetOptimumPosition();

    }

    void resetOptimumValues(){

        if( cfg.PSO_MINIMIZING ){

            this.gBestValue = cfg.PSO_INIT;
            this.pBestValue = cfg.PSO_INIT;
            this.pBestUpdate = 0;
            this.lastGBestValue = cfg.PSO_INIT;
            this.lastPBestValue = cfg.PSO_INIT;

        }

    }

    void resetOptimumPosition(){

        float xMin = cfg.SIMULATION_MIN_X;
        float xMax = cfg.SIMULATION_MAX_X;
        float yMin = cfg.SIMULATION_MIN_Y;
        float yMax = cfg.SIMULATION_MAX_Y;

        float posX = ( float ) ( Math.random() * ( ( xMax - xMin ) ) ) + xMin;
        float posY = ( float ) ( Math.random() * ( ( yMax - yMin ) ) ) + yMin;

        this.gBestPosition = new VectorCoord( posX, posY );
        this.pBestPosition = new VectorCoord( posX, posY );

    }

    //===================================================//
    //                      DISPLAY                      //
    //===================================================//

    void drawLaser(){

        this.laser.draw();

    }

    void drawOnlyParticle(){

        super.drawOnlyParticle();

        if( cfg.SIM_SHOW_DIRECTIONS ){

            float maxFlow = this.flowField.getMaxLength() / 2;
            float maxSteering = 0.5;// (cfg.PARTICLE_FLOW_MAX + cfg.PARTICLE_VELOCITY_MAX) / cfg.SIMULATION_SUBITERATIONS;

            super.drawDirection( psoVector.copy(), cfg.PARTICLE_VELOCITY_MAX, cfg.COLOR_PARTICLE_PSOVECTOR );
            //super.drawDirection( flowVector.copy(), maxFlow, cfg.COLOR_PARTICLE_FLOWVECTOR );
            //super.drawDirection( steeringVector.copy(), maxSteering, cfg.COLOR_PARTICLE_STEERINGVECTOR );

        }

    }

    void draw(){

        super.draw();

        if( cfg.SIM_SHOW_CENTER && cfg.SIM_USE_NEIGHBORCENTER ){

            VectorScreen center = this.neighborsCenter.transToScreen();

            fill( cfg.COLOR_NEIGHBOR_CENTER, 100 );
            //noStroke();//stroke( cfg.swarmCenterColor );
            stroke( cfg.COLOR_NEIGHBOR_CENTER );
            strokeWeight( 3 );
            pushMatrix();
            //ellipseMode(CENTER);
            //ellipse( center.x, center.y, cfg.neighborCenterRadius, cfg.neighborCenterRadius );
            float size = 10;
            line( center.x - size / 2, center.y + size / 2, center.x + size / 2 , center.y - size / 2 );
            line( center.x - size / 2 , center.y - size / 2, center.x + size / 2 , center.y + size / 2 );
            strokeWeight( 1 );
            popMatrix();

        }

        if( cfg.SIM_SHOW_DIRECTIONS ){

            float maxFlow = 0.5;//this.flowField.getMaxLength();
            float maxSteering = 0.5;//(cfg.PARTICLE_FLOW_MAX + cfg.PARTICLE_VELOCITY_MAX) * 1 / cfg.SIMULATION_SUBITERATIONS;
            /*
            super.drawDirection( psoVector.copy(), cfg.PARTICLE_VELOCITY_MAX, cfg.COLOR_PARTICLE_PSOVECTOR );
            super.drawDirection( flowVector.copy(), maxFlow, cfg.COLOR_PARTICLE_FLOWVECTOR );
            super.drawDirection( steeringVector.copy(), maxSteering, cfg.COLOR_PARTICLE_STEERINGVECTOR );
            */
        }

    }

}
