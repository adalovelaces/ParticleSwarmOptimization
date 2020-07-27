class VectorCoord{

    protected float x;
    protected float y;

    VectorCoord(){

        this.x = 0;
        this.y = 0;

    }

    VectorCoord( VectorCoord _pos ){

        this.x = _pos.x;
        this.y = _pos.y;

    }

    VectorCoord( float _posX, float _posY ){

        this.x = _posX;
        this.y = _posY;

    }

    VectorCoord copy(){

        return new VectorCoord( this.x, this.y );

    }

    float distance( VectorCoord vec ){

        float a = ( vec.x - this.x ) * ( vec.x - this.x );
        float b = ( vec.y - this.y ) * ( vec.y - this.y );
        float c = a + b;
        float result = (float) Math.sqrt( (double) c );
        return result;

    }

    void rotate( double angleInDegrees ){

        double angleInRadians = angleInDegrees * (Math.PI/180);

        //if( angleInDegrees > 0 ){

        float ca = (float) cos( (float) angleInRadians );
        float sa = (float) sin( (float) angleInRadians );

        float x = ca * this.x - sa * this.y;
        float y = sa * this.x + ca * this.y;

        this.x = x;
        this.y = y;

        //}
/*
        if( angleInDegrees < 0 ){


            float ca = (float) cos( (float) angleInRadians );
            float sa = (float) sin( (float) angleInRadians );

            float x = -ca * this.x + sa * this.y;
            float y = -sa * this.x - ca * this.y;

            this.x = x;
            this.y = y;
        }
*/
    }

    void mult( VectorCoord vec ){

        this.x = this.x * vec.x;
        this.y = this.y * vec.y;

    }

    void mult( float v ){

        this.x = this.x * v;
        this.y = this.y * v;

    }

    void div( float v ){

        this.x = this.x / v;
        this.y = this.y / v;

    }

    void sub( VectorCoord v ){

        this.x -= v.x;
        this.y -= v.y;

    }

    VectorCoord sub ( VectorCoord positionA, VectorCoord positionB ){

        PVector vecA = new PVector( positionA.x, positionA.y );
        PVector vecB = new PVector( positionB.x, positionB.y );
        PVector sub = PVector.sub( vecA, vecB );

        return new VectorCoord( sub.x, sub.y );

    }

    void add( VectorCoord v ){

        this.x += v.x;
        this.y += v.y;

    }

    void normalize(){

        PVector pVec = new PVector( this.x, this.y );
        pVec.normalize();

        this.x = pVec.x;
        this.y = pVec.y;

    }

    void limit( float maxValue ){

        PVector pVec = new PVector( this.x, this.y );
        pVec.limit( maxValue );

        this.x = pVec.x;
        this.y = pVec.y;

    }

    double getAngle( VectorCoord b ){

        VectorCoord a = new VectorCoord( this.x, this.y );

        a.normalize();
        b.normalize();
        double cos = (double) (a.x * b.x + a.y * b.y );

        double x1 = (double) a.x;
        double x2 = (double) b.x;
        double y1 = (double) a.y;
        double y2 = (double) b.y;
        double dot = x1*x2 + y1*y2;
        double det = x1*y2 - y1*x2;
        double angleRadian = Math.atan2(det, dot);

        return 180/Math.PI * angleRadian;

    }

    void discretize(){

        VectorCoord c = new VectorCoord( this.x, this.y );
        c.mult( 1 / cfg.SIMULATION_SUBITERATIONS );

        this.x = c.x;
        this.y = c.y;

    }

    float mag(){

        return new PVector( this.x, this.y ).mag();

    }

    PVector transToPVector(){

        return new PVector( this.x, this.y );

    }

    // BEFORE: x is in range [-15,15], y is in range [-15,15] --> [cfg.xMin,cfg.xMax]
    // AFTER: x is in range [0,30], y is in range [0,30] --> [rows,cols]

    VectorGrid transToGrid(){

        float xMin = cfg.SIMULATION_MIN_X;
        float xMax = cfg.SIMULATION_MAX_X;
        float yMin = cfg.SIMULATION_MIN_Y;
        float yMax = cfg.SIMULATION_MAX_Y;
        int cols = cfg.SIMULATION_COLUMNS;
        int rows = cfg.SIMULATION_ROWS;

        float a = map( this.x, xMin, xMax, 0, cols );
        float b = map( this.y, yMax, yMin, 0, rows );

        int u = (int) Math.floor(a);
        int v = (int) Math.floor(b);

        return new VectorGrid( u, v );

    }

    // BEFORE: x is in range [-15,15], y is in range [-15,15] --> [cfg.xMin,cfg.xMax]
    // AFTER: x is in range [0,600], y is in range [0,600] --> [cfg.screenX,cfg.screenY]

    VectorScreen transToScreen(){

        float xMin = cfg.SIMULATION_MIN_X;
        float xMax = cfg.SIMULATION_MAX_X;
        float yMin = cfg.SIMULATION_MIN_Y;
        float yMax = cfg.SIMULATION_MAX_Y;
        int startX = cfg.SIMULATION_START_X;
        int startY = cfg.SIMULATION_START_Y;
        int screenX = cfg.SIMULATION_SIZE_X;
        int screenY = cfg.SIMULATION_SIZE_Y;

        int a = (int) map( this.x, xMin, xMax, startX, screenX + startX);
        int b = (int) map( this.y, yMin, yMax, screenY + startY, startY );

        return new VectorScreen( a, b );

    }

    String toString(){

        String txt = "";

        float u = (float) Math.round( this.x * 100 ) / 100;
        float v = (float) Math.round( this.y * 100 ) / 100;
        //String u = String.format("%.4g", this.x ).replace( ",", "." );
        //String v = String.format("%.4g", this.y ).recplace( ",", "." );
        txt += "[" + u + "," + v + "]";

        return txt;

    }

}
