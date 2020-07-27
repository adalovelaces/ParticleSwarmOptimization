class Analysis {

    FileExport exportFile;
    String exportPath;
    long timeStart;
    String date;

    String swarmName;
    String nhName;
    int neighborhoodNum;


    Analysis( String []args){

        this.initSettings( args );
        this.init();

    }

    void init(){

        this.exportFile = new FileExport( this.exportPath );
        this.timeStart = System.currentTimeMillis();
        this.neighborhoodNum = 0;
        this.swarmName = "";

    }

    void initSettings( String[] args ){

        this.exportPath = args[ 1 ];

        this.nhName = args[ 4 ];

        cfg.ANALYSIS_RUNS = int( args[ 2 ] );
        cfg.ANALYSIS_ITERATION = int( args[ 3 ] );
        cfg.ANALYSIS_NEIGHBORHOOD_LIST.add( args[ 4 ] );

        String[] splitted = args[ 4 ].split("-");
        String nh = splitted[0];
        int num =cfg.ANALYSIS_NH_TITLE.indexOf( nh ) * 10;
        String param = splitted[1] + "-" + splitted[2];
        num += cfg.ANALYSIS_NH_PARAM.indexOf( param );


        cfg.ANALYSIS_NEIGHBORHOOD_NUM.add( num );

        cfg.ANALYSIS_SWARM_LIST.add( "PPSO" );
        cfg.ANALYSIS_SWARM_LIST.add( "ZPSO" );
        cfg.ANALYSIS_VALUEFIELD_LIST.add( 1 );
        cfg.ANALYSIS_VALUEFIELD_LIST.add( 2 );
        cfg.ANALYSIS_VALUEFIELD_LIST.add( 3 );
        cfg.ANALYSIS_FLOWFIELD_LIST.add( 1 );
        //cfg.ANALYSIS_FLOWFIELD_LIST.add( 2 );
        cfg.ANALYSIS_FLOWFIELD_LIST.add( 4 );
        cfg.ANALYSIS_FLOWFIELD_LIST.add( 6 );
        cfg.ANALYSIS_FLOWFIELD_LIST.add( 10 );
        cfg.ANALYSIS_FLOWFIELD_LIST.add( 12 );

    }

    void initPath( String nh ){

        String nhText = "";
        if( !nh.equals( "" ) ){
            String [] nhList = nh.split( "-" );
            nhText = "-" + nhList[0];
        }

        String filePath = this.getClass().getClassLoader().getResource("").getPath();
        File file = new File( filePath );
        String absoluteFilePath = file.getAbsolutePath();
        String path = Paths.get( absoluteFilePath ).getParent().getParent().getParent().toString();

        this.exportPath = path + cfg.EXPORT_PATH + this.date + nhText;

    }

    void run(){

        //println("Export Path: " + this.exportPath );
        //println("Start simulation " + this.nhName + "...");

        for( int flowFieldId = 0;  flowFieldId < cfg.ANALYSIS_FLOWFIELD_LIST.size(); flowFieldId++ ){

            for( int valueFieldId = 0; valueFieldId < cfg.ANALYSIS_VALUEFIELD_LIST.size(); valueFieldId++ ){

                for( int swarmId = 0; swarmId < cfg.ANALYSIS_SWARM_LIST.size(); swarmId++ ){

                    for( int neighborhoodId = 0; neighborhoodId < cfg.ANALYSIS_NEIGHBORHOOD_LIST.size(); neighborhoodId++ ){

                        cfg.SIM_FLOWFIELD_NUM = cfg.ANALYSIS_FLOWFIELD_LIST.get( flowFieldId );
                        cfg.SIM_VALUEFIELD_NUM = cfg.ANALYSIS_VALUEFIELD_LIST.get( valueFieldId );
                        cfg.PARTICLE_NH_TITLE = cfg.ANALYSIS_NEIGHBORHOOD_LIST.get( neighborhoodId );

                        int neighborhoodNum = cfg.ANALYSIS_NEIGHBORHOOD_NUM.get( neighborhoodId );

                        this.swarmName = cfg.ANALYSIS_SWARM_LIST.get( swarmId );

                        this.exportFile.setParameters( cfg.SIM_FLOWFIELD_NUM, cfg.SIM_VALUEFIELD_NUM, swarmName, neighborhoodNum);

                        this.setActiveSwarm( swarmName );

                        this.simulateSwarm( flowFieldId, valueFieldId, swarmId, neighborhoodNum, neighborhoodId );

                    }
                }
            }
        }

        stop();
        exit();

    }

    void simulateSwarm( int vf, int of, int sw, int n, int nh ){

        float [] gBestList = new float[ cfg.ANALYSIS_ITERATION ];
        float [] angleList = new float[ cfg.ANALYSIS_ITERATION ];
        float [] sumEnergyList = new float[ cfg.ANALYSIS_ITERATION ];
        float [] avgEnergyList = new float[ cfg.ANALYSIS_ITERATION ];
        float [] avgNeighborList = new float[ cfg.ANALYSIS_ITERATION ];
        float [] distListCenter = new float[ cfg.ANALYSIS_ITERATION ];
        float [] distListNeighbor = new float[ cfg.ANALYSIS_ITERATION ];
        float [] windFlowerList = new float[ cfg.ANALYSIS_ITERATION ];
        float [][] usedEnergyList = new float[ cfg.SIM_SWARM_SIZE ][ cfg.ANALYSIS_ITERATION ];
        float [][] leftEnergyList = new float[ cfg.SIM_SWARM_SIZE ][ cfg.ANALYSIS_ITERATION ];
        String [][] neighborList = new String[ cfg.SIM_SWARM_SIZE ][ cfg.ANALYSIS_ITERATION ];
        float [][] distListOpt = new float[ cfg.SIM_SWARM_SIZE ][ cfg.ANALYSIS_ITERATION ];
        float [][] pBestResultList = new float[ cfg.SIM_SWARM_SIZE ][ cfg.ANALYSIS_ITERATION ];
        float [][] pBestUpdateList = new float[ cfg.SIM_SWARM_SIZE ][ cfg.ANALYSIS_ITERATION ];
        float [][] orientationListOpt = new float[ cfg.SIM_SWARM_SIZE ][ cfg.ANALYSIS_ITERATION ];
        float [][] orientationListWind = new float[ cfg.SIM_SWARM_SIZE ][ cfg.ANALYSIS_ITERATION ];

        for( int simNum = 0; simNum < cfg.ANALYSIS_RUNS; simNum++ ){

            cfg.SIM_NUM = simNum;
            cfg.SIM_FLOWFIELD_NUM = cfg.ANALYSIS_FLOWFIELD_LIST.get( vf );
            cfg.SIM_VALUEFIELD_NUM = cfg.ANALYSIS_VALUEFIELD_LIST.get( of );
            int index = int(n/10);
            cfg.PARTICLE_NH_TITLE = cfg.ANALYSIS_NH_TITLE.get( index );

            String maxVF = str( cfg.ANALYSIS_FLOWFIELD_LIST.size() );
            String maxOF = str( cfg.ANALYSIS_VALUEFIELD_LIST.size() );
            println("NH:" + cfg.ANALYSIS_NEIGHBORHOOD_LIST.get(nh) +  " OF:" + str(of+1) + "/" + maxOF + " VF:" + str(vf+1) + "/" + maxVF + " SIM:" + str(simNum+1) + "/" + str(cfg.ANALYSIS_RUNS ) );

            simulation = new Simulation();

            for( int iterNum = 0; iterNum < cfg.ANALYSIS_ITERATION * cfg.SIMULATION_SUBITERATIONS; iterNum++ ){

                simulation.run();

            }

            gBestList = simulation.getGBestResultList();
            angleList = simulation.getAngleResultList();
            sumEnergyList = simulation.getSumEnergyResultList();
            avgEnergyList = simulation.getAvgEnergyResultList();
            avgNeighborList = simulation.getAvgNeighborResultList();
            distListCenter = simulation.getDistListCenter();
            distListNeighbor = simulation.getDistListNeighbor();
            windFlowerList = simulation.getWindFlowerList();

            String gBestListString = this.getFloatListToString( gBestList );
            String angleListString = this.getFloatListToString( angleList );
            String sumEnergyListString = this.getFloatListToString( sumEnergyList );
            String avgEnergyListString = this.getFloatListToString( avgEnergyList );
            String avgNeighborListString = this.getFloatListToString( avgNeighborList );
            String distListCenterString = this.getFloatListToString( distListCenter );
            String distListNeighborString = this.getFloatListToString( distListNeighbor );
            String windFlowerListString = this.getFloatListToString( windFlowerList );

            exportFile.writeLine( gBestListString, "GBest" );
            exportFile.writeLine( angleListString, "Angle" );
            exportFile.writeLine( sumEnergyListString, "SumEnergy" );
            exportFile.writeLine( avgEnergyListString, "AvgEnergy" );
            exportFile.writeLine( avgNeighborListString, "AvgNeighbor" );
            exportFile.writeLine( distListCenterString, "DistCenter" );
            exportFile.writeLine( distListNeighborString, "DistInter" );
            exportFile.writeLine( windFlowerListString, "WindFlower" );

            for( Particle p : simulation.getParticles() ){

                int num = p.getNum();

                usedEnergyList[ num ] = simulation.getUsedEnergyResultList( num );
                leftEnergyList[ num ] = simulation.getLeftEnergyResultList( num );
                neighborList[ num ] = simulation.getNeighborResultList( num );
                distListOpt[ num ] = simulation.getDistListOpt( num );
                pBestResultList[ num ] = simulation.getPBestResultList( num );
                pBestUpdateList[ num ] = simulation.getPBestUpdateList( num );
                orientationListOpt[ num ] = simulation.getOrientationListOpt( num );
                orientationListWind[ num ] = simulation.getOrientationListWind( num );

                String usedEnergyListString = this.getFloatListToString( usedEnergyList[ num ] );
                String leftEnergyListString = this.getFloatListToString( leftEnergyList[ num ] );
                String neighborListString = this.getStringListToString( neighborList[ num ] );
                String distListOptString = this.getFloatListToString( distListOpt[ num ] );
                String pBestResultListString = this.getFloatListToString( pBestResultList[ num ] );
                String pBestUpdateListString = this.getFloatListToString( pBestUpdateList[ num ] );
                String orientationListOptString = this.getFloatListToString( orientationListOpt[ num ] );
                String orientationListWindString = this.getFloatListToString( orientationListWind[ num ] );

                exportFile.writeLine( usedEnergyListString, "P" + Integer.toString( num ) + "_UsedEnergy" );
                exportFile.writeLine( leftEnergyListString, "P" + Integer.toString( num ) + "_LeftEnergy" );
                exportFile.writeLine( neighborListString, "P" + Integer.toString( num ) + "_Neighbors" );
                exportFile.writeLine( distListOptString, "P" + Integer.toString( num ) + "_DistanceOpt" );
                exportFile.writeLine( pBestResultListString, "P" + Integer.toString( num ) + "_PBestValue" );
                exportFile.writeLine( pBestUpdateListString, "P" + Integer.toString( num ) + "_PBestUpdate" );
                exportFile.writeLine( orientationListOptString, "P" + Integer.toString( num ) + "_OrientationOpt" );
                exportFile.writeLine( orientationListWindString, "P" + Integer.toString( num ) + "_OrientationWind" );

            }


            this.showProgress( vf, of, sw, n, simNum );
            //print("Simulation " + simNum + ": Exporting finished");

        }

    }

    //===================================================//
    //                PROGRESS VISUALIZATION             //
    //===================================================//

    void showProgress( int vf, int of, int sw, int n, int sm ){

        int maxVF = cfg.ANALYSIS_FLOWFIELD_LIST.size();
        int maxOF = cfg.ANALYSIS_VALUEFIELD_LIST.size();
        int maxSW = cfg.ANALYSIS_SWARM_LIST.size();
        int maxN = cfg.ANALYSIS_NEIGHBORHOOD_LIST.size();
        int maxRUNS = cfg.ANALYSIS_RUNS;

        int maxSim = maxVF * maxOF * maxSW * maxN * maxRUNS;

        int sim         = sm + 1;
        int neighbor    =  n * maxRUNS + sim;
        int swarm       = sw * maxRUNS * maxN + neighbor;
        int function    = of * maxRUNS * maxN * maxSW + swarm;
        int vectorfield = vf * maxRUNS * maxN * maxSW * maxOF + function;

        int currentSim = vectorfield;

        String percentageCompleted = this.getPercentage( currentSim, maxSim );
        String runningTime = this.getRunningTime();
        String remainingTime = this.getTimePrediction( currentSim, maxSim );

        if( cfg.ANALYSIS_SHOW_PROGRESS ) println( "Completed: " + percentageCompleted + "%    Running time: " + runningTime + "   Remaining time: " + remainingTime );

    }

    String getPercentage( int currentSim, int maxSim ){

        float percentage = ( (float) currentSim / (float) maxSim ) * 100;

        String percentageString = String.format( "%.2f", percentage );

        return percentageString;

    }

    String getRunningTime(){

        long tNow = System.currentTimeMillis();
        long tDelta = tNow - timeStart;

        long remainingSeconds = TimeUnit.MILLISECONDS.toSeconds( tDelta );

        long hours = remainingSeconds / 3600;
        long minutes = ( remainingSeconds % 3600 ) / 60;
        long seconds = remainingSeconds % 60;

        String runningTimeString = String.format("%02d:%02d:%02d", hours, minutes, seconds);

        return runningTimeString;

    }

    String getTimePrediction( int currentSim, int maxSim ){

        long tNow = System.currentTimeMillis();
        long tDelta = tNow - timeStart;

        long timePerSim = tDelta / currentSim;
        long timeRemaining = timePerSim * ( maxSim - currentSim );

        long remainingSeconds = TimeUnit.MILLISECONDS.toSeconds( timeRemaining );

        long hours = remainingSeconds / 3600;
        long minutes = ( remainingSeconds % 3600 ) / 60;
        long seconds = remainingSeconds % 60;

        String remainingTimeString = String.format("%02d:%02d:%02d", hours, minutes, seconds);

        return remainingTimeString;

    }

    //===================================================//
    //                      EXPORT                       //
    //===================================================//

    String getDateText(){

        DateFormat dateFormat = new SimpleDateFormat("MMddHHmm");
        Date dateObject = new Date();
        String dateString = dateFormat.format( dateObject );

        return dateString;

    }

    //===================================================//
    //                  HELPER EXPORT                    //
    //===================================================//

    String getFloatListToString( float[] list ){

        String result = "";

        if( list.length == 0 )  return "";

        for( int i = 0; i < list.length; i++ ){

            result += list[i];
            result += ",";

        }

        result = result.substring( 0, result.length() - 1 );
        result += "";
        return result;

    }

    String getStringListToString( String[] list ){

        String result = "";

        if( list.length == 0 )  return "";

        for( int i = 0; i < list.length; i++ ){

            result += list[i];
            result += ",";

        }

        result = result.substring( 0, result.length() - 1 );
        result += "";
        return result;

    }

    //===================================================//
    //                  HELPER SWARMS                    //
    //===================================================//

    void setActiveSwarm( String swarm ){

        this.resetActiveSwarm();

        if( swarm.equals( "PSO" ) )         cfg.INIT_PSO       = true;
        if( swarm.equals( "ZPSO" ) )        cfg.INIT_ZPSO      = true;
        if( swarm.equals( "PPSO" ) )        cfg.INIT_PPSO      = true;

    }

    String getActiveSwarm(){

        if( cfg.INIT_PSO )       return "PSO";
        if( cfg.INIT_ZPSO )      return "ZPSO";
        if( cfg.INIT_PPSO )      return "PPSO";
        return "";

    }

    void resetActiveSwarm(){

        cfg.INIT_PSO       = false;
        cfg.INIT_ZPSO      = false;
        cfg.INIT_PPSO      = false;

    }

}
