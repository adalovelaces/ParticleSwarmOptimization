class VectorScreen {

    protected int x;
    protected int y;

    VectorScreen( int _positionX, int _positionY ){

        this.x = _positionX;
        this.y = _positionY;

    }

    float getDistance( VectorScreen otherPosition ){

        return dist( this.x, this.y, otherPosition.x, otherPosition.y );

    }

    void sub( VectorScreen v ){

        this.x -= v.x;
        this.y -= v.y;

    }

    void add( VectorScreen v ){

        this.x += v.x;
        this.y += v.y;

    }

    VectorScreen copy(){

        return new VectorScreen( this.x, this.y );

    }

    // BEFORE: x is in range [0,600], y is in range [0,600] --> [cfg.screenX,cfg.screenY]
    // AFTER: x is in range [-15,15], y is in range [-15,15] --> [cfg.xMin,cfg.xMax]

    VectorCoord transToCoordinate(){

        float xMin = cfg.SIMULATION_MIN_X;
        float xMax = cfg.SIMULATION_MAX_X;
        float yMin = cfg.SIMULATION_MIN_Y;
        float yMax = cfg.SIMULATION_MAX_Y;
        int startX = cfg.SIMULATION_START_X;
        int startY = cfg.SIMULATION_START_Y;
        int screenX = cfg.SIMULATION_SIZE_X;
        int screenY = cfg.SIMULATION_SIZE_Y;

        float a = map( x, startX, screenX + startX, xMin, xMax );
        float b = map( y, startY, screenY + startY, yMax, yMin );

        return new VectorCoord( a, b );

    }

    VectorGrid transToGrid(){

        int cols = cfg.SIMULATION_COLUMNS;
        int rows = cfg.SIMULATION_ROWS;
        int startX = cfg.SIMULATION_START_X;
        int startY = cfg.SIMULATION_START_Y;
        int screenX = cfg.SIMULATION_SIZE_X;
        int screenY = cfg.SIMULATION_SIZE_Y;

        float a = map( x, startX, screenX + startX, 0, cols);
        float b = map( y, startY, screenY + startY, 0, rows);

        int u = (int) Math.floor(a);
        int v = (int) Math.floor(b);

        return new VectorGrid( u, v );

    }

}
