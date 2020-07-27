class Simulation{

    private int flowFieldNum;
    private int valueFieldNum;
    private String neighborhoodTitle;

    private ValueField valueField;
    private FlowField flowField;
    private ColorMap colorMap;
    private Environment environment;

    private ParticleCommand selectParticleCommand;

    private SwarmPSO pso;
    private SwarmZPSO zpso;
    private SwarmPPSO ppso;

    private ArrayList<Particle> allParticles;

    private boolean pause;

    private ArrayList<Float> gBestResultList;
    private ArrayList<Float> angleResultList;
    private ArrayList<Float> sumEnergyResultList;
    private ArrayList<Float> avgEnergyResultList;
    private ArrayList<Float> avgNeighborResultList;
    private ArrayList<Float> distListCenter;
    private ArrayList<Float> distListNeighbor;
    private ArrayList<Float> windFlowerList;
    private ArrayList<ArrayList<Float>> usedEnergyResultList;
    private ArrayList<ArrayList<Float>> leftEnergyResultList;
    private ArrayList<ArrayList<String>> neighborResultList;
    private ArrayList<ArrayList<Float>> distListOpt;
    private ArrayList<ArrayList<Float>> pBestResultList;
    private ArrayList<ArrayList<Float>> pBestUpdateList;
    private ArrayList<ArrayList<Float>> orientationListOpt;
    private ArrayList<ArrayList<Float>> orientationListWind;

    //===================================================//
    //                 INITIALISATION                    //
    //===================================================//

    Simulation(){

        this.flowFieldNum = cfg.SIM_FLOWFIELD_NUM;
        this.valueFieldNum = cfg.SIM_VALUEFIELD_NUM;
        this.neighborhoodTitle = cfg.PARTICLE_NH_TITLE;

        this.selectParticleCommand = new SelectParticle();
        this.allParticles = new ArrayList<Particle>();
        this.gBestResultList = new ArrayList<Float>();
        this.angleResultList = new ArrayList<Float>();
        this.sumEnergyResultList = new ArrayList<Float>();
        this.avgEnergyResultList = new ArrayList<Float>();
        this.avgNeighborResultList = new ArrayList<Float>();
        this.distListCenter = new ArrayList<Float>();
        this.distListNeighbor = new ArrayList<Float>();
        this.windFlowerList = new ArrayList<Float>();
        this.usedEnergyResultList = new ArrayList<ArrayList<Float>>();
        this.leftEnergyResultList = new ArrayList<ArrayList<Float>>();
        this.neighborResultList = new ArrayList<ArrayList<String>>();
        this.distListOpt = new ArrayList<ArrayList<Float>>();
        this.pBestResultList = new ArrayList<ArrayList<Float>>();
        this.pBestUpdateList = new ArrayList<ArrayList<Float>>();
        this.orientationListOpt = new ArrayList<ArrayList<Float>>();
        this.orientationListWind = new ArrayList<ArrayList<Float>>();

        countFrames = 0;
        countIter = 0;

        if( cfg.PSO_MINIMIZING )    psoGBest = cfg.PSO_INIT;

        this.pause = false;

        this.init();

        for( Particle p : this.getParticles() ){

            this.usedEnergyResultList.add( new ArrayList<Float>() );
            this.leftEnergyResultList.add( new ArrayList<Float>() );
            this.neighborResultList.add( new ArrayList<String>() );
            this.distListOpt.add( new ArrayList<Float>() );
            this.pBestResultList.add( new ArrayList<Float>() );
            this.pBestUpdateList.add( new ArrayList<Float>() );
            this.orientationListOpt.add( new ArrayList<Float>() );
            this.orientationListWind.add( new ArrayList<Float>() );

        }

        this.resetOptimum();


    }

    //===================================================//
    //                     SIMUALTION                    //
    //===================================================//

    void pause(){

        this.pause = ! this.pause;

    }

    void run(){

        if( !this.pause ){

            if( countFrames % cfg.SIMULATION_SUBITERATIONS == 0 || countIter == 0 ){

                this.calcPSO();

                countIter += 1;

                this.updateResultLists();                

            }

            psoGBest = this.getGBest();

            this.calcNeighbors();
            this.calcSwarms();
            this.runSwarms();

            if( cfg.SIM_USE_COLLISION ){

                this.avoidCollision();

            }

            this.calcEnergySwarms();

            countFrames += 1;

        }

    }

    //===================================================//
    //                     GETTER                        //
    //===================================================//

    ArrayList<Particle> getParticles() {

        if( cfg.INIT_PSO )   return pso.getParticles();
        if( cfg.INIT_PPSO )  return ppso.getParticles();
        if( cfg.INIT_ZPSO )  return zpso.getParticles();
        return new ArrayList<Particle>();

    }

    float getGBest(){

        if( cfg.INIT_PSO )       return pso.getGBestValue();
        if( cfg.INIT_ZPSO )      return zpso.getGBestValue();
        if( cfg.INIT_PPSO )      return ppso.getGBestValue();
        return cfg.PSO_INIT;

    }

    float getAngle(){

        if( cfg.INIT_PSO )       return pso.getAngleValue();
        if( cfg.INIT_ZPSO )      return zpso.getAngleValue();
        if( cfg.INIT_PPSO )      return ppso.getAngleValue();
        return 0;

    }

    float getSumEnergy(){

        if( cfg.INIT_PSO )       return pso.getSumEnergyValue();
        if( cfg.INIT_ZPSO )      return zpso.getSumEnergyValue();
        if( cfg.INIT_PPSO )      return ppso.getSumEnergyValue();
        return 0;

    }

    float getAvgEnergy(){

        if( cfg.INIT_PSO )       return pso.getAvgEnergyValue();
        if( cfg.INIT_ZPSO )      return zpso.getAvgEnergyValue();
        if( cfg.INIT_PPSO )      return ppso.getAvgEnergyValue();
        return 0;

    }

    float getMinEnergy(){

        if( cfg.INIT_PSO )       return pso.getMinEnergyValue();
        if( cfg.INIT_ZPSO )      return zpso.getMinEnergyValue();
        if( cfg.INIT_PPSO )      return ppso.getMinEnergyValue();
        return 0;

    }

    float getMaxEnergy(){

        if( cfg.INIT_PSO )       return pso.getMaxEnergyValue();
        if( cfg.INIT_ZPSO )      return zpso.getMaxEnergyValue();
        if( cfg.INIT_PPSO )      return ppso.getMaxEnergyValue();
        return 0;

    }

    float getAvgNeighbor(){

        if( cfg.INIT_PSO )       return pso.getAvgNeighborValue();
        if( cfg.INIT_ZPSO )      return zpso.getAvgNeighborValue();
        if( cfg.INIT_PPSO )      return ppso.getAvgNeighborValue();
        return 0;

    }

    float getMinNeighbor(){

        if( cfg.INIT_PSO )       return pso.getMinNeighborValue();
        if( cfg.INIT_ZPSO )      return zpso.getMinNeighborValue();
        if( cfg.INIT_PPSO )      return ppso.getMinNeighborValue();
        return 0;

    }

    float getMaxNeighbor(){

        if( cfg.INIT_PSO )       return pso.getMaxNeighborValue();
        if( cfg.INIT_ZPSO )      return zpso.getMaxNeighborValue();
        if( cfg.INIT_PPSO )      return ppso.getMaxNeighborValue();
        return 0;

    }

    float getWindFlower(){


        ArrayList<Particle> swarm = this.getParticles();
        int count = 0;
        for( Particle p : swarm ){

            Float angle = p.getOrientationWind();

            if( angle < 45 ){
                count += 1;
            }

        }

        return count;

    }

    float getDistCenter(){

        VectorCoord center = this.getSwarmCenter().copy();
        VectorCoord psoPos = new VectorCoord( cfg.PSO_X, cfg.PSO_Y );

        return psoPos.distance( center );

    }


    float getDistNeighbor(){

        float totalDistance = 0;

        ArrayList<Particle> swarm = this.getParticles();
        for( int i = 0; i < swarm.size(); i++){

            int numI = swarm.get(i).getNum();

            float distance = 0;

            for( int j = 0; j < swarm.size(); j++){

                int numJ = swarm.get(j).getNum();

                if( numI != numJ ){

                    VectorCoord iPos = swarm.get(i).position.copy();
                    VectorCoord jPos = swarm.get(j).position.copy();

                    float nextDistance = iPos.distance( jPos );
                    distance += nextDistance;

                }

            }

            totalDistance += ( distance / swarm.size() );

        }

        totalDistance = totalDistance / swarm.size();

        return totalDistance;

    }

    float [] getAngleResultList(){

        return this.floatListToArray( this.angleResultList );

    }

    float [] getGBestResultList(){

        return this.floatListToArray( this.gBestResultList );

    }

    float [] getSumEnergyResultList(){

        return this.floatListToArray( this.sumEnergyResultList );

    }

    float [] getAvgEnergyResultList(){

        return this.floatListToArray( this.avgEnergyResultList );

    }

    float [] getAvgNeighborResultList(){

        return this.floatListToArray( this.avgNeighborResultList );

    }

    float [] getDistListCenter(){

        return this.floatListToArray( this.distListCenter );

    }

    float [] getDistListNeighbor(){

        return this.floatListToArray( this.distListNeighbor );

    }

    float [] getWindFlowerList(){

        return this.floatListToArray( this.windFlowerList );

    }

    float [] getUsedEnergyResultList( int num ){

        ArrayList<Float> list = this.usedEnergyResultList.get( num );
        return this.floatListToArray( list );

    }

    float [] getLeftEnergyResultList( int num ){

        ArrayList<Float> list = this.leftEnergyResultList.get( num );
        return this.floatListToArray( list );

    }

    String [] getNeighborResultList( int num ){

        ArrayList<String> list = this.neighborResultList.get( num );
        return this.stringListToArray( list );

    }


    float [] getDistListOpt( int num ){

        ArrayList<Float> list = this.distListOpt.get( num );
        return this.floatListToArray( list );

    }


    float [] getPBestResultList( int num ){

        ArrayList<Float> list = this.pBestResultList.get( num );
        return this.floatListToArray( list );

    }

    float[] getPBestUpdateList( int num ){

        ArrayList<Float> list = this.pBestUpdateList.get( num );
        return this.floatListToArray( list );

    }

    float[] getOrientationListOpt( int num ){

        ArrayList<Float> list = this.orientationListOpt.get( num );
        return this.floatListToArray( list );

    }

    float[] getOrientationListWind( int num ){

        ArrayList<Float> list = this.orientationListWind.get( num );
        return this.floatListToArray( list );

    }



    //===================================================//
    //                     HELPER                        //
    //===================================================//

    void updateResultLists(){

        this.gBestResultList.add( this.getGBest() );
        this.angleResultList.add( this.getAngle() );
        this.sumEnergyResultList.add( this.getSumEnergy() );
        this.avgEnergyResultList.add( this.getAvgEnergy() );
        this.avgNeighborResultList.add( this.getAvgNeighbor() );
        this.distListCenter.add( this.getDistCenter() );
        this.distListNeighbor.add( this.getDistNeighbor() );
        this.windFlowerList.add( this.getWindFlower() );

        for( Particle p : this.getParticles() ){

            int num = p.getNum();

            this.usedEnergyResultList.get( num ).add( p.getUsedEnergy() );
            this.leftEnergyResultList.get( num ).add( p.getLeftEnergy() );
            this.neighborResultList.get( num ).add( p.getNeighborString() );
            this.distListOpt.get( num ).add( p.getDistOpt() );
            this.pBestResultList.get( num ).add( p.getPBest() );
            this.pBestUpdateList.get( num ).add( p.getPBestUpdate() );
            this.orientationListOpt.get( num ).add( p.getOrientationOpt() );
            this.orientationListWind.get( num ).add( p.getOrientationWind() );

        }

    }


    String[] stringListToArray( ArrayList<String> list ){

        String [] resultArray = new String[ list.size() ];
        int i = 0;

        for( String s : list ) {

            resultArray[ i++ ] = ( s != null ? s : "" );

        }

        return resultArray;

    }

    float[] floatListToArray( ArrayList<Float> list ){

        float [] resultArray = new float[ list.size() ];
        int i = 0;

        for( Float f : list ) {

            resultArray[ i++ ] = ( f != null ? f : Float.NaN );

        }

        return resultArray;

    }

    VectorCoord getSwarmCenter(){

        if( cfg.INIT_PSO )       return pso.getSwarmCenter();
        if( cfg.INIT_ZPSO )      return zpso.getSwarmCenter();
        if( cfg.INIT_PPSO )      return ppso.getSwarmCenter();
        return new VectorCoord( 0, 0 );

    }

    void resetOptimum(){

        if( cfg.INIT_PSO )       pso.resetOptimum();
        if( cfg.INIT_ZPSO )      zpso.resetOptimum();
        if( cfg.INIT_PPSO )      ppso.resetOptimum();

    }

    void runSwarms(){

        if( cfg.INIT_PSO )       pso.move();
        if( cfg.INIT_ZPSO )      zpso.move();
        if( cfg.INIT_PPSO )      ppso.move();

    }

    void calcSwarms(){

        if( cfg.INIT_PSO )       pso.calcSteering();
        if( cfg.INIT_ZPSO )      zpso.calcSteering();
        if( cfg.INIT_PPSO )      ppso.calcSteering();

    }

    void calcEnergySwarms(){

        if( cfg.INIT_PSO )       pso.calcEnergy();
        if( cfg.INIT_ZPSO )      zpso.calcEnergy();
        if( cfg.INIT_PPSO )      ppso.calcEnergy();

    }

    void calcPSO(){

        if( cfg.INIT_PSO )       pso.calcPSO();
        if( cfg.INIT_ZPSO )      zpso.calcPSO();
        if( cfg.INIT_PPSO )      ppso.calcPSO();

    }

    void calcNeighbors(){

        if( cfg.INIT_PSO )       pso.calcNeighbors();
        if( cfg.INIT_ZPSO )      zpso.calcNeighbors();
        if( cfg.INIT_PPSO )      ppso.calcNeighbors();

    }

    void avoidCollision(){

        Particle [] list = allParticles.toArray( new Particle[ allParticles.size() ] );

        int run = 0;
        int collisionCount = 1;

        while( collisionCount > 0 ){

            run += 1;

            if( run > 1000 ){
                break;
            }

            collisionCount = 0;

            for( int i = 0; i < list.length; i++ ){

                for( int j = 0; j < list.length; j++ ){

                    if( j != i ){

                        PVector collisionPosition = getCollisionDynamicStaticCircle( list[ i ], list[ j ] );

                        boolean collision1 = this.getCollision( list[ i ], list[ j ] );
                        boolean collision2 = (collisionPosition.x != -999 && collisionPosition.y != -999 );

                        boolean collisionHappening = ( collision1 );// || collision2 );

                        if( collisionHappening ){

                            collisionCount += 1;
                            this.setPositionDynamicStaticCircle( i, j );

                        }

                    }

                }
            }

        }

    }

    PVector getClosestPointOnLine( float x1, float y1, float x2, float y2, float x0, float y0 ){

        float a1 = y2 -y1;
        float b1 = x1 - x2;

        double c1 = ( y2 - y1 ) * x1 + ( x1 - x2 ) * y1;
        double c2 = (-b1) * x0 + a1 * y0;
        double det = a1 * a1 - (-b1) * b1;
        float cx = 0;
        float cy = 0;

        if( det != 0 ){
            cx = (float) ( ( a1 * c1 - b1 * c2 ) / det );
            cy = (float) ( ( a1 * c2 - (-b1) * c1 ) / det );
        }
        else{
            cx = x0;
            cy = y0;
        }

        return new PVector( cx, cy );

    }

    boolean getCollision( Particle a, Particle b ){

        float minDist = cfg.PARTICLE_SIZE_COORDINATE / 2 + cfg.PARTICLE_REPULSION_COORDINATE;
        return a.position.copy().distance( b.position.copy() ) < minDist;

    }


    PVector getCollisionDynamicStaticCircle( Particle a, Particle b ){

        PVector aPos = a.position.copy().transToPVector();
        PVector bPos = b.position.copy().transToPVector();

        PVector aVel = a.discVelocity.copy().transToPVector();
        PVector bVel = b.discVelocity.copy().transToPVector();

        PVector closestPoint = this.getClosestPointOnLine( aPos.x, aPos.y, aPos.x + aVel.x, aPos.y + aVel.y, bPos.x, bPos.y );
        double closestDistSq = Math.pow( bPos.x - closestPoint.x, 2 ) + Math.pow( bPos.y - closestPoint.y, 2 );

        float radius = cfg.PARTICLE_SIZE_COORDINATE;

        if( this.getCollision( a, b ) && closestDistSq <= Math.pow( ( radius + cfg.PARTICLE_REPULSION_COORDINATE), 2) ){

            double backDist = Math.sqrt( Math.pow( radius * 2, 2 ) - closestDistSq );
            double movementVectorLength = Math.sqrt( Math.pow( aVel.x, 2 ) + Math.pow( aVel.y, 2 ) );
            float cx = (float) ( closestPoint.x - backDist * ( aVel.x / movementVectorLength ) );
            float cy = (float) ( closestPoint.y - backDist * ( aVel.y / movementVectorLength ) );

            if( Float.isNaN(cx) || Float.isNaN(cy) )
                return new PVector( -999, -999 );
            return new PVector( cx, cy );

        }
        else{
            return new PVector( -999, -999 );
        }

    }


    void setPositionDynamicStaticCircle( int i, int j ){

        // SET NEW VELOCITY

        Particle [] list = allParticles.toArray( new Particle[ allParticles.size() ] );

        PVector aPos = list[ i ].position.copy().transToPVector();
        PVector bPos = list[ j ].position.copy().transToPVector();

        PVector aVel = list[ i ].discVelocity.copy().transToPVector();
        PVector bVel = list[ j ].discVelocity.copy().transToPVector();

        VectorCoord aPosCoord = list[ i ].position.copy();
        VectorCoord bPosCoord = list[ j ].position.copy();

        PVector c1 = new PVector( bPos.x - aPos.x, bPos.y - aPos.y );
        c1.normalize();
        float distance = aPosCoord.distance( bPosCoord );

        float r = cfg.PARTICLE_SIZE_COORDINATE / 2 + cfg.PARTICLE_REPULSION_COORDINATE;

        float pullMag = abs( distance - r * 2 / 2 );

        PVector pull = new PVector( pullMag * c1.x, pullMag * c1.y );

        aPos.sub( pull );

        VectorCoord pos = new VectorCoord( aPos.x, aPos.y );

        list[ i ].position = pos.copy();
        list[ i ].laser.updateParticlePos( pos.copy() );

    }

    //===================================================//
    //                     DISPLAY                       //
    //===================================================//

    void drawFlowField(){

        cfg.COLOR_FLOWFIELD_VECTOR = color(0,0,0);
        flowField.draw();
        environment.setColor( color( 255, 255, 255 ) );
        environment.draw();

    }

    void draw(){

        colorMap.draw();
        flowField.draw();
        valueField.drawMinimum();
        environment.setColor( cfg.COLOR_ENVIRONMENT );
        environment.draw();
        drawSwarms();

    }

    void drawSwarms(){

        if( cfg.INIT_PSO )       pso.display();
        if( cfg.INIT_ZPSO )      zpso.display();
        if( cfg.INIT_PPSO )      ppso.display();

    }

    void onMousePressed(){

        for( Particle p : allParticles ){

            if( p.isMouseOver() ){

                p.execute();

            }

        }

    }

    //===================================================//
    //               HELPER INITIALISATION               //
    //===================================================//

    void init(){

        initFlowField();
        initColorMap();
        initValueField();
        initEnvironment();
        initSwarms();

    }


    void initSwarms(){

        if( cfg.INIT_PSO ){

            pso = new SwarmPSO( this.flowField, this.valueField, this.neighborhoodTitle, this.selectParticleCommand );
            allParticles.addAll( pso.getParticles() );
            pso.resetOptimum();

        }

        if( cfg.INIT_ZPSO ){

            zpso = new SwarmZPSO( this.flowField, this.valueField, this.neighborhoodTitle, this.selectParticleCommand );
            allParticles.addAll( zpso.getParticles() );

        }

        if( cfg.INIT_PPSO ){

            ppso = new SwarmPPSO( this.flowField, this.valueField, this.neighborhoodTitle, this.selectParticleCommand );
            allParticles.addAll( ppso.getParticles() );

        }

    }

    void initEnvironment(){

        environment = new Environment();

    }

    void initValueField(){

        valueField = new ValueField( this.valueFieldNum );

    }

    void initColorMap(){

        int posX = cfg.SIMULATION_START_X;
        int posY = 10; //[TODO] should be cfg.SIMULATION_START_Y //=20
        VectorScreen pos = new VectorScreen( posX, posY );

        int sizeX = cfg.SIMULATION_SIZE_X;
        int sizeY = cfg.SIMULATION_SIZE_Y;
        VectorScreen size = new VectorScreen( sizeX, sizeY );

        colorMap = new ColorMap( this.flowField, "ColorMap", pos, size );

    }

    void initFlowField(){

        int posX = cfg.SIMULATION_START_X;
        int posY = 10; //[TODO] should be cfg.SIMULATION_START_Y //=20
        VectorScreen pos = new VectorScreen( posX, posY );

        int sizeX = cfg.SIMULATION_SIZE_X;
        int sizeY = cfg.SIMULATION_SIZE_Y;
        VectorScreen size = new VectorScreen( sizeX, sizeY );

        flowField = new FlowField( this.flowFieldNum, "FlowField", pos, size );

    }

}
