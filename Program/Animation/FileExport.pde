class FileExport{

    String rootPath;

    String vectorField;
    String objectiveFunction;
    String swarm;
    String neighborhood;

    FileParser fileParser;


    //---------------- INITIALISATION

    FileExport( String path ){

        this.rootPath = path;
        this.fileParser = new FileParser();
        this.initSettingsFile();

        //println("RESULTS: " + rootPath);

    }

    void initSettingsFile(){
        
        PrintWriter output = createWriter( this.rootPath + File.separator + "Settings.txt");

        int [] flowFieldList = new int [ cfg.ANALYSIS_FLOWFIELD_LIST.size() ];
        for( int i = 0; i < cfg.ANALYSIS_FLOWFIELD_LIST.size(); i++ ){
            flowFieldList[ i ] = (int) cfg.ANALYSIS_FLOWFIELD_LIST.get( i );
        }

        output.println("SETTINGS");
        output.println("SW:                             " + this.stringListToString( cfg.ANALYSIS_SWARM_LIST ) );
        output.println("VF:                             " + this.intListToString( cfg.ANALYSIS_FLOWFIELD_LIST ) );
        output.println("OF:                             " + this.intListToString( cfg.ANALYSIS_VALUEFIELD_LIST ) );
        output.println("NH:                             " + this.intListToString( cfg.ANALYSIS_NEIGHBORHOOD_NUM ) );
        output.println("NHTITLE:                        " + this.stringListToString( cfg.ANALYSIS_NEIGHBORHOOD_LIST ) );

        output.println("");
        output.println("SIMULATIONRUNS:                 " + cfg.ANALYSIS_RUNS );
        output.println("ITERATIONS:                     " + cfg.ANALYSIS_ITERATION );
        output.println("SUBITERATIONS:                  " + cfg.SIMULATION_SUBITERATIONS );
        output.println("USED SWARMS:                    " + this.getSwarmList() );
        output.println("USED VECTOR FIELDS:             " + this.getFlowFieldList() );
        output.println("USED OBJECTIVE FUNCTIONS:       " + this.getValueFieldList() );
        output.println("USED NEIGHBORHOODS:             " + this.getNeighborhoodList() );
        output.println("SWARM SIZE:                     " + cfg.SIM_SWARM_SIZE );

        output.println("");
        output.println("MINIMUM X:                      " + cfg.SIMULATION_MIN_X );
        output.println("MAXIMUM X:                      " + cfg.SIMULATION_MAX_X );
        output.println("MINIMUM Y:                      " + cfg.SIMULATION_MIN_Y );
        output.println("MAXIMUM Y:                      " + cfg.SIMULATION_MAX_Y );
        output.println("PSO X                           " + cfg.PSO_X );
        output.println("PSO Y                           " + cfg.PSO_Y );
        output.println("PSO WEIGHT:                     " + cfg.PSO_WEIGHT );
        output.println("PSO ASYNCHRONOUS:               " + cfg.SIM_USE_PSO_ASYNCHRONOUS );

        output.println("");
        output.println("PARTICLE MAXIMUM VELOCITY:      " + cfg.PARTICLE_VELOCITY_MAX );
        output.println("PARTICLE MAXIMUM BATTERY:       " + cfg.PARTICLE_BATTERY );
        output.println("PARTICLE START POSITION:        " + cfg.PARTICLE_START_POSITION_TYPES[ cfg.PARTICLE_START_POSITION ] );
        output.println("PARTICLE USE ENERGY:            " + cfg.SIM_USE_ENERGY );

        output.println("");
        output.println("FAILURES FOR ACTIVATE LASER:    " + cfg.PARTICLE_FAILURES );
        output.println("FAILURES FOR DEACTIVATE LASER:  " + cfg.PARTICLE_LASER_FAILURES );

        output.println("");
        output.println("PARTICLE COMMUNICATION RADIUS:  " + cfg.PARTICLE_COMMUNICATION_RADIUS );
        output.println("PARTICLE RADIUS:                " + cfg.PARTICLE_SIZE_COORDINATE );
        output.println("PARTICLE LASER RADIUS           " + cfg.PARTICLE_LASER_RADIUS );

        output.println("");
        output.println("PARTICLE COLLISION:             " + cfg.SIM_USE_COLLISION );
        output.println("PARTICLE REPULSTION             " + cfg.PARTICLE_REPULSION_COORDINATE );

        output.println("");
        output.println("PPSO MINIMUM VELOCITY           " + cfg.PARTICLE_MODIFICATED_MINSPEED );

        output.println("");
        output.println("ZPSO MAX DEGREE:                " + cfg.SIM_ZPSO_MAX_DEGREE );

        output.println("");
        output.println("FLOW MAXIMUM VELOCITY:          " + cfg.PARTICLE_FLOW_MAX );

        output.flush();
        output.close();

    }

    //------------------------------ SPECIFIC FUNCTIONS


    String stringListToString( ArrayList<String> stringArray ){

        String s = "[";

        for( String singleEntry : stringArray ){

            s += singleEntry + ",";

        }

        s = s.substring( 0, s.length() - 1 );

        s += "]";

        return s;

    }

    String intListToString( ArrayList<Integer> intArray ){

        String s = "[";

        for( Integer num : intArray ){

            s += Integer.toString( num ) + ",";

        }

        s = s.substring( 0, s.length() - 1 );

        s += "]";

        return s;

    }

    void setParameters( int vfNum, int ofNum, String sw, int nh ){

        this.vectorField = "VF" + vfNum;
        this.objectiveFunction = "OF" + ofNum;
        this.swarm = sw;
        this.neighborhood = "NH"+ nh;

    }

    void writeLine( String inputLine, String fileName ){

        String path = "";

        path += this.rootPath + File.separator + "Data" + File.separator + this.swarm;
        path += File.separator + this.swarm + "_" + this.vectorField + this.objectiveFunction + this.neighborhood;
        path += "_" + fileName + ".txt";

        this.fileParser.write( inputLine, path );

    }

    ArrayList<String> readFile( String path ){

        return this.fileParser.read( path );

    }

    //------------------------------ HELPER

    String getNeighborhoodList(){

        String list = "{";

        for( String n : cfg.ANALYSIS_NEIGHBORHOOD_LIST ){

            list += n + ", ";

        }

        list = list.substring( 0, list.length() - 2 ) + "}";

        return list;

    }

    String getSwarmList(){

        String list = "{";

        for( String swarm : cfg.ANALYSIS_SWARM_LIST ){

            list += swarm + ", ";

        }

        list = list.substring( 0, list.length() - 2 ) + "}";

        return list;

    }

    String getFlowFieldList(){

        String list = "{";

        for( Integer i : cfg.ANALYSIS_FLOWFIELD_LIST ){

            list += cfg.EXPORT_FLOWFIELD_LIST[ i ] + ", ";

        }

        list = list.substring( 0, list.length() - 2 ) + "}";

        return list;

    }

    String getValueFieldList(){

        String list = "{";

        for( int i : cfg.ANALYSIS_VALUEFIELD_LIST ){

            list += cfg.EXPORT_VALUEFUNCTION_LIST[ i ] + ", ";

        }

        list = list.substring( 0, list.length() - 2 ) + "}";

        return list;

    }

    void createDirectory( String path ){

        File directory = new File( path );

        boolean existing = directory.exists();
        boolean created = directory.mkdirs();

        if( !created && !existing ){

            println( "[FAILED] Creating directory: " + path );

        }

    }


}
