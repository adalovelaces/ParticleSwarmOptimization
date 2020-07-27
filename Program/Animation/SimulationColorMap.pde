class ColorMap extends GraphicObject{

    private VectorCoord [][] grid;
    private int cols;
    private int rows;
    private VectorScreen gridSize;
    private float maxValue;
    private float minValue;
    private color startColor;
    private color endColor;

    /*------------------------------------------------------------*/
    /*                           CONSTRUCTOR                      */
    /*------------------------------------------------------------*/

    ColorMap( FlowField flowField, String _name, VectorScreen _pos, VectorScreen _size ){

        super( _name, _pos, _size );

        this.cols = cfg.SIMULATION_COLUMNS;
        this.rows = cfg.SIMULATION_ROWS;

        int gridCell = cfg.SIMULATION_GRID_SIZE;//cfg.resolution / 2;
        this.gridSize = new VectorScreen( gridCell, gridCell );

        this.startColor = cfg.COLOR_COLORMAP_START;
        this.endColor = cfg.COLOR_COLORMAP_END;

        this.minValue = flowField.getMinLength();
        this.maxValue = flowField.getMaxLength();

        this.grid =  new VectorCoord [ this.cols ][ this.rows ];

        this.init();

    }

    /*------------------------------------------------------------*/
    /*                           INITIALISATION                   */
    /*------------------------------------------------------------*/

    void init(){

        for( int col = 0; col < cfg.SIMULATION_COLUMNS; col++ ){
            for( int row = 0; row < cfg.SIMULATION_ROWS; row++ ){

                this.grid[ col ][ row ] = new VectorCoord( 0, 0 );

                /* Uncomment to show whole color map

                VectorGrid gridPos = new VectorGrid( col, row );
                VectorCoord coordPos = gridPos.transToCoordinate();

                VectorCoord flow = flowField.getFlow( coordPos );

                float length = flow.mag();
                field[ col ][ row ] = length;

                */


            }
        }

    }


    /*------------------------------------------------------------*/
    /*                           GETTER                           */
    /*------------------------------------------------------------*/

    // Input: Coordinates
    VectorCoord getValue( VectorCoord coordPos ){

        VectorGrid gridPos = coordPos.transToGrid();
        int col = gridPos.x;
        int row = gridPos.y;

        VectorCoord flow = new VectorCoord( 0, 0 );
        if( col < cfg.SIMULATION_COLUMNS && col >= 0 && row < cfg.SIMULATION_ROWS && row >= 0)
            flow = this.grid[ col ][ row ]; //CHECK

        return flow;

    }

    /*------------------------------------------------------------*/
    /*                           SETTER                           */
    /*------------------------------------------------------------*/

    // Input: VectorGrid
    void update( VectorGrid gridPos, VectorCoord flow ){

        int col = gridPos.x;
        int row = gridPos.y;

        if( col < cfg.SIMULATION_COLUMNS && col >= 0 && row < cfg.SIMULATION_ROWS && row >= 0)
            this.grid[ col ][ row ] = flow;

    }

    /*------------------------------------------------------------*/
    /*                           DISPLAY                          */
    /*------------------------------------------------------------*/

    void draw(){

        for( int col = 0; col < cfg.SIMULATION_COLUMNS; col++ ){
            for( int row = 0; row < cfg.SIMULATION_ROWS; row++ ){

                // Get grid value
                float value = this.grid[ col ][ row ].mag();

                VectorGrid gridPos = new VectorGrid( col, row );
                this.drawCell( gridPos, value );

            }
        }

    }

    void drawCell( VectorGrid gridPos, float value ){

        // Get screen position for grid cell
        VectorScreen screenPos = gridPos.transToScreen();
        int x = screenPos.x;   // x position of rectangle
        int y = screenPos.y;   // y position of rectangle

        // If field is not discovered yet, draw it white
        color c = 255;

        // If the field is already discovered, draw the color in it
        if( value != -1 ){

            // Generate a percentage value
            float colorValue = map( value, minValue, maxValue, 0, 1);

            c = lerpColor( cfg.COLOR_COLORMAP_START, cfg.COLOR_COLORMAP_END, colorValue );

        }

        stroke( c );
        fill( c );
        rect( x, y, cfg.SIMULATION_GRID_SIZE, cfg.SIMULATION_GRID_SIZE );

    }

}
