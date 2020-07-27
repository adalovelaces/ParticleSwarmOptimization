class VectorGrid {

    protected int x;
    protected int y;

    VectorGrid( int _posX, int _posY ){

        this.x = _posX;
        this.y = _posY;

    }

    // BEFORE: x is in range [0,30], y is in range [0,30] --> [rows,cols]
    // AFTER: x is in range [0,600], y is in range [0,600] --> [cfg.screenX,cfg.screenY]

    VectorScreen transToScreen(){

        int startX = cfg.SIMULATION_START_X;
        int startY = cfg.SIMULATION_START_Y;

        int a = this.x * cfg.SIMULATION_GRID_SIZE + startX; // map( x, 0, cols, 0, screenX);
        int b = this.y * cfg.SIMULATION_GRID_SIZE + startY; //map( y, 0, rows, 0, screenY);

        return new VectorScreen( a, b );

    }

    // BEFORE: x is in range [0,30], y is in range [0,30] --> [rows,cols]
    // AFTER x is in range [-15,15], y is in range [-15,15] --> [cfg.xMin,cfg.xMax]

    VectorCoord transToCoordinate(){

        int cols = cfg.SIMULATION_COLUMNS;
        int rows = cfg.SIMULATION_ROWS;

        if( x >= cols ){
            x = cols - 1;
        }

        if( x < 0 ){
            x = 0;
        }

        if( y >= rows ){
            y = rows - 1;
        }

        if( y < 0 ){
            y = 0;
        }

        float a = grid[ x ][ y ].x;     // Get the real grid values
        float b = grid[ x ][ y ].y;     // Get the real grid values

        return new VectorCoord( a, b - 0.5 );

    }

}
