class ConfigSimulation{

    //////////////////////////////////////////////// CHANGING VALUES

    private final String PATH_FOLDER                    = "";

    private boolean WINDOWS_SYSTEM                      = true;

    private boolean ANALYSIS                            = false;
    private final boolean ANALYSIS_SHOW_PROGRESS        = false;

    private int ANALYSIS_RUNS                           = 5;
    private int ANALYSIS_ITERATION                      = 150;
    private String ANALYSIS_NH                          = "GBest-R2-S20";

    private ArrayList<String> ANALYSIS_SWARM_LIST       = new ArrayList<String>();
    private ArrayList<String> ANALYSIS_NEIGHBORHOOD_LIST= new ArrayList<String>();
    private ArrayList<Integer> ANALYSIS_NEIGHBORHOOD_NUM= new ArrayList<Integer>();
    private ArrayList<Integer> ANALYSIS_VALUEFIELD_LIST = new ArrayList<Integer>();
    private ArrayList<Integer> ANALYSIS_FLOWFIELD_LIST  = new ArrayList<Integer>();

    //////////////////////////////////////////////// EDITED BY PROGRAM (ANALYSIS) OR PERSON (SIMULATION)

    private boolean SIM_SHOW_SIMULATION                 = !this.ANALYSIS;

    private int SIM_FLOWFIELD_NUM                       = 4;
    private int SIM_VALUEFIELD_NUM                      = 2;
    private int SIM_NUM                                 = 3;

    private String PARTICLE_NH_TITLE                    = "GBest";
    private float PARTICLE_COMMUNICATION_RADIUS         = 2;
    private int PARTICLE_NH_SIZE                        = 20;

    private boolean INIT_PSO                            = false;
    private boolean INIT_PPSO                           = false;
    private boolean INIT_ZPSO                           = true;

    //////////////////////////////////////////////// EDITABLE FINAL VALUES (CAN BE SET ONCE)


    private final ArrayList<String> ANALYSIS_NH_TITLE   = new ArrayList<String>( Arrays.asList( " ","GBest","Ring","Star","Neumann","Payoff","Prob","PayoffProb","PayoffSw","ProbSw","PayoffProbSw","Sub"));
    private final ArrayList<String> ANALYSIS_NH_PARAM   = new ArrayList<String>( Arrays.asList( " ","R5-S5","R5-S10","R5-S20", "R2-S5","R2-S10","R2-S20", "R30-S5","R30-S10","R30-S20"));
    private final int SIM_SWARM_SIZE                    = 20;

    // Settings for simulation
    private final boolean SIM_STORE_SVG                 = false;
    private final boolean SIM_STORE_RESULT              = true;  //[TODO] use
    private final boolean SIM_MAKE_PLOTS                = false;
    private final boolean SIM_USE_PSO_ASYNCHRONOUS      = true;
    private final boolean SIM_USE_PSO_RANDOM            = false;
    private final boolean SIM_USE_ENERGY                = true;
    private final boolean SIM_USE_COLLISION             = true;
    private final boolean SIM_USE_NEIGHBORCENTER        = true; //use neighborhood center or swarm center

    private final int SIM_ZPSO_MAX_DEGREE               = 45;

    private final float SIMULATION_MIN_X                = -15;
    private final float SIMULATION_MAX_X                = 15;
    private final float SIMULATION_RANGE_X              = Math.abs( SIMULATION_MIN_X ) + Math.abs( SIMULATION_MAX_X );
    private final float SIMULATION_MIN_Y                = -15;
    private final float SIMULATION_MAX_Y                = 15;
    private final float SIMULATION_RANGE_Y              = Math.abs( SIMULATION_MIN_Y ) + Math.abs( SIMULATION_MAX_Y );
    private final float SIMULATION_SUBITERATIONS        = 10; // [TODO]: 100 // defines number of discrete steps in one iteration

    private final int FAILURE_THRESHOLD                 = 7;

    private final float PSO_X                           = -10;
    private final float PSO_Y                           = 10;
    private final float PSO_WEIGHT                      = 0.6;
    private final float PSO_INIT                        = 1000000000;
    private final VectorCoord PSO_COEFFICIENT_A         = new VectorCoord( 1, 1 );
    private final VectorCoord PSO_COEFFICIENT_B         = new VectorCoord( 1, 1 );
    private final boolean PSO_MINIMIZING                = true;
    private final boolean PSO_MAXIMIZING                = !this.PSO_MINIMIZING;
    private final boolean PSO_USE_GLOBAL_GBEST          = false;
    private final boolean PSO_USE_NEIGHOR_GBEST         = !PSO_USE_GLOBAL_GBEST;

    private final float PARTICLE_FLOW_MAX               = 2.5;
    private final float PARTICLE_VELOCITY_MAX           = 2;
    private final float PARTICLE_FAILURES               = 10;
    private final float PARTICLE_BATTERY                = 10000000;
    private final int PARTICLE_START_POSITION           = 5; // 0 = "RightTopCorner", 1 = "LeftBottomCorner", 2 = "RightBottomCorner", 3 = "Circle", 4 = "Row", 5 = "Random"
    private final float PARTICLE_MODIFICATED_MINSPEED   = 1;
    private final int PARTICLE_LASER_FAILURES           = 5;
    private final float PARTICLE_LASER_RADIUS           = PARTICLE_VELOCITY_MAX;

    // SETTINGS FOR EXPORTING

    private final String EXPORT_PATH                    = File.separator + "Simulation" + File.separator;
    private final String [] EXPORT_VALUEFUNCTION_LIST   = { "", "Sphere", "Rosenbrock", "Ackley" };
    private final String [] EXPORT_FLOWFIELD_LIST       = { "", "Cross", "Rotation", "Sheared", "TopToBottom", "Tornado", "Bidirectional", "Random", "MultiRotation", "Vortex", "Real1", "Real2", "Real3", "Real4" };
    private final String [] EXPORT_NEIGHBORHOOD_LIST    = {"GBest2", "GBest4","GBest6", "GBest8","GBest10", "GBest12","GBest14", "GBest16","GBest18", "GBest20"};

    //GBEST: {"GBest2", "GBest4","GBest6", "GBest8","GBest10", "GBest12","GBest14", "GBest16","GBest18", "GBest20"}

    // SETTINGS FOR IMPORTING

    private final String PATH_WIND1                     = "WIND1";
    private final String PATH_WIND2                     = "WIND2";
    private final String PATH_WIND3                     = "WIND3";


    // SETTINGS FOR DISPLAYING

    private boolean SIM_SHOW_PARTICLE_BATTERY           = false;
    private boolean SIM_SHOW_PARTICLE_CONNECTIONS       = false;
    private boolean SIM_SHOW_LASER                      = false;
    private boolean SIM_SHOW_TRACE                      = false;

    private final boolean SIM_SHOW_CONTINUOUS           = true;
    private final boolean SIM_SHOW_EQUAL_STEERING       = false; //show directions all in same length or not
    private final boolean SIM_SHOW_NUMBERS              = true;
    private final boolean SIM_SHOW_DIRECTIONS           = false;
    private final boolean SIM_SHOW_INTERACTION          = false;
    private final boolean SIM_SHOW_NEIGHBOR             = true;
    private final boolean SIM_SHOW_CENTER               = false;
    private final boolean SIM_SHOW_REAL_WORLD_GRID      = false;
    private final int SIM_SHOW_DELAY                    = 2;   //from 0 (no delay) to 3 (long delay)

    //////////////////////////////////////////////// FIXED FINAL VALUES

    // SCREEN

    private final int MARGIN                            = 20;

    private final int SCREEN_RESOLUTION                 = 30;

    private final int SCREEN_DIST_LEFT_X                = 50;
    private final int SCREEN_DIST_RIGHT_X               = this.MARGIN;
    private final int SCREEN_DIST_TOP_Y                 = this.MARGIN;
    private final int SCREEN_DIST_BOTTOM_Y              = 50;

    // SIMULATION

    private final int SIMULATION_RESOLUTION             = 15;

    private final int SIMULATION_SIZE_X                 = 900;
    private final int SIMULATION_SIZE_Y                 = 900;

    private final int SIMULATION_GRID_SIZE              = (int) Math.round( SIMULATION_SIZE_X / ( Math.abs( SIMULATION_MIN_X ) + Math.abs( SIMULATION_MAX_X ) ) );

    private final int SIMULATION_AREA_SIZE_X            = this.SCREEN_DIST_LEFT_X + this.SCREEN_DIST_RIGHT_X + this.SIMULATION_SIZE_X;

    private final int SIMULATION_START_X                = this.SCREEN_DIST_LEFT_X;
    private final int SIMULATION_START_Y                = this.SCREEN_DIST_TOP_Y;

    private final int SIMULATION_ROWS                   = this.SIMULATION_SIZE_X / this.SIMULATION_GRID_SIZE;
    private final int SIMULATION_COLUMNS                = this.SIMULATION_SIZE_Y / this.SIMULATION_GRID_SIZE;

    // REAL WORLD FLOW VALUES

    private final int FLOW_CELLS_X_NUM = 20;
    private final int FLOW_CELLS_Y_NUM = 20;

    private final float FLOW_CELLS_X_SIZE = SIMULATION_RANGE_X / FLOW_CELLS_X_NUM;
    private final float FLOW_CELLS_Y_SIZE = SIMULATION_RANGE_Y / FLOW_CELLS_Y_NUM;

    // ENVIRONMENT

    private final int ENVIRONMENT_SIMULATION_SIZE_STICK = 5;
    private final int ENVIRONMENT_SIMULATION_SIZE_TEXT  = 25;
    private final int ENVIRONMENT_SIMULATION_DISTANCE_TEXT = ENVIRONMENT_SIMULATION_SIZE_STICK + ENVIRONMENT_SIMULATION_SIZE_TEXT;

    // BUTTON

    private final int BUTTON_AREA_SIZE_X                = 220;
    private final int BUTTON_SIZE_X                     = 170;
    private final int BUTTON_SIZE_Y                     = 50;
    private final int BUTTON_SIZE_TEXT                  = 1;

    private final int BUTTON_AREA_X                     = this.SIMULATION_AREA_SIZE_X;

    // [TODO] CHECK USAGE
    private final int BUTTON_ITERATION_NUM              = 1;
    private final int BUTTON_ACTION_NUM                 = 2;
    private final int BUTTON_SWARM_NUM                  = 5;
    private final int BUTTON_VECTROFIELDS_NUM           = 9;

    private final int BUTTON_ITERATION_Y                = this.SCREEN_DIST_TOP_Y;
    private final int BUTTON_ACTION_Y                   = this.BUTTON_ITERATION_Y + this.BUTTON_ITERATION_NUM * ( this.BUTTON_SIZE_Y + this.MARGIN ) / 2 + this.MARGIN;
    private final int BUTTON_SWARM_Y                    = this.BUTTON_ACTION_Y + this.BUTTON_ACTION_NUM * ( this.BUTTON_SIZE_Y + this.MARGIN ) / 2;
    private final int BUTTON_VECTORFIELDS_Y             = this.BUTTON_SWARM_Y + this.BUTTON_SWARM_NUM * ( this.BUTTON_SIZE_Y + this.MARGIN ) / 2 + this.MARGIN;
    private final int BUTTON_NEIGHBOR_Y                 = this.BUTTON_VECTORFIELDS_Y + this.BUTTON_VECTROFIELDS_NUM * ( this.BUTTON_SIZE_Y + this.MARGIN ) / 2 + this.MARGIN;
    private final int BUTTON_NEIGHBOR_SCALE_X           = this.BUTTON_SIZE_X;
    private final int BUTTON_NEIGHBOR_SCALE_Y           = this.BUTTON_SIZE_Y / 2;

    private final String [] BUTTON_FLOWFIELD_LIST       = { "", "Cross", "Rotation", "Sheared", "TopToBottom", "Tornado", "Bidirect", "Random", "MultiRotation", "Vortex", "Real1", "Real2", "Real2", "Real4" };


    // NEIGHBORHOOD

    private final int NEIGHBOR_AREA_SIZE_X              = 400 + this.MARGIN;
    private final int NEIGHBOR_AREA_X                   = this.SIMULATION_AREA_SIZE_X + this.BUTTON_AREA_SIZE_X;
    private final int NEIGHBOR_AREA_Y                   = this.SCREEN_DIST_TOP_Y + this.MARGIN * 2;
    private final int NEIGHBOR_SIZE_X                   = 400;
    private final int NEIGHBOR_SIZE_Y                   = 400;
    private final float NEIGHBOR_CENTER_RADIUS          = this.SCREEN_RESOLUTION * 1;

    // NODE

    private final float NODE_RADIUS                     = this.SCREEN_RESOLUTION * 0.2;
    private final float NODE_TEXT_SIZE                  = 1;

    // INTERACTION

    private final int INTERACTION_AREA_SIZE_X           = this.NEIGHBOR_AREA_SIZE_X;
    private final int INTERACTION_AREA_X                = this.NEIGHBOR_AREA_X;
    private final int INTERACTION_AREA_Y                = this.NEIGHBOR_AREA_Y + this.NEIGHBOR_SIZE_Y + this.MARGIN * 2;
    private final int INTERACTION_SIZE_X                = this.NEIGHBOR_SIZE_X;
    private final int INTERACTION_SIZE_Y                = this.NEIGHBOR_SIZE_Y;

    // COLORMAP

    private final float COLORMAP_SIZE_X                 = this.SIMULATION_GRID_SIZE;
    private final float COLORMAP_SIZE_Y                 = this.SIMULATION_GRID_SIZE;

    // PARTICLE

    private final float PARTICLE_SIZE_COORDINATE        = 0.7;
    private final float PARTICLE_REPULSION_COORDINATE   = 0.15;
    private final float PARTICLE_SIZE                   = this.SIMULATION_RESOLUTION * this.PARTICLE_SIZE_COORDINATE;
    private final int PARTICLE_DISPLAY_TRACKLISTSIZE    = 70;
    private final float PARTICLE_DISPLAY_TRACKPOINTSIZE = this.PARTICLE_SIZE_COORDINATE / 4 * this.SIMULATION_RESOLUTION;
    private final String [] PARTICLE_START_POSITION_TYPES = { "RightTopCorner", "LeftBottomCorner", "RightBottomCorner", "Circle", "Row", "Random" };

    // PSO

    private final float PSO_MINIMUM_SIZE                = PARTICLE_SIZE * 1.7;

    // SWARMS

    private final float SWARM_CENTER_RADIUS             = this.SCREEN_RESOLUTION * 0.9;
    private final int SWARM_PSO_SIZE                    = 20;
    private final int SWARM_MPSO_SIZE                   = 20;
    private final int SWARM_SVFPSO_SIZE                 = 20;
    private final int SWARM_ZPSO_SIZE                   = 20;
    private final int SWARM_PPSO_SIZE                   = 20;

    private final int NEIGHBORHOOD_PSO                  = 5;
    private final int NEIGHBORHOOD_MPSO                 = 6;
    private final int NEIGHBORHOOD_SVFPSO               = 4;
    private final int NEIGHBORHOOD_ZPSO                 = 5;
    private final int NEIGHBORHOOD_PPSO                 = 5;

    // COLORS

    private final color COLOR_BACKGROUND                = color( 255, 255, 255 );
    private final color COLOR_ENVIRONMENT               = color( 220, 222, 226 );
    private final color COLOR_BUTTON_TEXT               = color( 255, 255, 255 );
    private final color COLOR_BUTTON_STANDARD           = color( 35, 55, 86 );
    private final color COLOR_BUTTON_HIGHLIGHT          = color( 75, 104, 150 );
    private final color COLOR_LABEL_TEXT                = color( 0, 0, 0 );
    private final color COLOR_NEIGHBOR_CENTER           = color( 116, 148, 168 );
    private final color COLOR_NEIGHBOR_EDGE             = color( 0, 0, 0 );
    private final color COLOR_NEIGHBOR_NODE             = color( 0, 0, 0 );
    private final color COLOR_NEIGHBOR_CONNECTION       = color( 121, 125, 135 );
    private final color COLOR_INTERACTION_EDGE          = color( 66, 134, 244 );
    private final color COLOR_COLORMAP_START            = color( 247, 250, 255 );
    private final color COLOR_COLORMAP_END              = color( 50, 70, 96 );
    private final color COLOR_PARTICLE_FLOWVECTOR       = color( 255, 255, 255 );
    private final color COLOR_PARTICLE_STEERINGVECTOR   = color( 211, 196, 101 );
    private final color COLOR_PARTICLE_PSOVECTOR        = color( 45, 44, 44 );
    private final color COLOR_PARTICLE_POSITIONLIST     = color( 196, 122, 98 );
    private final color COLOR_SWARM_CENTER              = color( 116, 148, 168 );
    private final color COLOR_SWARM_PSO                 = color( 211, 196, 107 );
    private final color COLOR_SWARM_MPSO                = color( 143, 26, 80 );
    private final color COLOR_SWARM_SVFPSO              = color( 136, 183, 82 );
    private final color COLOR_SWARM_ZPSO                = color( 121, 166, 212 );
    private final color COLOR_SWARM_PPSO                = color( 204, 85, 101 );
    private final color COLOR_MINIMUM                   = color( 186, 192, 198 );
    private final color COLOR_FLOWFIELD_GRIDLINES       = color( 161, 166, 179 );
    private color COLOR_FLOWFIELD_VECTOR                = color( 121, 125, 135 );

}
