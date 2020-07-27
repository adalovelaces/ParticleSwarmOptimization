class Neighborhood{

    private int size;
    private NeighborNode [] nodes;
    private float[] memory;

    private float probPro;
    private float probCon;
    private float payoffPro;
    private float payoffCon;
    private float swarmPro;
    private float swarmCon;
    private float switchPro;
    private float switchCon;

    Neighborhood( int size ){

        this.size = size;
        this.nodes = new NeighborNode[ size ];
        this.init();

        this.probPro = 0.05;
        this.probCon = -0.05;
        this.payoffPro = 0.05;
        this.payoffCon = -0.05;
        this.switchPro = 0.05;
        this.switchCon = -0.05;
        this.swarmPro = -0.05;
        this.swarmCon = 0.05;

    }

    void init(){

        int centerX = cfg.NEIGHBOR_AREA_X + cfg.NEIGHBOR_SIZE_X / 2  + cfg.MARGIN / 4;
        int centerY = cfg.NEIGHBOR_AREA_Y + cfg.NEIGHBOR_SIZE_Y / 2;

        float slice = (float) Math.PI;
        slice = 2 * slice / this.size;

        for( int i = 0; i < this.size; i++ ){

            float angle = slice * i;
            float radius = cfg.NEIGHBOR_SIZE_X / 2 * 0.8;

            int x = (int) Math.ceil( ( centerX + radius * Math.cos( angle ) ) );
            int y = (int) Math.ceil( ( centerY + radius * Math.sin( angle ) ) );

            radius = radius * 1.1;
            int xLabel = (int) Math.ceil( ( centerX + radius * Math.cos( angle ) ) );
            int yLabel = (int) Math.ceil( ( centerY + radius * Math.sin( angle ) ) );

            nodes[ i ] = new NeighborNode( x, y, xLabel, yLabel, i );

            NeighborNode n = nodes[ i ];

        }

    }

    //===================================================//
    //               CALCULATIONS NEIGHBORS              //
    //===================================================//

    void calcNeighbors( Particle[] swarm, String title ){

        for( int i = 0; i < swarm.length; i++ ){

            Particle p = swarm[ i ];
            this.calcNeighborsParticle( p, swarm, title );

            p.calcNeighborsCenter();

        }

    }

    void calcNeighborsParticle( Particle p, Particle[] swarm, String title ){

        String type = title;

        if( title.contains("-") ){

            String [] splittedTitle = title.split("-");

            type = splittedTitle[0];
            cfg.PARTICLE_COMMUNICATION_RADIUS = splittedTitle[1].charAt(1);
            cfg.PARTICLE_NH_SIZE = splittedTitle[2].charAt(1);

        }

        switch( type ){

            case "GBest":

                this.calcNeighborGBest( p, swarm );
                break;

            case "Ring":

                this.calcNeighborRing( p, swarm );
                break;

            case "Star":

                this.calcNeighborStar( p, swarm );
                break;

            case "Neumann":

                this.calcNeighborVonNeumann( p, swarm );
                break;

            case "Payoff":

                this.calcNeighborPayoff( p, swarm, this.payoffPro, this.payoffCon );
                break;

            case "Prob":

                this.calcNeighborProb( p, swarm, this.probPro, this.probCon );
                break;

            case "PayoffProb":

                this.calcNeighborPayoffProb( p, swarm, this.payoffPro, this.payoffCon, this.probPro, this.probCon );
                break;

            case "PayoffSw":

                this.calcNeighborPayoffSwitch( p, swarm, this.payoffPro, this.payoffCon, this.switchPro, this.switchCon );
                break;

            case "ProbSw":

                this.calcNeighborProbSwitch( p, swarm, this.probPro, this.probCon, this.switchPro, this.switchCon );
                break;

            case "PayoffProbSw":

                this.calcNeighborPayoffProbSwitch( p, swarm, this.payoffPro, this.payoffCon, this.probPro, this.probCon, this.switchPro, this.switchCon );
                break;

            case "Sub":

                this.calcNeighborSubswarms( p, swarm, this.swarmPro, this.swarmCon );
                break;

            default:
              return;

        }

    }


    //===================================================//
    //            CALCULATIONS TOPOLOGIES                //
    //===================================================//

    void calcNeighborGBest( Particle p, Particle[] swarm ){

        int limit = cfg.PARTICLE_NH_SIZE-1;
        ArrayList<Particle> particleList = this.getParticlesInDistance( p, swarm );

        ArrayList<Particle> resultList = this.getReducedListRandom( particleList, limit );

        p.neighbors = this.getParticleArrayFromList( resultList, swarm.length );;

    }

    void calcNeighborRing( Particle p, Particle[] swarm ){

        ArrayList<Particle> particleList = this.getParticlesInDistance( p, swarm );
        Particle[] particles = this.getParticleArrayFromList( particleList, swarm.length );

        if( particleList.size() == 0 ){

            p.neighbors = particles;
            return;

        }

        Particle neighborLeft = this.getSideParticle( p, particles, "Left", 1 );
        Particle neighborRight = this.getSideParticle( p, particles, "Right", 1 );

        particles = new Particle[ swarm.length ];

        if( neighborLeft != null ){

            particles[ neighborLeft.getNum() ] = neighborLeft;

        }

        if( neighborRight != null ){

            particles[ neighborRight.getNum() ] = neighborRight;

        }

        p.neighbors = particles;

    }

    void calcNeighborStar( Particle p, Particle[] swarm ){

        ArrayList<Particle> particleList = this.getParticlesInDistance( p, swarm );
        Particle[] particles = this.getParticleArrayFromList( particleList, swarm.length );

        if( particleList.size() == 0 ){

            p.neighbors = particles;
            return;

        }

        Particle firstParticle = this.getFirstParticle( p, particles );

        if( firstParticle ==  null ){

            p.neighbors = particles;
            return;

        }

        if( firstParticle.getNum() != p.getNum() ){

            particles = new Particle[ swarm.length ];
            particles[ firstParticle.getNum()  ] = swarm[ firstParticle.getNum() ];

        }

        p.neighbors = particles;

    }

    void calcNeighborVonNeumann( Particle p, Particle[] swarm ){

        ArrayList<Particle> particleList = this.getParticlesInDistance( p, swarm );
        Particle[] particles = this.getParticleArrayFromList( particleList, swarm.length );

        if( particleList.size() == 0 ){

            p.neighbors = particles;
            return;

        }

        Particle neighborLeft = this.getSideParticle( p, particles, "Left", 2 );
        Particle neighborRight = this.getSideParticle( p, particles, "Right", 2 );

        particles = new Particle[ swarm.length ];

        if( neighborLeft != null ){

            particles[ neighborLeft.getNum() ] = neighborLeft;

        }

        if( neighborRight != null ){

            particles[ neighborRight.getNum() ] = neighborRight;

        }

        p.neighbors = particles;

    }

    void calcNeighborPayoff( Particle p, Particle[] swarm, float payoffPro, float payoffCon){

        this.updatePayoffMemory( p, payoffPro, payoffCon );


        ArrayList<Particle> particleList = this.getParticlesInDistance( p, swarm );
        ArrayList<Particle> resultList = this.getParticlesPayoff( p, swarm, particleList );


        p.neighbors = this.getParticleArrayFromList( resultList, swarm.length );

    }

    void calcNeighborProb( Particle p, Particle[] swarm, float probPro, float probCon ){

        this.updateProbMemory( p, probPro, probCon );


        ArrayList<Particle> particleList = this.getParticlesInDistance( p, swarm );
        ArrayList<Particle> resultList = this.getParticlesProb( p, swarm, particleList );

        if( resultList.size() == 0 ){
            resultList = this.getReducedListRandom( particleList, 1 );
        }


        p.neighbors = this.getParticleArrayFromList( resultList, swarm.length );

    }

    void calcNeighborPayoffProb( Particle p, Particle[] swarm, float payoffPro, float payoffCon, float probPro, float probCon ){

        this.updatePayoffMemory( p, payoffPro, payoffCon );
        this.updateProbMemory( p, probPro, probCon );


        ArrayList<Particle> particleList = this.getParticlesInDistance( p, swarm );
        ArrayList<Particle> payoffList = this.getParticlesPayoff( p, swarm, particleList );
        ArrayList<Particle> probList = this.getParticlesProb( p, swarm, payoffList );

        if( probList.size() == 0 ){
            probList = this.getReducedListRandom( particleList, 1 );
        }


        p.neighbors = this.getParticleArrayFromList( probList, swarm.length );

    }

    void calcNeighborPayoffSwitch( Particle p, Particle[] swarm, float payoffPro, float payoffCon, float siwtchPro, float switchCon ){

        this.updatePayoffMemory( p, payoffPro, payoffCon );
        this.updateStrategy( p, switchPro, switchCon );

        if( p.strategy.equals( "Cooperate" ) ){

            ArrayList<Particle> particleList = this.getParticlesInDistance( p, swarm );
            ArrayList<Particle> resultList = this.getParticlesPayoff( p, swarm, particleList );

            p.neighbors = this.getParticleArrayFromList( resultList, swarm.length );
            return;

        }

        else{

            this.calcNeighborRing( p, swarm );

        }

    }

    void calcNeighborProbSwitch( Particle p, Particle[] swarm, float probPro, float probCon, float switchPro, float switchCon ){

        this.updateProbMemory( p, probPro, probCon );
        this.updateStrategy( p, switchPro, switchCon );

        if( p.strategy.equals( "Cooperate" ) ){

            ArrayList<Particle> particleList = this.getParticlesInDistance( p, swarm );
            ArrayList<Particle> resultList = this.getParticlesProb( p, swarm, particleList );

            p.neighbors = this.getParticleArrayFromList( resultList, swarm.length );
            return;

        }

        else{

            this.calcNeighborRing( p, swarm );

        }

    }

    void calcNeighborPayoffProbSwitch( Particle p, Particle[] swarm, float payoffPro, float payoffCon, float probPro, float probCon, float switchPro, float switchCon ){

        this.updatePayoffMemory( p, payoffPro, payoffCon );
        this.updateProbMemory( p, probPro, probCon );
        this.updateStrategy( p, switchPro, switchCon );

        if( p.strategy.equals( "Cooperate" ) ){

            ArrayList<Particle> particleList = this.getParticlesInDistance( p, swarm );
            ArrayList<Particle> payoffList = this.getParticlesPayoff( p, swarm, particleList );
            ArrayList<Particle> probList = this.getParticlesProb( p, swarm, payoffList );

            if( probList.size() == 0 ){
                probList = this.getReducedListRandom( particleList, 1 );
            }

            p.neighbors = this.getParticleArrayFromList( probList, swarm.length );
            return;

        }

        else{

            this.calcNeighborRing( p, swarm );

        }

    }

    void calcNeighborSubswarms( Particle p, Particle[] swarm, float swarmPro, float swarmCon ){

        int size = cfg.PARTICLE_NH_SIZE - 1;

        if( countIter <= 2 ){

            this.createSubSwarms( p, swarm, size );

        }

        ArrayList<Particle> group = p.getGroup();
        if( group.size() < size ){

            this.addSingleToGroup( p, swarm );

        }

        if( p.isGroupLeader() ){

            //this.updateSubSwarmStrategy( p, impValue, noImpValue );
            this.updateStrategy( p, swarmPro, swarmCon );

        }


        ArrayList<Particle> particleList = this.getParticlesInDistance( p, swarm );
        ArrayList<Particle> resultList = this.getParticlesSwarm( p, swarm, particleList );


        p.neighbors = this.getParticleArrayFromList( resultList, swarm.length );

    }

    void calcNeighborRandomTwo( Particle p, Particle[] swarm ){

        ArrayList<Particle> particleList = this.getParticlesInDistance( p, swarm );

        Particle p1 = null;
        Particle p2 = null;

        Random r = new Random();

        if( particleList.size() > 2 ){

            int index = r.nextInt( particleList.size() );
            p1 = particleList.get( index );
            particleList.remove( p1 );

            index = r.nextInt( particleList.size() );
            p2 = particleList.get( index );

            particleList = new ArrayList<Particle>();
            particleList.add( p1 );
            particleList.add( p2 );

        }

        Particle[] particles = this.getParticleArrayFromList( particleList, swarm.length );

        p.neighbors = particles;

    }

    //===================================================//
    //                     UPDATE FUNCTIONS              //
    //===================================================//

    void updatePayoffMemory( Particle master, float proValue, float conValue ){

        boolean oneIterationOver =  countFrames % cfg.SIMULATION_SUBITERATIONS == 0 || countIter == 0;
        if( !oneIterationOver ){
            return;
        }

        float value = master.lastGBestValue > master.gBestValue ? proValue : conValue;

        if( countIter < 1 ){
            value = 0;
        }

        ArrayList<Particle> particleList = this.getParticleListFromArray( master.neighbors );

        ParticleCoalition coal = new ParticleCoalition( master, particleList );

        String hashMapKey = coal.getHashMapKey();

        float coalitionValue = master.getCoalitionHashMapValue( hashMapKey );
        coalitionValue += value;

        if( coalitionValue > 1 ){
            coalitionValue = 1;
        }

        if( coalitionValue < 0 ){
            coalitionValue = 0;
        }

        master.setCoalitionHashMapValue( hashMapKey, coalitionValue );

    }

    void updateProbMemory( Particle master, float proValue, float conValue ){

        boolean oneIterationOver =  countFrames % cfg.SIMULATION_SUBITERATIONS == 0 || countIter == 0;
        if( !oneIterationOver ){
            return;
        }


        float value = master.lastGBestValue > master.gBestValue ? proValue : conValue;


        ArrayList<Particle> oldList = this.getParticleListFromArray( master.neighbors );

        for( Particle p : oldList ){

            int num = p.getNum();
            master.neighborsMemory[ num ] += value;

            if( master.neighborsMemory[ num ] > 1 ){
                master.neighborsMemory[ num ] = 1;
            }

            if( master.neighborsMemory[ num ] < 0.05 ){
                master.neighborsMemory[ num ] = 0.05;
            }

        }

    }

    void updateStrategy( Particle master, float proValue, float conValue ){

        boolean oneIterationOver =  countFrames % cfg.SIMULATION_SUBITERATIONS == 0 || countIter == 0;
        if( !oneIterationOver ){
            return;
        }

        float value = master.strategyChangeFactor;
        value += master.lastGBestValue > master.gBestValue ? proValue : conValue;

        if( value < 0.05 ){
            value = 0.05;
        }

        if( value > 1 ){
            value = 1;
        }

        Random r = new Random();
        float prob = r.nextFloat();

        if( prob <= master.strategyChangeFactor ){

            String coop = "Cooperate";
            String def = "Defect";

            if( master.strategy.equals( coop ) ){

                master.strategy = def;

            }
            else{

                master.strategy = coop;

            }

            value = 0.05;

        }

        master.strategyChangeFactor = value;

    }

    void updateSwarmStrategy( Particle master, float proValue, float conValue ){

        boolean oneIterationOver =  countFrames % cfg.SIMULATION_SUBITERATIONS == 0 || countIter == 0;
        if( !oneIterationOver ){
            return;
        }

        float value = master.strategyChangeFactor;
        value += master.lastGBestValue > master.gBestValue ? proValue : conValue;

        if( value < 0 ){
            value = 0;
        }

        if( value > 1 ){
            value = 1;
        }

        if( value <= 0 ){

            master.strategy = "Defect";

        }

        if( value >= 1 ){

            master.strategy = "Cooperate";
            value = 0;

        }

        master.strategyChangeFactor = value;

    }


    //===================================================//
    //                     PAYOFF, PROBABILITY           //
    //===================================================//

    ArrayList<Particle> getParticlesPayoff( Particle master, Particle[] swarm, ArrayList<Particle> particleList ){


        particleList = this.getReducedListRandom( particleList, 5 );

        ArrayList<ParticleCoalition> subsetList = this.getSubsets( master, particleList, 1 );

        ArrayList<ParticleCoalition> bestCoalitions = new ArrayList<ParticleCoalition> ();
        float bestValue = 0;

        for( ParticleCoalition subset : subsetList ){

            String hashMapKey = subset.getHashMapKey();
            float value = master.getCoalitionHashMapValue( hashMapKey );

            if( value >= bestValue ){

                bestValue = value;
                bestCoalitions.add( subset );

            }

        }

        // Delete subset which have become worse during for loop before
        for( int i = 0; i < bestCoalitions.size(); i++ ){

            ParticleCoalition subset = bestCoalitions.get( i );
            if( subset.value < bestValue ){

                bestCoalitions.remove( subset );

            }

        }


        if( bestCoalitions.size() > 0 ){

            Collections.shuffle( bestCoalitions );

            ParticleCoalition bestCoal = bestCoalitions.get( 0 );
            particleList = bestCoal.getParticle();

        }

        return particleList;

    }

    ArrayList<Particle> getParticlesProb( Particle master, Particle[] swarm, ArrayList<Particle> particleList ){

        ArrayList<Particle> resultList = new ArrayList<Particle>();

        Random random = new Random();

        for( Particle p : particleList ){

            float prob = master.neighborsMemory[ p.getNum() ];
            float r = random.nextFloat();

            if( r < prob ){

                resultList.add( p );

            }

        }

        return resultList;

    }

    ArrayList<Particle> getParticlesSwarm( Particle master, Particle[] swarm, ArrayList<Particle> particleList ){

        ArrayList<Particle> resultList = new ArrayList<Particle>();

        boolean cooperated = false;
        for( Particle neighbor : particleList ){

            if( master.isGroupMember( neighbor ) ){

                resultList.add( neighbor );

            }

            // Only group leader can cooperate
            if( master.isGroupLeader() && master.strategy.equals( "Cooperate" ) ){

                resultList.add( neighbor.getGroupLeader() );
                cooperated = true;

            }

        }

        if ( cooperated ){
            master.strategy = "Defect";
        }

        return resultList;

    }

    //===================================================//
    //                       HELPER                      //
    //===================================================//

    ArrayList<Particle> getParticlesInDistance( Particle master, Particle[] swarm ){

        ArrayList<Particle> particleList = new ArrayList<Particle> ();

        for( Particle p : swarm ){

            if( p.getNum() == master.getNum() ){
                continue;
            }

            VectorCoord pPos = p.position.copy();
            VectorCoord masterPos = master.position.copy();

            float distance = masterPos.distance( pPos );

            if( distance <= cfg.PARTICLE_COMMUNICATION_RADIUS ){

                particleList.add( p );

            }

        }

        return particleList;

    }

    ArrayList<Particle> getReducedListRandom( ArrayList<Particle> list, int limit ){

        Collections.shuffle( list );

        if( list.size() < limit ){
            limit = list.size();
        }

        list = new ArrayList<Particle> ( list.subList( 0, limit ) );

        return list;

    }

    ArrayList<ParticleCoalition> getSubsets( Particle searcher, ArrayList<Particle> set, int minSize ){

        ArrayList<ParticleCoalition> subsetList = new ArrayList<ParticleCoalition>();

        int maxSize = (int) Math.pow( 2, set.size() );

        for( int i = 0; i < maxSize; i++ ){

            ArrayList<Particle> subset = new ArrayList<Particle>();

            for( int j = 0; j < set.size(); j++ ){

                if( ((i >> j) & 1) == 1 ){

                    subset.add( set.get( j ) );

                }

            }

            ParticleCoalition coal = new ParticleCoalition( searcher, subset );

            if( subset.size() >= minSize ){
                subsetList.add( coal );
            }

        }

        return subsetList;

    }

    Particle[] getParticleArrayFromList( ArrayList<Particle> particleList, int size ){

        Particle[] particles= new Particle[ size ];

        for( Particle p : particleList ){

            particles[ p.getNum() ] = p;

        }

        return particles;

    }

    void initSubSwarms( Particle p, Particle[] swarm, int size ){

        // In initialisation create subswarms
        if( countFrames == 0 ){

            p.strategy = "Defect";
            this.createSubSwarms( p, swarm, size );

        }

        if( countFrames == 1 ){

            this.checkForSingles( p, swarm );

        }

    }

    void checkForSingles( Particle master, Particle[] swarm ){

        ArrayList<Particle> singles = this.getSingles( swarm );

        for( Particle s : singles ){

            this.addSingleToGroup( s, swarm );

        }

    }

    void addSingleToGroup( Particle single, Particle[] swarm ){

        ArrayList<Particle> neighborsOfSingle = this.getParticlesInAscendingDistance( single, swarm );

        ArrayList<Particle> group = new ArrayList<Particle>();
        Particle neighborWithSmallestGroup = null;
        int smallestSize = 20;

        if( neighborsOfSingle.size() > 0 ){

            for( Particle neighbor : neighborsOfSingle ){

                group = neighbor.getGroup();

                if( group.size() < smallestSize ){
                    neighborWithSmallestGroup = neighbor;
                    smallestSize = group.size();
                }
            }

        }

        if( neighborWithSmallestGroup != null ){

            group = neighborWithSmallestGroup.getGroup();

            single.addMultipleGroupMember( group );

            if( group.size() > 0 ){

                for( int i = 0; i < group.size(); i++ ){

                    Particle member = group.get(i);

                    member.addSingleGroupMember( single );

                }
            }

            //neighborWithSmallestGroup.addSingleGroupMember( single );

        }

    }

    ArrayList<Particle> getSingles( Particle[] swarm ){

        ArrayList<Particle> singles = new ArrayList<Particle>();

        for( Particle s : swarm ){

            if( s.getGroup().size() == 0 ){

                singles.add( s );

            }

        }

        return singles;

    }


    void createSubSwarms( Particle master, Particle[] swarm, int size ){

        int limit = size;
        if( master.group.size() == limit ){

            return;

        }

        ArrayList<Particle> resultList = new ArrayList<Particle> ();

        // Get particles in ascending distance
        ArrayList<Particle> particleList = this.getParticlesInAscendingDistance( master, swarm );

        for( Particle p : particleList ){

            resultList = new ArrayList<Particle>();

            if( master.group.size() == limit ){
                break;
            }

            if( p.getNum() < master.getNum () ){
                continue;
            }

            //Proof if p already belongs to a group
            Particle groupMaster = this.getGroup( master, p, swarm );

            if( groupMaster != null ){

                //Check if master belongs to the same group as p
                if( groupMaster.isGroupMember( master ) ){

                    resultList.add( groupMaster );
                    resultList.addAll( groupMaster.getGroup() );
                    master.addMultipleGroupMember( resultList );
                    break;

                }

            }

            //If p is not a group member yet, add p
            else{

                resultList.add( p );
                resultList.addAll( p.getGroup() );
                master.addMultipleGroupMember( resultList );

            }

        }

        // Add all sub swarm member to all now selected member
        ArrayList<Particle> subSwarm = new ArrayList<Particle>();
        subSwarm.addAll( master.group );
        subSwarm.add( master );

        for( Particle p : master.group ){

            p.addMultipleGroupMember( subSwarm );

        }

    }

    ArrayList<Particle> getNewGroupMember( Particle master, Particle p, ArrayList<Particle> knownMember ){

        ArrayList<Particle> newMember = new ArrayList<Particle>();

        ArrayList<Particle> pGroup = p.getGroup();

        for( Particle pG : pGroup ){

            if( pG.getNum() != master.getNum() && !knownMember.contains( pG ) ){

                newMember.add( pG );

            }

        }

        ArrayList<Particle> resultList = new ArrayList<Particle>();
        resultList.addAll( knownMember );
        resultList.addAll( newMember );

        return resultList;

    }

    Particle getGroup( Particle master, Particle p, Particle[] swarm ){

        for( int i = 0; i < master.getNum(); i++ ){

            if( swarm[ i ].isGroupMember( p ) ){

                return swarm[ i ];

            }

        }

        // Particle does not belong to a group yet
        return null;

    }


    ArrayList<Particle> getParticlesInAscendingDistance( Particle p, Particle[] swarm ){

        ArrayList<Neighbor> neighbors = new ArrayList<Neighbor>();
        ArrayList<Particle> resultNeighbors = new ArrayList<Particle>();

        VectorCoord pPos = p.position.copy();
        float distance = 0;

        Neighbor[] sortingArray = new Neighbor[ swarm.length ];

        for( int i = 0; i < swarm.length; i++ ){

            VectorCoord neighborPos = swarm[ i ].position;
            distance = pPos.distance( neighborPos );

            if( i != p.getNum() && distance <= cfg.PARTICLE_COMMUNICATION_RADIUS ){

                Neighbor n = new Neighbor( swarm[ i ], distance );
                neighbors.add( n );

            }

        }

        // Sort array by ascending distance to particle
        Collections.sort( neighbors );

        for( Neighbor n : neighbors ){

            resultNeighbors.add( n.getParticle() );

        }

        return resultNeighbors;

    }


    ArrayList<Particle> getParticleListFromArray( Particle[] particleArray ){

        ArrayList<Particle> list = new ArrayList<Particle>();

        for( int i = 0; i < particleArray.length; i++ ){

            if( particleArray[ i ] != null ){

                list.add( particleArray[ i ] );

            }

        }

        return list;

    }


    Particle getFirstParticle( Particle searcher, Particle[] particles ){

        particles[ searcher.getNum() ] = searcher;

        Particle firstParticle = null;
        int i = 0;

        while( firstParticle == null && i < particles.length ){

            if( particles[ i ] != null ){

                firstParticle = particles[ i ];

            }

            i++;

        }

        return firstParticle;

    }

    Particle getSideParticle( Particle searcher, Particle[] particles, String side, int stepSize ){

        int index = searcher.getNum();
        Particle neighbor = null;
        int maxCount = particles.length;
        int count = 0;

        while( neighbor == null && count <= maxCount ){

            if( index < 0 ){

                index = particles.length + index;

            }

            if( index > particles.length - 1 ){

                index = index - particles.length;

            }

            if( particles[ index ] != null ){

                neighbor = particles[ index ];

            }

            if( side.equals("Left") ){

                index -= stepSize;

            }

            if( side.equals("Right") ){

                index += stepSize;

            }

            count++;

        }

        return neighbor;

    }

    //===================================================//
    //                    DRAW                           //
    //===================================================//

    void draw(){

        for( NeighborNode n : nodes ){

            n.drawEdges();
            n.drawNode();
            n.drawLabel();

        }

    }

    void drawConnections( Particle [] particle ){

        for( int i = 0; i < particle.length; i++ ){

            Particle p = particle[ i ];

            //Particle position in screen
            VectorScreen pPos = p.position.transToScreen();

            ArrayList<Particle> neighbors = p.getNeighborList();

            if( neighbors != null ){
                for( Particle n : neighbors ){

                    // Neighbor position in screen
                    VectorScreen nPos = n.position.transToScreen();

                    pushMatrix();
                    fill( cfg.COLOR_NEIGHBOR_CONNECTION );
                    stroke( cfg.COLOR_NEIGHBOR_CONNECTION );
                    line( pPos.x, pPos.y, nPos.x, nPos.y );
                    popMatrix();

                }
            }

        }

    }

}


class NeighborNode extends Node{

    private ArrayList<NeighborNode> edges;

    NeighborNode( int x, int y, int lX, int lY, int num ){

        super( x, y, lX, lY, num );

        this.edges = new ArrayList<NeighborNode>();

    }

    ArrayList<NeighborNode> getEdges(){

        return new ArrayList<NeighborNode>( this.edges );

    }

    ArrayList<NeighborNode> getDistinctEdges(){

        ArrayList<NeighborNode> resultList = new ArrayList<NeighborNode>();
        ArrayList<NeighborNode> edges = this.getEdges();
        Set<NeighborNode> hashSet = new HashSet<NeighborNode>( edges );

        for( NeighborNode n : hashSet ){

            resultList.add( n );

        }

        return resultList;

    }

    void drawEdges(){

        ArrayList<NeighborNode> distinctEdges = this.getDistinctEdges();

        for( NeighborNode e : distinctEdges ){

            fill( cfg.COLOR_NEIGHBOR_EDGE );
            stroke( cfg.COLOR_NEIGHBOR_EDGE );
            line( this.x, this.y, e.getX(), e.getY() );

        }

    }

}
