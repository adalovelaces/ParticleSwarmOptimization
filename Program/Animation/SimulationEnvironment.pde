class Environment{

    VectorCoord minValue;
    VectorCoord maxValue;

    VectorScreen environmentSize;

    VectorScreen simulationStart;
    VectorScreen simulationSize;
    VectorScreen gridSize;

    color environmentColor;


    Environment(){

        this.environmentSize = new VectorScreen( 10, 10 );

        int posX = cfg.SIMULATION_START_X;
        int posY = 10; //[TODO] should be cfg.SIMULATION_START_Y //=20
        this.simulationStart = new VectorScreen( posX, posY );

        int sizeX = cfg.SIMULATION_SIZE_X;
        int sizeY = cfg.SIMULATION_SIZE_Y;
        this.simulationSize = new VectorScreen( sizeX, sizeY );

        this.environmentColor = cfg.COLOR_ENVIRONMENT;

        int gridCell = cfg.SIMULATION_GRID_SIZE / 2;
        this.gridSize = new VectorScreen( gridCell, gridCell );

        this.minValue = new VectorCoord( cfg.SIMULATION_MIN_X, cfg.SIMULATION_MIN_Y );
        this.maxValue = new VectorCoord( cfg.SIMULATION_MAX_X, cfg.SIMULATION_MAX_Y );

    }

    void setColor(color c){

        this.environmentColor = c;

    }

    void draw(){

        drawOutside();
        drawBorder();
        drawAxes();

    }

    void drawOutside(){

        int marginX = this.environmentSize.x;
        int marginY = this.environmentSize.y;

        int startX = this.simulationStart.x;
        int startY = 20;

        int sizeX = this.simulationSize.x;
        int sizeY = this.simulationSize.y;

        int enviSizeX = sizeX + marginX * 2;
        int enviSizeY = sizeY + marginY * 2;

        fill( this.environmentColor );
        stroke( this.environmentColor );

        /*
            (x1,y1) ----------------- (x2,y1)
                |                        |
                |                        |
                |                        |
            (x1,y2) ----------------- (x2, y2)

        */

        int wLeft = 50;
        int wRight = 15;
        int hTop = 20;
        int hBottom = 50;

        int xLength = 950;
        int yLength = 920;

        int x1 = 0;
        int y1 = 0;

        int x2 = xLength;
        int y2 = yLength;

        // Left rectangle
        rect( x1, y1, x1 + wLeft, y1 + yLength );

        // Bottom rectangle
        rect( x1, y2, x1 + xLength, y2 + hBottom );

        // Top rectangle
        rect( x1, y1, x1 + xLength, y1 + hTop);

        // Right rectangle
        rect( x2, y1, x1 + wRight, y2 + hBottom );

    }

    void drawBorder(){

        /*
            (x1,y1) ----------------- (x2,y1)
                |                        |
                |                        |
                |                        |
            (x1,y2) ----------------- (x2, y2)

        */

        int x1 = this.simulationStart.x;
        int y1 = this.simulationStart.y + this.environmentSize.y;

        int x2 = this.simulationSize.x;
        int y2 = this.simulationSize.y;

        stroke( 0 );
        noFill();
        rect( x1, y1, x2, y2 );

    }

    void drawAxes(){

        PFont f = createFont( "Arial",36,true );
        float fSize = ( cfg.ENVIRONMENT_SIMULATION_SIZE_TEXT );
        textAlign( CENTER, CENTER );
        textFont( f, fSize );
        stroke( 0 );
        fill( 0 );

        String txt = "";

        // DRAW TICKS X AXE

        float minX = Math.abs(cfg.SIMULATION_MIN_X);
        float maxX = Math.abs(cfg.SIMULATION_MAX_X);

        float stepSizeX = cfg.SIMULATION_SIZE_X / (minX + maxX );

        int x = cfg.SIMULATION_START_X;
        int y = cfg.SIMULATION_START_Y + cfg.SIMULATION_SIZE_Y;

        for( float i = cfg.SIMULATION_MIN_X; i <= cfg.SIMULATION_MAX_X; i++ ){

            // Only print every 5 numbers
            if( i % 5 == 0 ){

                txt = str( (int) i );
                text( txt, x, y + cfg.ENVIRONMENT_SIMULATION_DISTANCE_TEXT * 0.8 );

            }

            // Print ticks
            line( x, y, x, y + cfg.ENVIRONMENT_SIMULATION_SIZE_STICK );

            x += stepSizeX;

        }

        // DRAW TICKS Y AXE

        float minY = Math.abs(cfg.SIMULATION_MIN_Y);
        float maxY = Math.abs(cfg.SIMULATION_MAX_Y);

        float stepSizeY = cfg.SIMULATION_SIZE_Y / ( minY + maxY );

        x = cfg.SCREEN_DIST_LEFT_X;
        y = cfg.SIMULATION_START_Y;

        //drawTicks( cfg.SIMULATION_MIN_Y, cfg.SIMULATION_MAX_Y, startX, startY, stepSizeY );
        for( float j = cfg.SIMULATION_MAX_Y; j >= cfg.SIMULATION_MIN_Y; j-- ){

            // Only print every 5 numbers
            if( j % 5 == 0 ){

                txt = str( (int) j );
                text( txt, x - cfg.ENVIRONMENT_SIMULATION_DISTANCE_TEXT, y - 5);

            }

            // Print ticks
            line( x, y, x - cfg.ENVIRONMENT_SIMULATION_SIZE_STICK, y );

            y += stepSizeY;

        }

    }

}
